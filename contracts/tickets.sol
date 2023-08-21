// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Tickets is ERC721, Ownable {
    using SafeMath for uint256;

    uint256 public constant MAX_TICKETS = 1000;
    uint256 public constant MAX_RESELL_PERCENT = 110; // 110% of the previous sale price
    uint256 public totalSupply = 0;

    IERC20 public currencyToken;

    struct Ticket {
        address owner;
        uint256 originalPrice;
        uint256 resalePrice;
    }

    mapping(uint256 => Ticket) public tickets;

    constructor(address _currencyTokenAddress) ERC721("FestivalTicket", "FTK") {
        currencyToken = IERC20(_currencyTokenAddress);
    }

    function mintTicket() external onlyOwner {
        require(totalSupply < MAX_TICKETS, "Maximum tickets reached");
        uint256 tokenId = totalSupply + 1;
        tickets[tokenId] = Ticket({owner: owner(), originalPrice: 0, resalePrice: 0});
        _mint(owner(), tokenId);
    }

    function buyTicket(uint256 tokenId) external {
        require(_exists(tokenId), "Ticket does not exist");
        Ticket storage ticket = tickets[tokenId];
        require(ticket.owner != address(0), "Ticket is not available for sale");
        uint256 currentPrice = ticket.resalePrice > 0 ? ticket.resalePrice : ticket.originalPrice;
        require(currencyToken.transferFrom(msg.sender, owner(), currentPrice), "Transfer failed");

        address previousOwner = ticket.owner;
        ticket.owner = msg.sender;
        ticket.resalePrice = 0;

        _transfer(previousOwner, msg.sender, tokenId);
    }

    function setTicketPrice(uint256 tokenId, uint256 price) external {
        require(_exists(tokenId), "Ticket does not exist");
        require(ownerOf(tokenId) == msg.sender, "Not the ticket owner");
        require(price > 0, "Price must be greater than 0");
        tickets[tokenId].originalPrice = price;
    }

    function sellTicket(uint256 tokenId, uint256 price) external {
        require(_exists(tokenId), "Ticket does not exist");
        require(ownerOf(tokenId) == msg.sender, "Not the ticket owner");
        require(price > 0, "Price must be greater than 0");
        require(price <= MAX_RESELL_PERCENT.mul(tickets[tokenId].originalPrice).div(100), "Price exceeds limit");

        tickets[tokenId].resalePrice = price;
    }

    function getTicketInfo(uint256 tokenId) external view returns (address owner, uint256 originalPrice, uint256 resalePrice) {
        require(_exists(tokenId), "Ticket does not exist");
        Ticket storage ticket = tickets[tokenId];
        owner = ticket.owner;
        originalPrice = ticket.originalPrice;
        resalePrice = ticket.resalePrice;
    }
}
