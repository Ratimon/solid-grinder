//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2} from "@forge-std/console2.sol";

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

contract UniswapV2Router02_DataEncoder {
    IAddressTable public immutable addressTable;

    // 24-bit, 16,777,216 possible
    // 32-bit, 4,294,967,296  possible
    // 40-bit, 1,099,511,627,776 => ~35k years
    // 72-bit, 4,722 (18 decimals)
    // 88-bit, 309m (18 decimals)
    // 96-bit,  79b or 79,228,162,514 (18 decimals)

    uint8 private constant AddLiquidity_tokenA_BitSize = 24;
    uint8 private constant AddLiquidity_tokenB_BitSize = 24;

    uint8 private constant AddLiquidity_amountADesired_BitSize = 96;
    uint8 private constant AddLiquidity_amountBDesired_BitSize = 96;
    uint8 private constant AddLiquidity_amountAMin_BitSize = 96;
    uint8 private constant AddLiquidity_amountBMin_BitSize = 96;

    uint8 private constant AddLiquidity_to_BitSize = 24;
    uint8 private constant AddLiquidity_deadline_BitSize = 40;

    uint8[] public unpackedBits;
    uint8[] public subBits;
    uint8[][] public packedBits;

    constructor(IAddressTable _addressTable) {
        addressTable = _addressTable;
        initPackedBits();
    }

    /**
     * @notice init the array to store the byte chunks to be encode
     *
     */
    function initPackedBits() private {
        // 240 bits
        // [24, 24, 96 , 96 ] : 240 bits        => [ [24, 24, 96 , 96] ]
        // 240(+16)           // 256
        // [24, 24, 96 , 96, 96 , 96, 24, 40  ] => [ [24, 24, 96 , 96], [96, 96, 24, 40] ]

        // if all element accumulated sum <= 256 bits, just push to the current subBits
        // if all element accumulated sum >= 256 bits , skip the current subBits and psuh to next subarray / renew the tracker

        // unpackedBits = [];
        unpackedBits.push(AddLiquidity_tokenA_BitSize);
        unpackedBits.push(AddLiquidity_tokenB_BitSize);
        unpackedBits.push(AddLiquidity_amountADesired_BitSize);
        unpackedBits.push(AddLiquidity_amountBDesired_BitSize);
        unpackedBits.push(AddLiquidity_amountAMin_BitSize);
        unpackedBits.push(AddLiquidity_amountBMin_BitSize);
        unpackedBits.push(AddLiquidity_to_BitSize);
        unpackedBits.push(AddLiquidity_deadline_BitSize);

        uint16 bitsSum = 0;

        for (uint256 i = 0; i < unpackedBits.length; i++) {
            bitsSum += unpackedBits[i];
            if (bitsSum > 256) {
                packedBits.push(subBits);
                delete subBits;
                bitsSum = unpackedBits[i];
            }
            subBits.push(unpackedBits[i]);
        }
        packedBits.push(subBits);
        delete subBits;
    }

    // first packed  256 bits (32 bytes) : 24+24+96+96 (+16 as padded) = 240 + 16 of 256

    // uint256 tokenA , 24-bit, 16,777,216 possible # of addresses
    // uint256 tokenB,  24-bit, 16,777,216 possible # of addresses

    // uint256 amountADesired, // 96-bit, 79,228,162,514 (18 decimals)
    // uint256 amountBDesired, // 96-bit, 79,228,162,514 (18 decimals)

    // second packed of 256 bits (32 bytes) : 96+96+24+40 = 256 of 256

    // uint256 amountAMin, // 96-bit, 79,228,162,514 (18 decimals)
    // uint256 amountBMin, // 96-bit, 79,228,162,514 (18 decimals)

    // uint256 to,      // 24-bit, 16,777,216 possible # of addresses
    // uint40 deadline, // 40-bit, 1,099,511,627,776 (18 decimals) => ~35k years

    /**
     * @dev same abi as original one, but different return
     */
    function encode_AddLiquidityData(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        view
        returns (
            bytes memory _compressedPayload // bytes32 _compressedPayload
        )
    {
        uint256 tokenAIndex = addressTable.lookup(tokenA);
        uint256 tokenBIndex = addressTable.lookup(tokenB);
        require(
            tokenAIndex <= type(uint24).max,
            "UniswapV2Router02_DataEncoder: encode_AddLiquidityData tokenAIndex is too large, uint24 support only."
        );
        require(
            tokenBIndex <= type(uint24).max,
            "UniswapV2Router02_DataEncoder: encode_AddLiquidityData tokenBIndex is too large, uint24 support only."
        );

        require(
            amountADesired <= type(uint96).max,
            "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountADesired is too large, uint96 support only."
        );
        require(
            amountBDesired <= type(uint96).max,
            "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountBDesired is too large, uint96 support only."
        );

        require(
            amountAMin <= type(uint96).max,
            "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountAMin is too large, uint96 support only."
        );
        require(
            amountBMin <= type(uint96).max,
            "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountBMin is too large, uint96 support only."
        );

        uint256 toIndex = addressTable.lookup(to);

        require(
            toIndex <= type(uint24).max,
            "UniswapV2Router02_DataEncoder: encode_AddLiquidityData toIndex is too large, uint24 support only."
        );

        require(
            deadline <= type(uint40).max,
            "UniswapV2Router02_DataEncoder: encode_AddLiquidityData amountBMin is too large, uint40 support only."
        );

        uint256[] memory unpackedArguments = new uint256[](unpackedBits.length);
        uint8 unpackedArgumentsIndex;
        unpackedArguments[unpackedArgumentsIndex] = tokenAIndex;
        unpackedArgumentsIndex++;
        unpackedArguments[unpackedArgumentsIndex] = tokenBIndex;
        unpackedArgumentsIndex++;
        unpackedArguments[unpackedArgumentsIndex] = amountADesired;
        unpackedArgumentsIndex++;
        unpackedArguments[unpackedArgumentsIndex] = amountBDesired;
        unpackedArgumentsIndex++;
        unpackedArguments[unpackedArgumentsIndex] = amountAMin;
        unpackedArgumentsIndex++;
        unpackedArguments[unpackedArgumentsIndex] = amountBMin;
        unpackedArgumentsIndex++;
        unpackedArguments[unpackedArgumentsIndex] = toIndex;
        unpackedArgumentsIndex++;
        unpackedArguments[unpackedArgumentsIndex] = deadline;
        unpackedArgumentsIndex++;
        require(unpackedArguments.length == unpackedBits.length, "length must equal");
        delete unpackedArgumentsIndex;

        for (uint256 i = 0; i < packedBits.length; i++) {
            for (uint256 j = 0; j < packedBits[i].length; j++) {
                console2.log('i',unpackedArguments[unpackedArgumentsIndex]);
                _compressedPayload =
                    concatPayload(packedBits[i][j], _compressedPayload, unpackedArguments[unpackedArgumentsIndex]);
                unpackedArgumentsIndex++;
            }
        }
    }

    function concatPayload(uint8 _bitSize, bytes memory _payload, uint256 value)
        private
        pure
        returns (bytes memory _newPayload)
    {
        if (_bitSize == 24) {
            _newPayload = abi.encodePacked(_payload, uint24(value));
        } else if (_bitSize == 40) {
            _newPayload = abi.encodePacked(_payload, uint40(value));
        } else if (_bitSize == 96) {
            _newPayload = abi.encodePacked(_payload, uint96(value));
        } else {
            revert("UniswapV2Router02_DataEncoder: bad bitsize");
        }
    }
}
