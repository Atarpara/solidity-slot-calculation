// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NestedDynamicArray {
    uint256[][] private arr; // slot 0

    function pushArray(uint256[] calldata values) public {
        // pushing whole values array into arr
        arr.push(values);
    }

    function getLength() public view returns (uint256 len) {
        uint256 slot = 0; // arr.slot = 0
        assembly {
            len := sload(slot)
        }
    }

    function getLength(uint256 index) public view returns (uint256 len) {
        // arr[index].length.slot = keccak256(arr.slot) + index
        uint256 slot = uint256(keccak256(abi.encode(0))) + index;

        assembly {
            len := sload(slot)
        }
    }

    function getElement(uint256 i, uint256 j) public view returns (uint256 result) {
        uint256 islot = uint256(keccak256(abi.encode(0))) + i;
        // arr[i][j].slot = keccak256(keccak256(arr.slot) + i)) + j
        uint256 slot = uint256(keccak256(abi.encode(islot))) + j;

        assembly {
            result := sload(slot)
        }
    }
}

contract NestedDynamicUint64Array {
    uint64[][] public arr;

    function setArray(uint64[] calldata data) public {
        arr.push(data);
    }

    function getLen() public view returns (uint256 len) {
        // bytes32 slot = keccak256(abi.encode(0));
        assembly {
            len := sload(arr.slot)
        }
    }

    function getLen(uint256 index) public view returns (uint256 len) {
        bytes32 slot = bytes32(uint256(uint256(keccak256(abi.encode(0))) + index));
        assembly {
            len := sload(slot)
        }
    }

    function getElement(uint256 i, uint256 j) public view returns (uint64 element) {
        uint256 iSlot = uint256(keccak256(abi.encode(0))) + i;
        // arr[i][j].slot = keccak256(keccak256(arr.slot) + i)) + j / (256/64)
        uint256 slot = uint256(keccak256(abi.encode(iSlot))) + j / 4;
        assembly {
            // arr[i][j] = (sload(arr[i][j].slot) >> j % (256/64) * 64) & type(uint64).max
            element := shr(mul(64, mod(j, 4)), sload(slot))
        }
    }
}
