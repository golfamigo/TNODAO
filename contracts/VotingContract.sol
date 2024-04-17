// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract VotingContract {
    mapping(uint => uint) public votesForSuccess;

    function voteForSuccess(uint _taskId) public {
        votesForSuccess[_taskId]++;
    }
}
