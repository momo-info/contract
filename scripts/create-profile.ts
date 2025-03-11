import hre from "hardhat";
import { Factory__factory } from "../typechain-types";

async function main() {
  // Replace with your deployed Factory contract address
  const factoryAddress = "0x30154914E20caC0d19cC3836225f675D59506239";

  // Replace with the metadata URI for the profile NFT
  const tokenURI = "https://metadata.url/profile.json";

  const [deployer] = await hre.ethers.getSigners();
  console.log("signer", deployer);
  //    const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory__factory.connect(factoryAddress, deployer);

//   const profileNFTAddress = await factory.profileNFT();
//   const tweetNFTAddress = await factory.tweetNFT();

//   console.log("profileNFTAddress", profileNFTAddress);
//   console.log("tweetNFTAddress", tweetNFTAddress);
  // Execute the createProfile function
  const tx = await factory.createProfile(tokenURI);
  const receipt = await tx.wait();

  if (!receipt) {
    throw new Error("Transaction failed");
  }

  console.log("receipt", receipt);

  // Log the profile ID from the emitted event
  //    const profileCreatedEvent = receipt.events.find(event => event.event === "ProfileCreated");
  //    const profileId = profileCreatedEvent.args.profileId;
  //    console.log("Profile created with ID:", profileId.toString());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
