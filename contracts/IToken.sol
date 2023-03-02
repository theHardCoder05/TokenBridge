// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


/**
 * @title - Interface of Token
 * @author 
 * @notice 
 */
interface IToken {
    
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}