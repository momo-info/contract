import type { HardhatUserConfig } from "hardhat/config";
import { vars } from "hardhat/config";
import "@typechain/hardhat";
import "@nomicfoundation/hardhat-ethers";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-ignition-ethers";
import "hardhat-contract-sizer";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  defaultNetwork: "monadTestnet",
  networks: {
    monadTestnet: {
      url: vars.get("MONAD_RPC_URL"),
      accounts: [vars.get("PRIVATE_KEY")],
      chainId: Number(vars.get("MONAD_CHAIN_ID")),
    },
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
  },
  // sourcify: {
  //   enabled: true,
  //   apiUrl: "https://sourcify-api-monad.blockvision.org",
  //   browserUrl: "https://testnet.monadexplorer.com/",
  // },
  // To avoid errors from Etherscan
  // etherscan: {
  //   enabled: false,
  // },
};

export default config;
