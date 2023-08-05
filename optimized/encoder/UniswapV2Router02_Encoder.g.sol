//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";


contract UniswapV2Router02_DataEncode {


    IAddressTable public immutable addressTable;

    uint8 private constant addLiquidity_tokenA_BitSize = 24;
    uint8 private constant addLiquidity_tokenB_BitSize = 24;
    uint8 private constant addLiquidity_amountADesired_BitSize = 96;
    uint8 private constant addLiquidity_amountBDesired_BitSize = 96;
    uint8 private constant addLiquidity_amountAMin_BitSize = 96;
    uint8 private constant addLiquidity_amountBMin_BitSize = 96;
    uint8 private constant addLiquidity_to_BitSize = 24;
    uint8 private constant addLiquidity_deadline_BitSize = 40;
    

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

        unpackedBits.push(addLiquidity_tokenA_BitSize);
        unpackedBits.push(addLiquidity_tokenB_BitSize);
        unpackedBits.push(addLiquidity_amountADesired_BitSize);
        unpackedBits.push(addLiquidity_amountBDesired_BitSize);
        unpackedBits.push(addLiquidity_amountAMin_BitSize);
        unpackedBits.push(addLiquidity_amountBMin_BitSize);
        unpackedBits.push(addLiquidity_to_BitSize);
        unpackedBits.push(addLiquidity_deadline_BitSize);
        

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

    /**
     * @dev same abi as original one, but different return
    */
    function encode_addLiquidityData(
        address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline
    )
        external
        view
        returns (
            bytes memory _compressedPayload
        )
    {
        uint256 tokenAIndex = addressTable.lookup(tokenA);
        require(tokenAIndex <= type(uint24).max, "UniswapV2Router02_DataEncoder: encode_addLiquidityData tokenAIndex is too large, uint24 support only.");
        uint256 tokenBIndex = addressTable.lookup(tokenB);
        require(tokenBIndex <= type(uint24).max, "UniswapV2Router02_DataEncoder: encode_addLiquidityData tokenBIndex is too large, uint24 support only.");
        
        
        
        
        uint256 toIndex = addressTable.lookup(to);
        require(toIndex <= type(uint24).max, "UniswapV2Router02_DataEncoder: encode_addLiquidityData toIndex is too large, uint24 support only.");
        
        
        
        
        require(amountADesired <= type(uint96).max, "UniswapV2Router02_DataEncoder: encode_addLiquidityData amountADesiredIndex is too large, uint96 support only.");
        require(amountBDesired <= type(uint96).max, "UniswapV2Router02_DataEncoder: encode_addLiquidityData amountBDesiredIndex is too large, uint96 support only.");
        require(amountAMin <= type(uint96).max, "UniswapV2Router02_DataEncoder: encode_addLiquidityData amountAMinIndex is too large, uint96 support only.");
        require(amountBMin <= type(uint96).max, "UniswapV2Router02_DataEncoder: encode_addLiquidityData amountBMinIndex is too large, uint96 support only.");
        
        require(deadline <= type(uint40).max, "UniswapV2Router02_DataEncoder: encode_addLiquidityData deadlineIndex is too large, uint40 support only.");
        

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
        } else if (_bitSize == 96) {
            _newPayload = abi.encodePacked(_payload, uint96(value));
        } else if (_bitSize == 40) {
            _newPayload = abi.encodePacked(_payload, uint40(value));
        } else {
            revert("UniswapV2Router02_DataEncoder: bad bitsize");
        }

    }
    

}