# Foundry NFT

[![CI](https://github.com/Parameshwarz/Foundry-NFT/actions/workflows/test.yml/badge.svg)](https://github.com/Parameshwarz/Foundry-NFT/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Solidity](https://img.shields.io/badge/Solidity-0.8.24-363636)
![Tests](https://img.shields.io/badge/forge%20test-passing-brightgreen)

Two ERC-721 contracts built with Foundry, each demonstrating one of the two standard ways to handle NFT artwork and metadata:

| Contract | Symbol | Artwork storage | Metadata |
|---|---|---|---|
| `BasicNft` | DOG | Off-chain (IPFS) | Off-chain JSON, on-chain URI pointer |
| `MoodNft` | MN | Fully on-chain SVG | Fully on-chain, base64 data URI |

## Table of Contents

- [BasicNft — the classic IPFS pattern](#basicnft--the-classic-ipfs-pattern)
- [MoodNft — 100% on-chain, dynamic](#moodnft--100-on-chain-dynamic)
- [Contract API](#contract-api)
- [Getting started](#getting-started)
- [Testing](#testing)
- [Deployment](#deployment)
- [Project structure](#project-structure)
- [Acknowledgments](#acknowledgments)
- [License](#license)

## BasicNft — the classic IPFS pattern

`src/BasicNft.sol` is a deliberately minimal ERC-721 on OpenZeppelin v5. `mintNFT(tokenUri)` stores the URI string for the next token ID in a `uint256 => string` mapping and safe-mints to the caller. `tokenURI(tokenId)` returns the stored string verbatim.

The image behind the URI is the Shiba Inu in `Img/shiba-inu.png`, hosted on IPFS — the standard "art on IPFS, pointer on-chain" approach. Cheap on gas, but the contract depends on the pinned content staying available.

## MoodNft — 100% on-chain, dynamic

`src/MoodNft.sol` takes the opposite approach: nothing leaves the chain.

- The two faces are SVG images, passed into the constructor as base64 `data:image/svg+xml;base64,...` URIs and stored as state.
- `tokenURI(tokenId)` assembles the JSON metadata **in the contract** — name, description, attributes, and the SVG for the token's current mood — and returns it base64-encoded behind a `data:application/json;base64,` prefix. Marketplaces render this directly; there is no external file to lose.
- Each token has a mood (`HAPPY` by default). `flipMood(tokenId)` toggles it between the happy and sad SVG. Access is checked with OpenZeppelin's `_isAuthorized(owner, spender, tokenId)`, so only the owner or an approved operator can flip — anyone else gets `MoodNft__CantFlipMoodIfNotOwner`.

The deploy script reads `Img/happy.svg` and `Img/sad.svg` from disk at deploy time and base64-encodes them into the constructor args (that's why `foundry.toml` enables `ffi`/`fs_permissions` for `./img`).

## Contract API

| Function | Contract | Description |
|---|---|---|
| `mintNFT(string tokenUri)` | BasicNft | Mint with an explicit token URI (IPFS in practice) |
| `tokenURI(uint256)` | both | BasicNft: stored pointer · MoodNft: generated on-chain JSON |
| `mintNft()` | MoodNft | Mint a token in the HAPPY state |
| `flipMood(uint256 tokenId)` | MoodNft | Toggle HAPPY ↔ SAD (owner or approved only) |
| `getMood(uint256 tokenId)` | MoodNft | Current mood enum value |

## Getting started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/) (`curl -L https://foundry.paradigm.xyz | bash` then `foundryup`)
- Git

### Install

Dependencies (`forge-std`, `openzeppelin-contracts` v5, `foundry-devops`) are git submodules:

```shell
git clone --recurse-submodules https://github.com/Parameshwarz/Foundry-NFT.git
cd Foundry-NFT
# or, if already cloned:
forge install
```

### Build

```shell
forge build
```

## Testing

```shell
forge test
# or
make test
```

- `test/unit/MoodNftTest.t.sol` — minting, mood initialization, owner-vs-non-owner flip authorization, and that `tokenURI` produces the expected base64 JSON (including a sanity check that the SVG encodes to the expected data URI).
- `test/unit/DeployMoodNftTest.t.sol` — the deploy script wires the SVGs correctly into the constructor.
- `test/integrations/` — end-to-end tests that run the deploy scripts and interact with the deployed contracts (BasicNft mint via `DevOpsTools`, MoodNft flip after deployment).

Useful variants:

```shell
forge test --match-contract MoodNftTest -vvv
forge coverage
forge snapshot
forge fmt                # CI enforces formatting
```

## Deployment

The Makefile targets a local Anvil node by default and switches to Sepolia when you pass `ARGS="--network sepolia"` (it then reads `SEPOLIA_RPC_URL`, `PRIVATE_KEY` and `ETHERSCAN_API_KEY` from `.env`).

```shell
make anvil                    # terminal 1 — local node

make deploy                   # deploy BasicNft
make mint                     # mint to the most recently deployed BasicNft

make deployMood               # deploy MoodNft (reads + encodes Img/*.svg)
make mintMoodNft              # mint a MoodNft
make flipMoodNft              # flip the most recently minted token
```

Sepolia:

```shell
make deploy ARGS="--network sepolia"
```

The interaction scripts use `DevOpsTools.get_most_recent_deployment` from foundry-devops to find the right contract from the `broadcast/` logs, so you don't have to copy addresses around.

## Project structure

```
Img/
  shiba-inu.png         # BasicNft artwork (hosted on IPFS)
  happy.svg, sad.svg    # MoodNft artwork (encoded on-chain at deploy)
  example.svg
script/
  DeployBasicNft.s.sol  # deploy + (via Interactions) mint with IPFS URI
  DeployMoodNft.s.sol   # read SVGs, base64-encode, deploy
  Interactions.s.sol    # MintBasicNft / MintMoodNft / FlipMoodNft
src/
  BasicNft.sol
  MoodNft.sol
test/
  unit/
  integrations/
```

## Acknowledgments

Built while following the [Cyfrin Updraft](https://updraft.cyfrin.io/) Foundry curriculum (NFT section).

## License

[MIT](LICENSE)
