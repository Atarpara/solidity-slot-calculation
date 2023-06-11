// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleMapping {
    mapping(address => uint256) private data; // slot 0

    function setData(address user, uint256 amount) public {
        data[user] = amount;
    }

    // similar as data[user]
    function getData(address user) public view returns (uint256 result) {
        // slot = keccak256(key . dataSlot)
        uint256 slot = uint256(keccak256(abi.encode(user, 0))); // here data.slot = 0

        assembly {
            // load storage data from the given slot
            result := sload(slot)
        }
    }
}
