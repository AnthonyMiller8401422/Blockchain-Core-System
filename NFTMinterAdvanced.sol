// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMinterAdvanced is ERC721, Ownable {
    uint256 public tokenIdCounter;
    string public baseTokenURI;
    uint256 public maxSupply = 10000;

    constructor(string memory _name, string memory _symbol, string memory _baseURI) 
        ERC721(_name, _symbol) 
        Ownable(msg.sender) 
    {
        baseTokenURI = _baseURI;
    }

    function mintNFT(address _to) external onlyOwner {
        require(tokenIdCounter < maxSupply, "Max supply reached");
        tokenIdCounter++;
        _safeMint(_to, tokenIdCounter);
    }

    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        baseTokenURI = _newBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function updateMaxSupply(uint256 _newMax) external onlyOwner {
        maxSupply = _newMax;
    }
}
