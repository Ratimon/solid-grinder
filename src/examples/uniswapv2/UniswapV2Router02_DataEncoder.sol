//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

import {BytesLib} from "@main/libraries/BytesLib.sol";

contract UniswapV2Router02_DataEncoder {
    using BytesLib for bytes;

    IAddressTable public immutable addressTable;

    constructor(
        IAddressTable _addressTable
    ) {
        addressTable = _addressTable;
    }



    // 24-bit, 16,777,216 possible
    // 32-bit, 4,294,967,296  possible
    // 40-bit, 1,099,511,627,776 => ~35k years
    // 72-bit, 4,722 (18 decimals)
    // 88-bit, 309m (18 decimals)
    // 96-bit,  79b or 79,228,162,514 (18 decimals)

    //****** first packed  256 bits (32 bytes) : 24+24+96+96 (+8+8 as instruction) = 156 + ( 2 instructions) of 256 (16 bytes left)

    // uint256 tokenA , // 24-bit, 16,777,216 possible # of addresses
    // uint256 tokenB, //  24-bit, 16,777,216 possible # of addresses

    // uint256 amountADesired, // 96-bit, 79,228,162,514 (18 decimals)
    // uint256 amountBDesired, // 96-bit, 79,228,162,514 (18 decimals)

    //****** second packed of 256 bits (32 bytes) : 96+96 +24 (+8+8 as instruction) = 256 of 256

    // uint256 amountAMin, // 96-bit, 79,228,162,514 (18 decimals)
    // uint256 amountBMin, // 96-bit, 79,228,162,514 (18 decimals)

    // uint256 to,      // 24-bit, 16,777,216 possible # of addresses
    // uint40 deadline, // 40-bit, 1,099,511,627,776 (18 decimals) => ~35k years



    // struct AddLiquidityData {
    //     address tokenA;
    //     address tokenB;
        
    //     uint amountADesired;
    //     uint amountBDesired;
    //     uint amountAMin;
    //     uint amountBMin;

    //     address to;
    //     uint deadline;
    // }

    /**
     * @dev same abi as original one, but different return
     */
    function encode_AddLiquidityData(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    )
    external
    view
    returns(
        bytes memory _compressedPayload // bytes32 _compressedPayload
    )
    {

        uint256 tokenAIndex = addressTable.lookup(tokenA);
        uint256 tokenBIndex = addressTable.lookup(tokenB);

        require(tokenAIndex <= type(uint24).max, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData tokenAIndex is too large, uint24 support only.");
        require(tokenBIndex <= type(uint24).max, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData tokenBIndex is too large, uint24 support only.");


        require(amountADesired <= type(uint96).max, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountADesired is too large, uint96 support only.");
        require(amountBDesired <= type(uint96).max, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountBDesired is too large, uint96 support only.");

        // _compressedPayload = abi.encodePacked(
        //     uint24(tokenAIndex),
        //     uint24(tokenBIndex),
        //     uint96(amountADesired),
        //     uint96(amountBDesired)
        // );

        require(amountAMin <= type(uint96).max, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountAMin is too large, uint96 support only.");
        require(amountBMin <= type(uint96).max, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountBMin is too large, uint96 support only.");
        require(deadline <= type(uint40).max, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountBMin is too large, uint40 support only.");

        uint256 toIndex = addressTable.lookup(to);

        require(toIndex <= type(uint24).max, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData toIndex is too large, uint24 support only.");

        _compressedPayload = abi.encodePacked(
            uint24(tokenAIndex),
            uint24(tokenBIndex),
            uint8(1),uint96(amountADesired),
            uint8(1),uint96(amountBDesired)
        );

        // token instruction: 1 (8 bit + 96-bit ) 13 bytes 26 hex
        // uint8 instructions = 1 << 13;
        // uint8 instructions = 1;
        // instructions += uint96(amountADesired);


        // // instruction: 2 (24-bit)
        // uint8 instructions = 2 << 6;

        require(_compressedPayload.length == 32, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData length is not 32");


        _compressedPayload = abi.encodePacked(
            uint8(1),uint96(amountAMin),
            uint8(1),uint96(amountBMin),
            uint24(toIndex),
            // uint40(deadline)
            uint40(deadline) // break into uint16
        );

        require(_compressedPayload.length == 64, "UniswapV2Router02_DataEncoder: encode_AddLiquidityData length is not 32");


    }

}