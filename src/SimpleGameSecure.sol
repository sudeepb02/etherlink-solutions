// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract SimpleGameSecure {
    bool public isFinished;
    uint256 lastDepositedBlock;
    uint256 totalDepositedValue;

    function totalDeposit() external view returns (uint256) {
        return totalDepositedValue;
    }

    function deposit() public payable {
        require(msg.value == 0.1 ether, "Must deposit 0.1 Ether");
        require(!isFinished, "The game is over");
        require(lastDepositedBlock != block.number, "Only can deposit once per block");

        lastDepositedBlock = block.number;
        totalDepositedValue += msg.value;
    }

    function claim() public {
        require(totalDepositedValue >= 1 ether, "Condition not satisfied");

        payable(msg.sender).transfer(address(this).balance);
        isFinished = true;
    }
}
