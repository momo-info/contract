import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const TweetNFTModule = buildModule("TweetNFTModule", (m) => {
  const factory = m.contractAt(
    "Factory",
    m.getParameter<string>("factoryAddress"),
  );

  const tweetNFT = m.contract("TweetNFT", [factory.address]);

  return { tweetNFT };
});

export default TweetNFTModule;
