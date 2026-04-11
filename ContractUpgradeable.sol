// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ContractUpgradeable {
    address public implementation;
    address public owner;

    event Upgraded(address indexed newImpl);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function upgradeTo(address _newImpl) external onlyOwner {
        implementation = _newImpl;
        emit Upgraded(_newImpl);
    }

    fallback() external payable {
        address impl = implementation;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}
