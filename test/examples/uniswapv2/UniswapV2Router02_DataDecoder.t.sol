//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {console2} from "@forge-std/console2.sol";
import {Test, stdError} from "@forge-std/Test.sol";

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";
import {AddressTable} from "@main/AddressTable.sol";

import {UniswapV2Router02_DataEncoder} from "@main/examples/uniswapv2/UniswapV2Router02_DataEncoder.sol";
import {UniswapV2Router02_DataDecoder} from "@main/examples/uniswapv2/UniswapV2Router02_DataDecoder.sol";

// import {UniswapV2Router02_Optimized} from "@main/examples/uniswapv2/UniswapV2Router02_Optimized.sol";

contract UniswapV2Router02_DataDecoderTest is Test {
    string mnemonic = "test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8

    address deployer = vm.addr(deployerPrivateKey);
    address alice = makeAddr("Alice");

    AddressTable table;
    UniswapV2Router02_DataEncoder encoder;
    UniswapV2Router02_DataDecoder decoder;

    function setUp() public {
        vm.startPrank(deployer);

        vm.deal(deployer, 1 ether);
        vm.label(deployer, "Deployer");

        table = new AddressTable();
        encoder = new UniswapV2Router02_DataEncoder(table);
        decoder = new UniswapV2Router02_DataDecoder(table);

        vm.label(address(table), "AddressTable");
        vm.label(address(encoder), "UniswapV2Router02_DataEncoder");
        vm.label(address(decoder), "UniswapV2Router02_DataDecoder");

        vm.stopPrank();
    }

    function test_constructor() external {
        vm.startPrank(deployer);

        assertEq(encoder.packedBits(0, 0), 24);
        assertEq(encoder.packedBits(0, 1), 24);
        assertEq(encoder.packedBits(0, 2), 96);
        assertEq(encoder.packedBits(0, 3), 96);

        assertEq(encoder.packedBits(1, 0), 96);
        assertEq(encoder.packedBits(1, 1), 96);
        assertEq(encoder.packedBits(1, 2), 24);
        assertEq(encoder.packedBits(1, 3), 40);

        vm.stopPrank();
    }

    

}