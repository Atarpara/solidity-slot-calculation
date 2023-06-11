// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MappingWithStructExample1 {
    struct Data {
        address user; // offset 0
        uint256 amount; // offset 1
    }

    mapping(uint256 => Data) private userData;

    function setUserData(uint256 key, address u, uint256 a) public {
        userData[key].user = u;
        userData[key].amount = a;
    }

    function getUserData(uint256 key) public view returns (address user, uint256 amount) {
        // userData[key].user.slot = keccak256(key . userData.slot) + userOffset
        uint256 slotUser = uint256(keccak256(abi.encode(key, 0))) + 0;
        // userData[key].amount.slot = keccak256(key . userData.slot) + amountOffset
        uint256 slotAmount = slotUser + 1;

        assembly {
            user := sload(slotUser)
            amount := sload(slotAmount)
        }
    }
}

contract MappingWithStructExample2 {
    struct Data {
        uint128 a; // offset 0
        uint64 b; // offset 0
        uint256 c; // offset 1
    }

    mapping(uint256 => Data) private data;

    function setData(uint256 key, uint128 _a, uint64 _b, uint256 _c) public {
        data[key].a = _a;
        data[key].b = _b;
        data[key].c = _c;
    }

    function getData(uint256 key) public view returns (uint128 a, uint64 b, uint256 c) {
        // a and b slot are same due both varible fits into one slot
        uint256 abSlot = uint256(keccak256(abi.encode(key, 0))) + 0;

        uint256 cSlot = abSlot + 1;

        assembly {
            // sload(dataStore[key].a.slot) & type(uint128).max
            a := and(sload(abSlot), 0xFFFFFFFFFFFFFFFF)
            // sload(dataStore[key].b.slot) >> 128 & type(uint64).max
            b := and(shr(128, sload(abSlot)), 0xFFFFFFFF)

            c := sload(cSlot)
        }
    }
}
