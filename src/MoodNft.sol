// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721{

    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImgUri;
    string private s_happySvgImgUri;
    constructor(string memory sadSvgImgUri, string memory happySvgImgUri) ERC721("Mood Nft", "MN"){
        s_tokenCounter = 0;
        s_sadSvgImgUri = sadSvgImgUri;
        s_happySvgImgUri = happySvgImgUri;
    }

    enum MOOD {
        HAPPY, 
        SAD
    }

    mapping(uint256 => MOOD) private s_tokenIdToMood;

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = MOOD.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if(!(_isAuthorized(ownerOf(tokenId),msg.sender ,tokenId))){
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if(s_tokenIdToMood[tokenId] == MOOD.HAPPY){
            s_tokenIdToMood[tokenId] = MOOD.SAD;
        } else {
            s_tokenIdToMood[tokenId] = MOOD.HAPPY;
        }
    }

    function _baseURI() internal pure override returns(string memory){
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        string memory imageURI;

        if(s_tokenIdToMood[tokenId] == MOOD.HAPPY){
            imageURI = s_happySvgImgUri;
        } else {
            imageURI = s_sadSvgImgUri;
        }
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            name(), // You can add whatever name here
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function getMood(uint256 tokenId) public view returns(MOOD){
        return s_tokenIdToMood[tokenId];
    }
}