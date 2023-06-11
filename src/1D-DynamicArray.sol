// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DynamicArray {
    uint256[] private arr; // slot 0

    function pushArray(uint256 values) public {
        // pushing whole values array into arr
        arr.push(values);
    }

    function getLength() public view returns (uint256 len) {
        // arr.length.slot = arr.slot
        uint256 slot = 0; // arr.slot = 0

        assembly {
            len := sload(slot)
        }
    }

    function getElement(uint256 index) public view returns (uint256 result) {
        // arr[index].slot = keccak256(arr.slot) + index
        uint256 slot = uint256(keccak256(abi.encode(0))) + index; // arr.slot = 0

        assembly {
            result := sload(slot)
        }
    }
}
