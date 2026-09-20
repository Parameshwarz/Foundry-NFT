// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {
    string constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentDeplyed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNftOnContract(mostRecentDeplyed);
    }

    function mintNftOnContract(address contractAddr) public {
        vm.startBroadcast();
        BasicNft(contractAddr).mintNFT(PUG);
        vm.stopBroadcast();
    }
}
