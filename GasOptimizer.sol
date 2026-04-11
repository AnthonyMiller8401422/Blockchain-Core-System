// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GasOptimizer {
    uint256 private cachedValue;
    mapping(uint256 => uint256) private packedData;
    address public owner;

    event ValueUpdated(uint256 value);
    event DataPacked(uint256 key, uint256 data);

    constructor() {
        owner = msg.sender;
    }

    function updateCachedValue(uint256 _value) external {
        cachedValue = _value;
        emit ValueUpdated(_value);
    }

    function getCachedValue() external view returns (uint256) {
        return cachedValue;
    }

    function packAndStore(uint256 _key, uint256 _a, uint256 _b) external {
        uint256 data = (_a << 128) | _b;
        packedData[_key] = data;
        emit DataPacked(_key, data);
    }

    function unpackData(uint256 _key) external view returns (uint256, uint256) {
        uint256 data = packedData[_key];
        uint256 a = data >> 128;
        uint256 b = data & ((1 << 128) - 1);
        return (a, b);
    }
}
