<h1>📚 Solid Grinder 📚</h1>

be optimism gas optimizooor!!

a cli that goes along with building blocks of smart contract. Along with front-end snippets, this toolbox can reduce L2 gas cost by encoding calldata for dApps development to use as little bytes of calldata as  possible.

> **Note**💡

> The code is not audited yet. Please use it carefully in production.

- [What is it for](#what-is-it-for)
- [Benchmarks](#benchmarks)
- [How It Works](#how-it-works)
- [Architecture](#architecture)

## What is it for ?

This dApp building block is intended to reduce L2 gas costs by a significant amount, using calldata optimization paradigm.

While security in our top priority, we aim to enhance developer experience, such that the entire protocol is not required to re-written from scratch.

## Benchmarks

We provide how the UniswapV2's router is optimized as follows:

- The original version:[ `UniswapV2Router02.sol`](https://github.com/Ratimon/solid-grinder/blob/main/src/examples/uniswapv2/UniswapV2Router02.sol)

```solidity
    /** ... */
    contract UniswapV2Router02 is IUniswapV2Router02 {

        /** ... */

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
            /** ... */
        }
        /** ... */
    }

```

- The optimized version: including two components. The first one is [ `UniswapV2Router02_Optimized.sol`](https://github.com/Ratimon/solid-grinder/blob/main/src/examples/uniswapv2/UniswapV2Router02_Optimized.sol) which inherits main functionality from [ `UniswapV2Router02_DataDecoder.sol`](https://github.com/Ratimon/solid-grinder/blob/main/src/examples/uniswapv2/UniswapV2Router02_DataDecoder.sol)

```solidity

    /** ... */
    contract UniswapV2Router02_Optimized is UniswapV2Router02, Ownable, UniswapV2Router02_DataDecoder {

        /** ... */

        function addLiquidityCompressed(bytes calldata _payload)
            external
            payable
            returns (uint256 amountA, uint256 amountB, uint256 liquidity)
        {
            (AddLiquidityData memory addLiquidityData,) = _decode_AddLiquidityData(_payload, 0);

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
        /** ... */
  
    }

```

The second one is [ `UniswapV2Router02_DataEncoder.sol`](https://github.com/Ratimon/solid-grinder/blob/main/src/examples/uniswapv2/UniswapV2Router02_DataEncoder.sol)

```solidity

    /** ... */
   contract UniswapV2Router02_DataEncoder {
    IAddressTable public immutable addressTable;

        /** ... */

        function encode_AddLiquidityData(
            address tokenA,
            address tokenB,
            uint256 amountADesired,
            uint256 amountBDesired,
            uint256 amountAMin,
            uint256 amountBMin,
            address to,
            uint256 deadline
        )
            external
            view
            returns (
                bytes memory _compressedPayload // bytes32 _compressedPayload
            )
        {
            /** ... */
        }

        /** ... */

    }

```

As shown above, the various input arguments of original contract are compressed into a single calldata via **encoder**. It is then decoded to be used later in **decoder**. Thus, nearly half bytes of calldata is reduced.

This can be illustrated by following:

- This command shows how solidity encodes a original function with arguments:

```sh
$ cast calldata "addLiquidity(address,address,uint256,uint256,uint256,uint256,address,uint256)" 0x106EABe0298ec286Adf962994f0Dcf250c4BB763 0xEbfc763Eb9e1d1ab09Eb2f70549b66682AfD9aa5 1200000000000000000000 2500000000000000000000 1000000000000000000000 2000000000000000000000 0x095E7BAea6a6c7c4c2DfeB977eFac326aF552d87 100
```

- The result has the total bytes count of 520 hexa = 520/2 = 260 bytes:

```sh
0xe8e33700000000000000000000000000106eabe0298ec286adf962994f0dcf250c4bb763000000000000000000000000ebfc763eb9e1d1ab09eb2f70549b66682afd9aa50000000000000000000000000000000000000000000000410d586a20a4c000000000000000000000000000000000000000000000000000878678326eac90000000000000000000000000000000000000000000000000003635c9adc5dea0000000000000000000000000000000000000000000000000006c6b935b8bbd400000000000000000000000000000095e7baea6a6c7c4c2dfeb977efac326af552d870000000000000000000000000000000000000000000000000000000000000064
```

- This command shows how our optimized verion encodes various input arguments into single tightly compressed calldata.

```sh
$ cast calldata "addLiquidityCompressed(bytes)" 000001000002000000410d586a20a4c00000000000878678326eac9000000000003635c9adc5dea000000000006c6b935b8bbd4000000000030000000064
```

- The result has the total bytes count of 264 hexa = 264/2 = 132 bytes:

```sh
0x2feccbed0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003e000001000002000000410d586a20a4c00000000000878678326eac9000000000003635c9adc5dea000000000006c6b935b8bbd40000000000300000000640000
```

Hence, this saves bytes by around 50% of calldata. This figure is quite impactful when implementing on dApp deployed on L2 (like Optimism) where L2 users pay their significant portion of L1 security cost of batch submission. The L1 gas could possibly be 99% of the total gas cost (L1 + 2 gas).

This essentially means that either the fewer bytes of call data sent or the tighter packed call data, the lower gas users will pay on L2.

As a result, our optimized version of UniswapV2's rounter could potentially save nearly 50%  of gas on L2.

> **Note**💡

> The gas amount saved heavily depends on L1 security cost which can vary, depending on the congestion on L1.

Mathematically, The total gas is the total of the L2 execution fee and the L1 data/security fee.

Here's the (simple) math:

```sh
total_gas_fee = l2_execution_fee + l1_data_fee
```

where `l2_execution_fee` is :

```sh
l2_execution_fee = transaction_gas_price * l2_gas_used
transaction_gas_price = l2_base_fee + l2_priority_fee
```

and `l1_data_fee` is :

```sh
l1_data_fee = l1_gas_price * (tx_data_gas + fixed_overhead) * dynamic_overhead
```

Where `tx_data_gas` is:

```sh
tx_data_gas = count_zero_bytes(tx_data) * 4 + count_non_zero_bytes(tx_data) * 16
```

You can read the parameter values from the [gas oracle contract](https://optimistic.etherscan.io/address/0x420000000000000000000000000000000000000F#readProxyContract).

> The more detail could be found at the [Optimism&#39;s Documentation](https://community.optimism.io/docs/developers/build/transaction-fees/#).

## How It Works

It works by optimizing calldata by using as little bytes of calldata as possible.

Specifically, Our novel components are as follows:

1. Solidity snippets: one contract to encode call data on chain. Another to decode it. This compoent has following feat:

   - AddressTable: to store **the mapping between addresses and indexes**, allowing:
     - The **address** can be registered to the contract, then the index is generated.
     - The generated id can then be used  to look up the registered address  during the compressed **call data** **decoding** process
   - Data Serialization, allowing:
     - The encoded calldata could be deserialized into the correct type
     - For example, if we choose to reduce the calldata by sending the time period as arguments with type of uint40 (5 bytes) instead of uint256, the calldata should be sliced at the correct offset and the result can be correctly used in the next steps.
2. Front-end snippets: to atomically connect between encoding and deconding componet into single call
3. CLI: to geneate the above solidty snippets (,including Encoder and Decode contracts). The only task requires to do is to specify the data type to pack the calldata while ensuring security.

## Architecture

WIP

Change original (unoptimized) contract's visibillity to public first
