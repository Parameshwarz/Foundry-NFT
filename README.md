# Foundry NFT

Two ERC-721 contracts built with Foundry, each showing a different approach to NFT metadata and artwork.

## Contracts

**`BasicNft`** (`src/BasicNft.sol`) — "Dogie" (DOG)
A minimal ERC-721 on OpenZeppelin. Each mint stores a token URI pointing at an off-chain, IPFS-hosted image (the Shiba Inu in `Img/shiba-inu.png`). This is the standard "metadata on IPFS, pointer on-chain" pattern.

**`MoodNft`** (`src/MoodNft.sol`) — "Mood Nft" (MN)
A fully on-chain NFT. The happy and sad faces are SVGs passed in at deployment and stored in the contract itself; `tokenURI()` returns a `data:application/json;base64,...` response with the metadata and the current SVG inline — no external hosting at all. The token's mood can be flipped between `HAPPY` and `SAD`, restricted to the owner or an approved operator (checked via `_isAuthorized`).

## Project layout

```
Img/
  happy.svg, sad.svg     # on-chain artwork for MoodNft
  shiba-inu.png          # IPFS artwork for BasicNft
  example.svg
script/
  DeployBasicNft.s.sol   # deploy + mint with an IPFS token URI
  DeployMoodNft.s.sol    # upload SVGs to IPFS, deploy with both URIs
  Interactions.s.sol     # mint / flip helpers
test/
  unit/                  # BasicNft + MoodNft unit tests
  integrations/
```

The `DeployMoodNft` script uses Foundry's `ffi` (enabled in `foundry.toml`) together with the foundry-devops library to push the SVGs to IPFS at deploy time, which is why `Img/` is part of the project rather than a one-off asset folder.

## Build & test

Requires [Foundry](https://book.getfoundry.sh/). Dependencies are git submodules (`forge-std`, `openzeppelin-contracts`, `foundry-devops`), so clone with `--recurse-submodules` or run `forge install` first.

```shell
forge build
forge test
```
