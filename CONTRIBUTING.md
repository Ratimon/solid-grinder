## Contributing to Solid Grinder

Thanks for your help improving **Solid Grinder**!!!

There are multiple ways to contribute at any level. It doesn't matter if it is too small, we can use your help. These includes:

- Reporting issues.
- Fixing and responding to existing issues.
- Improving the readability, documentation and tutorials.
- Optimizing for gas efficiency
- Get involved in the design process by proposing changes or new features This can be propose by submitting issue too.

### Develop guide

Compile the non-default versions first:

```sh
FOUNDRY_PROFILE=solc_0_7 forge build
```

Compile the default version last:

```sh
forge build
```

Alternatively, it is just:
```sh
pnpm build:contract
```

Install the dependencies with specific version:
```sh
FOUNDRY_PROFILE=solc_0_7 forge install openzeppelin-solc_0_7=openzeppelin/openzeppelin-contracts@v3.4.2
```

```sh
forge install  --no-git  openzeppelin-solc_0_8=openzeppelin/openzeppelin-contracts@v4.9.6
```

Compile the non-default versions first:
- for version **0.7.x**:
```sh
cargo run gen-decoder --source 'contracts/solc_0_7/examples/uniswapv2/UniswapV2Router02.sol' --output 'contracts/solc_0_7/examples/uniswapv2' --contract-name 'UniswapV2Router02' --function-name 'addLiquidity' --arg-bits '24 24 96 96 96 96 24 40' --compiler-version 'solc_0_7'
```
- for version **0.8.x**:
```sh
cargo run gen-encoder --source 'contracts/solc_0_8/examples/uniswapv2/UniswapV2Router02.sol' --output 'contracts/solc_0_8/examples/uniswapv2' --contract-name 'UniswapV2Router02' --function-name 'addLiquidity' --arg-bits '24 24 96 96 96 96 24 40' --compiler-version 'solc_0_8'
```

Running Test:
```sh
FOUNDRY_PROFILE=solc_0_7 forge t -vvvv
```
```sh
forge test
```

### Publishing

#### For First Time

Config `package.json`:

```bash
npm publish
```

#### For Second Time

```bash
git add .
git commit -am "v1.1.8"
git push -u origin main
git tag v1.1.8 main
git push origin tag v1.1.8
```

```bash
cargo publish
```

### Style guide

### File naming

### Linter