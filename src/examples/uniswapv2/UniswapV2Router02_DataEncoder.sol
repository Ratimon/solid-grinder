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

}