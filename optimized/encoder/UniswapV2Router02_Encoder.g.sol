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
    

}