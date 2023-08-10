//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2} from "@forge-std/console2.sol";

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {UniswapV2Router02_Decoder} from "@main/examples/uniswapv2/decoder/UniswapV2Router02_Decoder.g.sol";

contract Mock_Decoder is UniswapV2Router02_Decoder {
    constructor(IAddressTable _addressTable) UniswapV2Router02_Decoder(_addressTable) {}

    function decode_addLiquidityData(bytes calldata _payload)
        external
        payable
        returns (address, address, uint256, uint256, uint256, uint256, address, uint256)
    {
        (addLiquidityData memory addLiquidityData,) = _decode_addLiquidityData(_payload, 0);

        return (
            addLiquidityData.tokenA,
            addLiquidityData.tokenB,
            addLiquidityData.amountADesired,
            addLiquidityData.amountBDesired,
            addLiquidityData.amountAMin,
            addLiquidityData.amountBMin,
            addLiquidityData.to,
            addLiquidityData.deadline
        );
    }
}
