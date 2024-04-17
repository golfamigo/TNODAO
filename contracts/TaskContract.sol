// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract TaskContract {
    struct Task {
        string description;
        uint fundingGoal;
        uint amountRaised;
        bool isOpen;
        bool isSuccess;
    }

    uint public taskCount = 0;
    mapping(uint => Task) public tasks;

    address public owner;

    event TaskCreated(uint taskId, string description, uint goal);
    event TaskFunded(uint taskId, uint amountRaised);
    event TaskExecuted(uint taskId, bool outcome);
    event ReceivedEther(address sender, uint amount);
    event DebugLog(string message, uint indexed taskId, uint value);  // 新增调试事件
    event ErrorLog(string message);  // 新增错误信息事件

    constructor() {
        owner = msg.sender;  // 初始化合约拥有者
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    receive() external payable {
        emit ReceivedEther(msg.sender, msg.value);  // 记录接收到的以太币
    }

    function createTask(string memory _description, uint _goal) public {
        tasks[taskCount] = Task(_description, _goal, 0, false, false);
        emit TaskCreated(taskCount, _description, _goal);  // 触发任务创建事件
        taskCount++;
    }

    function fundTask(uint _taskId) public payable returns (bool) {
        emit DebugLog("Funding task", _taskId, msg.value);  // 正确的调用，已提供三个参数
        if (_taskId >= taskCount) {
            emit ErrorLog("Invalid task ID");  // 此处调用正确，ErrorLog 只需要一个参数
            return false;
        }
        Task storage task = tasks[_taskId];
        task.amountRaised += msg.value;
        emit DebugLog("Amount raised updated", _taskId, task.amountRaised);  // 确保传入所有三个参数

        if(task.amountRaised >= task.fundingGoal) {
            task.isOpen = true;
            emit DebugLog("Task is now open", _taskId, task.amountRaised);  // 同上，确保传入所有三个参数
        }
        return true;
    }


    function executeTask(uint _taskId, bool _outcome) public onlyOwner {
        require(_taskId < taskCount, "Task ID is not valid");  // 确保任务ID有效
        Task storage task = tasks[_taskId];
        task.isSuccess = _outcome;
        emit TaskExecuted(_taskId, _outcome);  // 触发任务执行事件
    }
}
