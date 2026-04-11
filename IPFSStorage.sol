// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IPFSStorage {
    mapping(uint256 => string) public ipfsHashes;
    mapping(address => uint256[]) public userFiles;
    uint256 public fileCount;

    event FileStored(uint256 indexed fileId, address indexed user, string ipfsHash);

    function storeFile(string calldata _ipfsHash) external returns (uint256) {
        fileCount++;
        ipfsHashes[fileCount] = _ipfsHash;
        userFiles[msg.sender].push(fileCount);
        emit FileStored(fileCount, msg.sender, _ipfsHash);
        return fileCount;
    }

    function getFile(uint256 _fileId) external view returns (string memory) {
        return ipfsHashes[_fileId];
    }

    function getUserFiles(address _user) external view returns (uint256[] memory) {
        return userFiles[_user];
    }
}
