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

Alternatively, use: 
```sh
pnpm add -D openzeppelin-solc_0_7@npm:openzeppelin/openzeppelin-contracts@3.4.2
```

@openzeppelin/contracts

pnpm add lodash1@npm:lodash@1



### Style guide

### File naming
### Linter