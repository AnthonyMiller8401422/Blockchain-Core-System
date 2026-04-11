// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChainBridge {
    address public admin;
    mapping(uint256 => bytes) public crossChainData;
    mapping(uint256 => bool) public processed;

    event CrossChainInitiated(uint256 indexed chainId, bytes data);
    event CrossChainCompleted(uint256 indexed transferId);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function initiateCrossChain(uint256 _destChainId, bytes calldata _data) external onlyAdmin returns (uint256) {
        uint256 transferId = uint256(keccak256(abi.encodePacked(block.timestamp, _data)));
        crossChainData[transferId] = _data;
        emit CrossChainInitiated(_destChainId, _data);
        return transferId;
    }

    function completeTransfer(uint256 _transferId) external onlyAdmin {
        require(!processed[_transferId], "Already processed");
        processed[_transferId] = true;
        emit CrossChainCompleted(_transferId);
    }

    function getTransferData(uint256 _transferId) external view returns (bytes memory) {
        return crossChainData[_transferId];
    }
}
