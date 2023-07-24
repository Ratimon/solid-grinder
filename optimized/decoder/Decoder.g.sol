//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAddressTable} from "@solid-grinder/interfaces/IAddressTable.sol";
import {BytesLib} from "@main/libraries/BytesLib.sol";


contract UniswapV2Router02_DataDecoder {


    using BytesLib for bytes;
    IAddressTable public immutable addressTable;

    constructor(IAddressTable _addressTable) {
        addressTable = _addressTable;
    }

    struct addLiquiditydata {
        
        address tokenA;
        
        address tokenB;
        
        uint256 amountADesired;
        
        uint256 amountBDesired;
        
        uint256 amountAMin;
        
        uint256 amountBMin;
        
        address to;
        
        uint256 deadline;
        
    }

}