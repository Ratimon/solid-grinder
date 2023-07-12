//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2} from "@forge-std/console2.sol";

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {UniswapV2Router02_DataDecoder} from "@main/examples/uniswapv2/UniswapV2Router02_DataDecoder.sol";

contract Mock_DataDecoder is UniswapV2Router02_DataDecoder {

    constructor( IAddressTable _addressTable)
        UniswapV2Router02_DataDecoder(_addressTable)
    {
    }

    function decode_AddLiquidityData(bytes calldata _payload)
    external
    payable
    returns (address, address, uint256, uint256, uint256, uint256, address, uint256 )
{
    (AddLiquidityData memory addLiquidityData,) = _decode_AddLiquidityData(_payload, 0);

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
