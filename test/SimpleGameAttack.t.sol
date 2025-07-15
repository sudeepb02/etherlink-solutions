// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {SimpleGameAttack} from "../src/SimpleGameAttack.sol";

contract SimpleGameAttackTest is Test {
    SimpleGameAttack public simpleGameAttack;

    address public constant SIMPLE_GAME_ADDRESS = 0x94C8897Cf37906f1E66F743654Be69D5ebad2e76;

    function setUp() public {
        simpleGameAttack = new SimpleGameAttack(SIMPLE_GAME_ADDRESS);
    }

    function testSimpleGameAttack() public {
        simpleGameAttack.attack{value: 1 ether}();

        // Verify the results of the attack
        // Check if the SimpleGame contract is finished and has no funds left
        assertEq(address(simpleGameAttack.simpleGame()).balance, 0, "SimpleGame should have no funds left");

        // Check if the attacker received the funds
        assertGt(address(this).balance, 0, "Attacker should have received funds");
    }

    receive() external payable {}
}
