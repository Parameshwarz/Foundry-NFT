// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;
    MoodNft public moodNft;
    address public USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    // function testNameIsCorrect() public {
    //     string memory expectedName = "Mood Nft";
    //     string memory actualName = moodNft.name();
    //     assertEq(expectedName, actualName);
    // }

    function testSvgToImageURI() public {
        string memory expectedImageURI =
            "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MDAiIGhlaWdodD0iNTAwIj48dGV4dCB4PSIwIiB5PSIxNSIgZmlsbD0iYmxhY2siPiBIaSBZb3UgZW5jb2RlZCBpdCEgPC90ZXh0Pjwvc3ZnPg==";
        string memory svg =
            '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500"><text x="0" y="15" fill="black"> Hi You encoded it! </text></svg>';
        string memory createdImageURI = deployer.svgToImgUri(svg);
        assertEq(expectedImageURI, createdImageURI);
    }
}
