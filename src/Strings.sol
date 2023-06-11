// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StringsExample1 {
    string public str = "milady";

    function getLength() public view returns (uint256 len) {
        uint256 slot = 0; // str.slot = 0

        assembly {
            // data.length = (sload(data.slot) & 0xFF) / 2
            len := shr(1, and(sload(slot), 0xFF))
        }
    }
}

contract StringsExample2 {
    string public str = "milady community is best in the world";

    function getLength() public view returns (uint256 len) {
        uint256 slot = 0; // str.slot = 0

        assembly {
            // data.length = (sload(data.slot) - 1) / 2
            len := shr(1, sub(sload(slot), 1))
        }
    }
}
