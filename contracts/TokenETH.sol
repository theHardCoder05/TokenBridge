// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./TokenBase.sol";

contract TokenETH is TokenBase {
    constructor() TokenBase("ETH Token", "ETK") {}
}