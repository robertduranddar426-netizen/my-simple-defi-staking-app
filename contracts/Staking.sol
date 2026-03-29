









// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public rewardDebt;

    uint256 public rewardRate = 100; // example: tokens per block (tune this)

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint256 _amount) external {
        // Claim any pending rewards first (simple version)
        claimReward();
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        stakedBalance[msg.sender] += _amount;
    }

    function unstake(uint256 _amount) external {
        require(stakedBalance[msg.sender] >= _amount, "Insufficient stake");
        claimReward();
        stakedBalance[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function claimReward() public {
        // Simplified reward calculation - in production use time-based logic
        uint256 reward = (stakedBalance[msg.sender] * rewardRate) / 1000; // example formula
        rewardToken.transfer(msg.sender, reward);
    }

    // Add more robust reward logic with timestamps in a real app
}
