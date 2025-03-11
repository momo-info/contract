import hre from "hardhat";
import { Factory__factory, ProfileNFT__factory } from "../typechain-types";
import addresses from "./addresses.json";

async function main() {
  // Replace with your deployed Factory contract address
  const factoryAddress = addresses.factory;
  const profileNFTAddress = addresses.profileNFT;
  const tweetNFTAddress = addresses.tweetNFT;

  // Replace with the metadata URI for the profile NFT
  const tokenURI = "https://metadata.url/profile.json";

  const [deployer] = await hre.ethers.getSigners();
  //    const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory__factory.connect(factoryAddress, deployer);
  const tx = await factory.createTweet(1, tokenURI);
  const receipt = await tx.wait();

  if (!receipt) {
    throw new Error("Transaction failed");
  }

  const profileNFT = await ProfileNFT__factory.connect(
    profileNFTAddress,
    deployer,
  );

  const profileScore = await profileNFT.getProfileScore(1);
  console.log("receipt", profileScore);

  const updatedProfileScore = await factory.updateEngagement(1, 1, 1, 1);

  const newProfileScore = await profileNFT.getProfileScore(1);
  console.log("receipt", newProfileScore);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
