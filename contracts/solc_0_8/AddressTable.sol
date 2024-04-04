//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAddressTable} from "@solid-grinder/solc_0_8/interfaces/IAddressTable.sol";

/**
  * @title Solid Grinder's address table contract to store the mapping between addresses and indexes. More info : https://github.com/Ratimon/solid-grinder#how-it-works
  * @author Rati Montreewat 
  * @notice Supports only for version 0.8.0
  */
contract AddressTable is IAddressTable {
    address[] public accounts;
    mapping(address => uint256) public accountIds;

    /**
     * @notice Construct an account table
     */
    constructor() {
        accounts.push(0x0000000000000000000000000000000000000000);
    }

    /**
     * @notice Register an address in the address table
     * @param addr address to register
     * @return indexValue index of the address (existing index, or newly created index if not already registered)
     */
    function register(address addr) public override returns (uint256 indexValue) {
        indexValue = accountIds[addr];
        if (indexValue == 0) {
            accounts.push(addr);
            unchecked {
                indexValue = accounts.length - 1;
            }
            accountIds[addr] = indexValue;
        }
    }

    /**
     * @param addr address to lookup
     * @return indexValue index of an address in the address table (revert if address isn't in the table)
     */
    function lookup(address addr) external view override returns (uint256 indexValue) {
        indexValue = accountIds[addr];
        if (indexValue == 0) revert("AddressTable: must register first");
    }

    /**
     * @notice Check whether an address exists in the address table
     * @param addr address to check for presence in table
     * @return true if address is in table
     */
    function isAddressExisted(address addr) external view override returns (bool) {
        return accountIds[addr] != 0;
    }

    /**
     * @return size of address table (= first unused index)
     */
    function size() external view override returns (uint256) {
        return accounts.length;
    }

    /**
     * @param index index to lookup address
     * @return address at a given index in address table (revert if index is beyond end of table)
     */
    function lookupIndex(uint256 index) external view override returns (address) {
        return accounts[index];
    }
}
