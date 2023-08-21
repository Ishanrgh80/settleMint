// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import './../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract ticketToken is ERC20 {
    constructor() ERC20("Currency", "FTC") {
        _mint(msg.sender, 1000000 * 10**18);  // Mint initial supply to the contract deployer
    }
}

