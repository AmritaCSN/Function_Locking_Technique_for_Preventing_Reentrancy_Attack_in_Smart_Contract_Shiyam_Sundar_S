// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./Attack.sol";

contract DepositFunds {
    mapping(address => uint) public getBalances;

    function deposit() public payable {
        DepositFunds.getBalances[msg.sender] += msg.value;
    }

    bool private lock;
    modifier lockFunction {
        require(!lock, "Function is locked");
        lock = true;
        _;
        lock = false;
    }
    function withdraw() public lockFunction{
        uint bal = getBalances[msg.sender];
        require(bal > 0);
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
        getBalances[msg.sender] = 0;
    }
}
