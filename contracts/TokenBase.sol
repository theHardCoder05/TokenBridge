// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenBase is ERC20 {
    address public owner;
    
    constructor(string memory name, string memory symbol) ERC20(name, symbol){
        owner = msg.sender;
    }
    function updateOwner(address account) external onlyOwner{
        owner = account;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "ONLY OWNER");
        _;
    }
}