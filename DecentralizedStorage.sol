// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DecentralizedStorage {
    struct File {
        string cid;
        uint256 size;
        address uploader;
        uint256 uploadTime;
    }

    mapping(uint256 => File) public files;
    uint256 public fileId;
    address public admin;

    event FileUploaded(uint256 indexed id, string cid, address uploader);

    constructor() {
        admin = msg.sender;
    }

    function uploadFile(string calldata _cid, uint256 _size) external returns (uint256) {
        fileId++;
        files[fileId] = File(_cid, _size, msg.sender, block.timestamp);
        emit FileUploaded(fileId, _cid, msg.sender);
        return fileId;
    }

    function getFileDetails(uint256 _id) external view returns (File memory) {
        return files[_id];
    }
}
