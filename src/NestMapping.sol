// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NestedMapping {
    mapping(uint256 => mapping(uint256 => uint256)) private data;

    function setData(uint256 i, uint256 j, uint256 value) public {
        data[i][j] = value;
    }

    // similar to the data[i][j]
    function getData(uint256 i, uint256 j) public view returns (uint256 result) {
        // data[i][j].slot = keccak256(j . keccak256(i . data.slot))
        uint256 slot = uint256(keccak256(abi.encode(j, keccak256(abi.encode(i, 0)))));

        assembly {
            result := sload(slot)
        }
    }
}

contract TrippleMapping {
    mapping(uint256 => mapping(uint256 => mapping(uint256 => uint256))) public data;

    function setData(uint256 i, uint256 j, uint256 k, uint256 value) public {
        data[i][j][k] = value;
    }

    function getData(uint256 i, uint256 j, uint256 k) public view returns (uint256 result) {
        // step 1 :- data[i].slot = keccak256(i . data.slot)
        uint256 islot = uint256(keccak256(abi.encode(i, 0)));
        // step 2 :- data[i][j].slot = keccak256(j . data[i].slot)
        uint256 jslot = uint256(keccak256(abi.encode(j, islot)));
        // step 3 :- data[i][j][k].slot = keccak256(k . data[i][j].slot)
        uint256 kslot = uint256(keccak256(abi.encode(k, jslot)));

        assembly {
            result := sload(kslot)
        }
    }
}
