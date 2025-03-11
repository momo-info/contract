import hre from "hardhat";
import type { HardhatRuntimeEnvironment } from "hardhat/types";
import FactoryModule from "../ignition/modules/Factory";
import ProfileNFTModule from "../ignition/modules/ProfileNFT";
import { Factory__factory } from "../typechain-types";

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Get deployment environment from command line arguments
  const environment = hre.network.name || "local";

  const factoryModuleResult = await (
    hre as HardhatRuntimeEnvironment
  ).ignition.deploy(FactoryModule);

  console.log("Factory deployed to:", factoryModuleResult.factory.target);
  const profileModuleResult = await (
    hre as HardhatRuntimeEnvironment
  ).ignition.deploy(ProfileNFTModule, {
    parameters: {
      ProfileNFTModule: {
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
    profileModuleResult.profileNFT.target,
  );
  const receipt = await tx.wait();

  if (!receipt) {
    throw new Error("Transaction failed");
  }

//   console.log("receipt", receipt);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
