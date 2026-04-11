// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CrossChainNFT is ERC721 {
    uint256 public tokenId;
    address public bridge;
    mapping(uint256 => uint256) public sourceChainId;

    event NFTBridgeInitiated(uint256 indexed tokenId, uint256 destChainId);
    event NFTBridgeCompleted(uint256 indexed tokenId, address recipient);

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        tokenId = 0;
    }

    modifier onlyBridge() {
        require(msg.sender == bridge, "Not bridge");
        _;
    }

    function setBridge(address _bridge) external {
        bridge = _bridge;
    }

    function mint(address _to) external returns (uint256) {
        tokenId++;
        _mint(_to, tokenId);
        return tokenId;
    }

    function bridgeNFT(uint256 _tokenId, uint256 _destChain) external {
        require(_exists(_tokenId), "NFT not exist");
        require(ownerOf(_tokenId) == msg.sender, "Not owner");
        _burn(_tokenId);
        emit NFTBridgeInitiated(_tokenId, _destChain);
    }

    function mintBridgedNFT(address _recipient, uint256 _tokenId, uint256 _srcChain) external onlyBridge {
        _mint(_recipient, _tokenId);
        sourceChainId[_tokenId] = _srcChain;
        emit NFTBridgeCompleted(_tokenId, _recipient);
    }
}
