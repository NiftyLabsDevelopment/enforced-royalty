import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        enabled: true,
        url: 'https://eth-mainnet.g.alchemy.com/v2/aC3IKXcLDVG_0omP6m2LIrTtAKmogtoX'
      },
      chainId: 1
    }
  }
};

export default config;
