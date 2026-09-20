// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNfttest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assertEq(expectedName, actualName);
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNFT(PUG);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(PUG)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
