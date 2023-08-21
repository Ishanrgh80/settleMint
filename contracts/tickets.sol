// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Tickets is ERC721Enumerable, Ownable {
    IERC20 public currencyToken;
    uint256 public ticketPrice = 110;
    uint256 public maxTickets = 1000;
    
    constructor(address _currencyToken) ERC721("Festival Ticket", "FTICKET") {
        currencyToken = IERC20(_currencyToken);
    }
    
    function buyTicket() external {
        require(totalSupply() < maxTickets, "All tickets sold");
        require(currencyToken.balanceOf(msg.sender) >= ticketPrice, "Insufficient funds");
        
        uint256 tokenId = totalSupply() + 1; // token IDs start from 1
        _mint(msg.sender, tokenId);
        currencyToken.transferFrom(msg.sender, address(this), ticketPrice);
    }
    
    function setTicketPrice(uint256 _newPrice) external onlyOwner {
        ticketPrice = _newPrice;
    }

    function setMaxTickets(uint256 _newMaxTickets) external onlyOwner {
        require(_newMaxTickets >= totalSupply(), "New maxTickets should be greater than or equal to current totalSupply");
        maxTickets = _newMaxTickets;
    }
    
    function sellTicket(uint256 tokenId, uint256 newPrice) external {
        require(ownerOf(tokenId) == msg.sender, "You don't own this ticket");
        require(newPrice <= ticketPrice * 110 / 100, "Price cannot be more than 110% of original");
        
        _approve(address(this), tokenId);
        ticketPrice = newPrice;
    }
}
