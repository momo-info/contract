import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ProfileNFTModule = buildModule("ProfileNFTModule", (m) => {
  const factory = m.contractAt(
    "Factory",
    m.getParameter<string>("factoryAddress"),
  );
  
  const profileNFT = m.contract("ProfileNFT", [factory.address]);

  return { profileNFT };
});

export default ProfileNFTModule;
