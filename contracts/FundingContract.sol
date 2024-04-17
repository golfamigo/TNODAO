// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract FundingContract {
    mapping(uint => mapping(address => uint)) public balances; // Mapping from task ID to (user address to balance)

    function fund(uint _taskId) public payable {
        balances[_taskId][msg.sender] += msg.value;  // Track funds per task
    }

    function withdraw(uint _taskId, uint _amount) public {
        require(balances[_taskId][msg.sender] >= _amount, "Insufficient funds");
        payable(msg.sender).transfer(_amount);
        balances[_taskId][msg.sender] -= _amount;
    }
}

