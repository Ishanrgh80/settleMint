const { ethers } = require("hardhat");

async function main() {

  const [deployer] = await ethers.getSigners();

  // // Token Contract \\
  const vesting = await ethers.getContractFactory("ticketToken");

  console.log("Deploying Token contract...");

  const vestingContract = await vesting.deploy();
  await vestingContract.waitForDeployment();

  // Print the contract address
  console.log("Token contract deployed to:",await vestingContract.getAddress());
  
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
