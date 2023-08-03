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
        uint256 tokenA = addressTable.lookup(tokenA);
        uint256 tokenB = addressTable.lookup(tokenB);
        uint256 to = addressTable.lookup(to);
        

    }

}