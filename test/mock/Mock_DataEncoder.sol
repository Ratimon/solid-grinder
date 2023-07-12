//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2} from "@forge-std/console2.sol";

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

contract Mock_DataEncoder {
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
     * @dev
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
}
