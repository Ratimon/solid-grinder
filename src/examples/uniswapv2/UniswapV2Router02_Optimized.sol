//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {UniswapV2Router02} from "@main/examples/uniswapv2/UniswapV2Router02.sol";

import {DataDecoding} from "@main/DataDecoding.sol";


/**
* @notice optimized version
*/
contract UniswapV2Router02_Optimized is UniswapV2Router02, Ownable, DataDecoding  {

    constructor(
        address _factory,
        address _WETH,
        IAddressTable _addressTable,
        bool _autoRegisterAddressMapping
    )
        UniswapV2Router02(_factory, _WETH)
        DataDecoding(_addressTable, _autoRegisterAddressMapping)
    {
        _setAutoRegisterAddressMapping(true);
    }

    function setAutoRegisterAddressMapping(
        bool _enable
    )
        external
        onlyOwner
    {
        _setAutoRegisterAddressMapping(_enable);
    }

    function addLiquidityCompressed(
        bytes calldata _payload
    )
        external
        payable
        returns(uint amountA, uint amountB, uint liquidity)
    {
        (
            AddLiquidityData memory addLiquidityData,
            
        ) = decodeAddLiquidityData(_payload, 0);

        return UniswapV2Router02.addLiquidity(
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
