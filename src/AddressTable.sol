//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

contract AddressTable is IAddressTable {
    address[] public accounts;
    mapping(address => uint256) public accountIds;

    constructor() {
        accounts.push(0x0000000000000000000000000000000000000000);
    }

    /**
     * @notice Register an address in the address table
     * @param addr address to register
     * @return index of the address (existing index, or newly created index if not already registered)
     */
    function register(address addr) public override returns (uint256) {
        if (accountIds[addr] == 0) {
            accounts.push(addr);
            accountIds[addr] = accounts.length - 1;

            return accounts.length - 1;
        } else {
            return accountIds[addr];
        }
    }

    /**
     * @param addr address to lookup
     * @return index of an address in the address table (revert if address isn't in the table)
     */
    function lookup(address addr) external view override returns (uint256) {
        if  (accountIds[addr] == 0) revert("address not registered");
        return accountIds[addr];
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
