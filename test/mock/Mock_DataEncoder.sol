//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2} from "@forge-std/console2.sol";

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

import {BytesLib} from "@main/libraries/BytesLib.sol";

contract Mock_DataEncoder {
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

    uint8 constant private AddLiquidity_tokenA_BitSize = 24;
    uint8 constant private AddLiquidity_tokenB_BitSize = 24;

    uint8 constant private AddLiquidity_amountADesired_BitSize = 96;
    uint8 constant private AddLiquidity_amountBDesired_BitSize = 96;
    uint8 constant private AddLiquidity_amountAMin_BitSize = 96;
    uint8 constant private AddLiquidity_amountBMin_BitSize = 96;

    uint8 constant private AddLiquidity_to_BitSize = 24;
    uint8 constant private AddLiquidity_deadline_BitSize = 40;

    uint8[] public unpackedBits;

    uint8[] public subBits;
    uint8[][] public packedBits;


    constructor(
        IAddressTable _addressTable
    ) {
        addressTable = _addressTable;
        initPackedBits();
    }

    /**
     * @notice init the array to store the byte chunks to be encode
     * @dev 
     *
     */
     function initPackedBits() private  {
                                                        // 240 bits
        // [24, 24, 96 , 96 ] : 240 bits        => [ [24, 24, 96 , 96] ]

                                                    // 240(+16)           // 256  
        // [24, 24, 96 , 96, 96 , 96, 24, 40  ] => [ [24, 24, 96 , 96], [96, 96, 24, 40] ]

        // if all element accumulated sum <= 256 bits, just push to the current subarray
        // if all element accumulated sum >= 256 bits , skip the current subarr and psuh to next subarray / renew the sum tracker

        // unpackedBits = [];
        unpackedBits.push(AddLiquidity_tokenA_BitSize);
        unpackedBits.push(AddLiquidity_tokenB_BitSize);
        unpackedBits.push(AddLiquidity_amountADesired_BitSize);
        unpackedBits.push(AddLiquidity_amountBDesired_BitSize);
        unpackedBits.push(AddLiquidity_amountAMin_BitSize);
        unpackedBits.push(AddLiquidity_amountBMin_BitSize);
        unpackedBits.push(AddLiquidity_to_BitSize);
        unpackedBits.push(AddLiquidity_deadline_BitSize);

        // uint8[][] memory packedBits = new uint8[][]();

        uint16 bitsSum = 0;

        // packedBits = new uint8[][]
        // console2.log('unpackedBits.length', unpackedBits.length);

        for (uint i = 0; i < unpackedBits.length; i++) {

            bitsSum += unpackedBits[i];

            console2.log('bitsSum: i', i);
            console2.log('bitsSum', bitsSum);

            if (bitsSum > 256) {
                packedBits.push(subBits);
                delete subBits;
                
                bitsSum = unpackedBits[i];
            } 

            console2.log('unpackedBits[i]', unpackedBits[i]);

            subBits.push(unpackedBits[i]);

        }
        packedBits.push(subBits);

        delete subBits;

     }



}