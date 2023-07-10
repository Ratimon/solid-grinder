//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

import {BytesLib} from "@main/libraries/BytesLib.sol";

contract UniswapV2Router02_DataEncoder {
    using BytesLib for bytes;

    IAddressTable public immutable addressTable;

    // struct AddLiquidityData_Size {
    //     uint8 tokenA_Size;
    //     uint8 tokenB_Size;
        
    //     uint8 amountADesired_Size;
    //     uint8 amountBDesired_Size;
    //     uint8 amountAMin_Size;
    //     uint8 amountBMin_Size;

    //     uint8 to_Size;
    //     uint8 deadline_Size;
    // }


    // 3
    uint8 constant private AddLiquidity_tokenA_BitSize = 24;
    uint8 constant private AddLiquidity_tokenB_BitSize = 24;

    uint8 constant private AddLiquidity_amountADesired_BitSize = 96;
    uint8 constant private AddLiquidity_amountBDesired_BitSize = 96;
    uint8 constant private AddLiquidity_amountAMin_BitSize = 96;
    uint8 constant private AddLiquidity_amountBMin_BitSize = 96;

    uint8 constant private AddLiquidity_to_BitSize = 24;
    uint8 constant private AddLiquidity_deadline_BitSize = 40;




    constructor(
        IAddressTable _addressTable
    ) {
        addressTable = _addressTable;
    }

    /**
     * @notice init the array to store the byte chunks to be encode
     * @dev 
     *
     */
     function init() external  {
                                                    // 240 bits
    // [24, 24, 96 , 96 ] : 240 bits        => [ [24, 24, 96 , 96] ]

                                                  // 240(+16)           // 256  
    // [24, 24, 96 , 96, 96 , 96, 24, 40  ] => [ [24, 24, 96 , 96], [96, 96, 24, 24], [14, 242] ]

    // if all element accumulated sum <= 256 bits, just push to the current subarray
    // if all element accumulated sum >= 256 bits , skip the current subarr and psuh to next subarray / renew the sum tracker
    }



    function getCursors(uint8 _bitSize, uint8 _cursor ) private pure returns(uint8 cachedCursor,uint8 byteSize, uint8 newCursor){
        cachedCursor = _cursor;
        byteSize = _bitSize / 8;
        newCursor = _cursor+ byteSize;
    }

    function getEncodedBytes(uint8 _bitSize ) private pure returns(uint8 byteSize){
        byteSize = _bitSize / 8;
    }


    // 24-bit, 16,777,216 possible
    // 32-bit, 4,294,967,296  possible
    // 40-bit, 1,099,511,627,776 => ~35k years
    // 72-bit, 4,722 (18 decimals)
    // 88-bit, 309m (18 decimals)
    // 96-bit,  79b or 79,228,162,514 (18 decimals)

    //****** first packed  256 bits (32 bytes) : 24+24+96+96 (+8+8 as instruction) = 240 + 16 of 256 (16 bits left)

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


        // // increase cursor and check if it should be padded or not
        // uint8 cursor;
        // uint8 byteSize;
        // uint8 newCursor;
        // // tokenAIndex 
        // ( cursor, byteSize, newCursor) = getCursors(AddLiquidity_tokenA_BitSize, cursor);
        // if( cursor + byteSize < 32) {

        // }

        // // tokenBIndex
        // cursor += getEncodedBytes(AddLiquidity_tokenB_BitSize, cursor);
        // // amountADesired
        // cursor += getEncodedBytes(AddLiquidity_amountADesired_BitSize, cursor);
        // // amountBDesired
        // cursor += getEncodedBytes(AddLiquidity_amountBDesired_BitSize, cursor);
        // // amountAMin
        // cursor += getEncodedBytes(AddLiquidity_amountAMin_BitSize, cursor);
        // // amountBMin
        // cursor += getEncodedBytes(AddLiquidity_amountBMin_BitSize, cursor);
        // // to
        // cursor += getEncodedBytes(AddLiquidity_to_BitSize, cursor);
        // // deadline
        // cursor += getEncodedBytes(AddLiquidity_deadline_BitSize, cursor);

        // if (cursor + nextBytes )


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