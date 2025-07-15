// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {SimpleGameAttack} from "../src/SimpleGameAttack.sol";
import {SimpleGameSecure} from "../src/SimpleGameSecure.sol";

contract SimpleGameAttackTest is Test {
    SimpleGameSecure public simpleGameSecure;
    SimpleGameAttack public simpleGameAttack;

    function setUp() public {
        simpleGameSecure = new SimpleGameSecure();
        simpleGameAttack = new SimpleGameAttack(address(simpleGameSecure));
    }

    function testRevert_SecureGameAttack() public {
        vm.expectRevert("Condition not satisfied");
        simpleGameAttack.attack{value: 1 ether}();
    }

    receive() external payable {}
}
