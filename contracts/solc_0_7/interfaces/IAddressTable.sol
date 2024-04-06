//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

interface IAddressTable {
    /**
     * @notice Register an address in the address table
     * @param addr address to register
     * @return index of the address (existing index, or newly created index if not already registered)
     */
    function register(address addr) external returns (uint256);

    /**
     * @param addr address to lookup
     * @return index of an address in the address table (revert if address isn't in the table)
     */
    function lookup(address addr) external view returns (uint256);

    /**
     * @notice Check whether an address exists in the address table
     * @param addr address to check for presence in table
     * @return true if address is in table
     */
    function isAddressExisted(address addr) external view returns (bool);

    /**
     * @return size of address table (= first unused index)
     */
    function size() external view returns (uint256);

    /**
     * @param index index to lookup address
     * @return address at a given index in address table (revert if index is beyond end of table)
     */
    function lookupIndex(uint256 index) external view returns (address);
}
