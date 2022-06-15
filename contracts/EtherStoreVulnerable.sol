//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract EtherStoreVulnerable {
	uint256 public withdrawalLimit = 1 ether;
	mapping(address => uint256) public lastWithdrawTime;
	mapping(address => uint256) public balances;

	function depositFunds() public payable {
		balances[msg.sender] += msg.value;
	}

	function withdrawFunds(uint256 _weiToWithdraw) public {
		require(balances[msg.sender] >= _weiToWithdraw);
		// limit the withdrawal
		require(_weiToWithdraw <= withdrawalLimit);
		// limit the time allowed to withdraw
		require(block.timestamp >= lastWithdrawTime[msg.sender] + 1 weeks);
      (bool succeded, ) = msg.sender.call{value: _weiToWithdraw}("");
		require(succeded, "");
		balances[msg.sender] -= _weiToWithdraw;
		lastWithdrawTime[msg.sender] = block.timestamp;
	}
}
