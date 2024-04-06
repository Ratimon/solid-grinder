//SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

import {IERC20} from "@openzeppelin-contracts-solc_0_7/contracts/token/ERC20/IERC20.sol";

import {IUniswapV2Factory} from "@main/solc_0_7/examples/uniswapv2/IUniswapV2Factory.sol";
import {IUniswapV2Pair} from "@main/solc_0_7/examples/uniswapv2/IUniswapV2Pair.sol";
import {IUniswapV2Router02} from "@main/solc_0_7/examples/uniswapv2/IUniswapV2Router02.sol";

import {SafeMath} from "@openzeppelin-contracts-solc_0_7/contracts/math/SafeMath.sol";
import {SafeERC20} from "@openzeppelin-contracts-solc_0_7/contracts/token/ERC20/SafeERC20.sol";

import {UniswapV2Library} from "@main/solc_0_7/examples/uniswapv2/UniswapV2Library.sol";

/**
 * @notice modifed version of UniswapV2Router02: https://github.com/Uniswap/v2-periphery/blob/master/contracts/UniswapV2Router02.sol
 */
contract UniswapV2Router02 is IUniswapV2Router02 {
    using SafeMath for uint256;

    address public immutable override factory;
    address public immutable override WETH;

    modifier ensure(uint256 deadline) {
        require(deadline >= block.timestamp, "UniswapV2Router: EXPIRED");
        _;
    }

    constructor(address _factory, address _WETH) {
        factory = _factory;
        WETH = _WETH;
    }

    receive() external payable {
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    // **** ADD LIQUIDITY ****
    function _addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) internal virtual returns (uint256 amountA, uint256 amountB) {
        // create the pair if it doesn't exist yet
        if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
            IUniswapV2Factory(factory).createPair(tokenA, tokenB);
        }
        (uint256 reserveA, uint256 reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
        if (reserveA == 0 && reserveB == 0) {
            (amountA, amountB) = (amountADesired, amountBDesired);
        } else {
            uint256 amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");
                (amountA, amountB) = (amountADesired, amountBOptimal);
            } else {
                uint256 amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
                assert(amountAOptimal <= amountADesired);
                require(amountAOptimal >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");
                (amountA, amountB) = (amountAOptimal, amountBDesired);
            }
        }
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) public virtual override ensure(deadline) returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
        address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
        SafeERC20.safeTransferFrom(IERC20(tokenA), msg.sender, pair, amountA);
        SafeERC20.safeTransferFrom(IERC20(tokenB), msg.sender, pair, amountB);
        liquidity = IUniswapV2Pair(pair).mint(to);
    }
}
