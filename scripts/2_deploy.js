const { ethers } = require("hardhat");

async function main() {

  const [deployer] = await ethers.getSigners();

  // /// Ticket Contract \\\\
  const ticketSale = await ethers.getContractFactory("Tickets");
  console.log("Deploying Tickets contract...");

  const ticket = await ticketSale.deploy('0xC3c91C70c7a2D3396e651ccB40A8324EA6BaD107');
  await ticket.waitForDeployment();

  // Print the contract address
  console.log("Ticket contract deployed to:",await ticket.getAddress());

  
  // Getting the deployers address
  console.log("Deployer address:", await deployer.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
.then(()=>process.exit(0))
.catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
