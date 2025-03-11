import hre from "hardhat";
import type { HardhatRuntimeEnvironment } from "hardhat/types";
import FactoryModule from "../ignition/modules/Factory";
import ProfileNFTModule from "../ignition/modules/ProfileNFT";
import { Factory__factory } from "../typechain-types";
import TweetNFTModule from "../ignition/modules/TweetNFT";
import fs from "node:fs";
import path from "node:path";

// biome-ignore lint/suspicious/noExplicitAny: <explanation>
function writeAddressesToFile(addresses: any) {
  const filePath = path.join(__dirname, "addresses.json");
  fs.writeFileSync(filePath, JSON.stringify(addresses, null, 2));
  console.log(`Addresses written to ${filePath}`);
}

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Get deployment environment from command line arguments
  // const environment = hre.network.name || "local";

  const factoryModuleResult = await (
    hre as HardhatRuntimeEnvironment
  ).ignition.deploy(FactoryModule);

  const profileModuleResult = await (
    hre as HardhatRuntimeEnvironment
  ).ignition.deploy(ProfileNFTModule, {
    parameters: {
      ProfileNFTModule: {
        factoryAddress: factoryModuleResult.factory.target as string,
      },
    },
  });

  const tweetModuleResult = await (
    hre as HardhatRuntimeEnvironment
  ).ignition.deploy(TweetNFTModule, {
    parameters: {
      TweetNFTModule: {
        factoryAddress: factoryModuleResult.factory.target as string,
      },
    },
  });

  const factory = await Factory__factory.connect(
    factoryModuleResult.factory.target as string,
    deployer,
  );

  // Execute the createProfile function
  const tx = await factory.initializeNFTContracts(
    profileModuleResult.profileNFT.target,
    tweetModuleResult.tweetNFT.target,
  );
  const receipt = await tx.wait();

  if (!receipt) {
    throw new Error("Transaction failed");
  }

  const addresses = {
    factory: factoryModuleResult.factory.target,
    profileNFT: profileModuleResult.profileNFT.target,
    tweetNFT: tweetModuleResult.tweetNFT.target,
  };

  console.log(addresses);

  // Write addresses to a JSON file
  writeAddressesToFile(addresses);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
