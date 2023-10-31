//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {console2} from "@forge-std/console2.sol";
import {Test, stdError} from "@forge-std/Test.sol";

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";
import {AddressTable} from "@main/AddressTable.sol";

contract AddressTableTest is Test {
    string mnemonic = "test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8

    address deployer = vm.addr(deployerPrivateKey);
    address alice = makeAddr("Alice");
    address bob = makeAddr("Bob");

    AddressTable table;

    function setUp() public {
        vm.startPrank(deployer);

        vm.deal(deployer, 1 ether);
        vm.label(deployer, "Deployer");

        table = new AddressTable();
        vm.label(address(table), "AddressTable");

        vm.stopPrank();
    }

    function test_register() external {
        vm.startPrank(bob);


        assertEq(table.size(), 1, "The initial size ( including zero address) should be 1");
        assertFalse(table.isAddressExisted(alice), "The address should not be existed");

        uint256 indexValue_ = table.register(alice);
        assertEq(indexValue_, 1, "The first index should be 1");

        indexValue_ = table.lookup(alice);
        assertEq(indexValue_, 1, "The first index should be 1");
        assertEq(table.size(), 2, "The size should be 2");
        assertTrue(table.isAddressExisted(alice), "The address should be existed");

        vm.stopPrank();
    }

    function test_double_register() external {
        vm.startPrank(bob);


        table.register(alice);
        uint256 indexValue_ = table.register(bob);
        assertEq(indexValue_, 2, "The second index should be 2");

        indexValue_ = table.lookup(bob);
        assertEq(indexValue_, 2, "The first index should be 2");
        assertEq(table.size(), 3, "The size should be 3");
        assertTrue(table.isAddressExisted(bob), "The address should be existed");

        vm.stopPrank();
    }


    function test_RevertWhen_noRegister_lookup() external {
        vm.startPrank(alice);

        vm.expectRevert(bytes("AddressTable: must register first"));
        table.lookup(alice);

        vm.stopPrank();
    }

    function test_RevertWhen_indexOOBError_lookupIndex() external {
        vm.startPrank(alice);

        vm.expectRevert(stdError.indexOOBError);
        table.lookupIndex(10);

        vm.stopPrank();
    }
}
