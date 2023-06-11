// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MappingWithDynamicArray {
    mapping(uint256 => uint256[]) public data;

    function setElement(uint256 index, uint256[] calldata arr) public {
        data[index] = arr;
    }

    function getArrLen(uint256 key) public view returns (uint256 len) {
        // arr[key].length.slot = keccak256(abi.encode(index, arr.slot))
        uint256 slot = uint256(keccak256(abi.encode(key, 0)));
        assembly {
            len := sload(slot)
        }
    }

    function getArrayElement(uint256 key, uint256 index) public view returns (uint256 r) {
        bytes32 iSlot = keccak256(abi.encode(key, 0));
        // arr[key][index].slot = keccak256(keccak256(abi.encode(key, arr.slot))) + index
        uint256 slot = uint256(keccak256(abi.encode(iSlot))) + index;

        assembly {
            r := sload(slot)
        }
    }
}
