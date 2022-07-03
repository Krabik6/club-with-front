
const hre = require("hardhat");

async function main() {

  const Club = await hre.ethers.getContractFactory("club");
  const club = await Club.deploy();

  await club.deployed();

  console.log("club deployed to:", club.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
