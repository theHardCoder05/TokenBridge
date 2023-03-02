import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { config as dotenvConfig } from 'dotenv';
import { resolve } from 'path';
dotenvConfig({ path: resolve(__dirname, './.env') });



import '@nomiclabs/hardhat-waffle';
import '@nomiclabs/hardhat-ethers';
import 'hardhat-deploy';
import 'hardhat-gas-reporter';

const CHAIN_IDS = {
  hardhat: 1337,
  mainnet: 1,
  ropsten: 3,
  rinkeby: 4,
  bscmain: 56,
  bsctest: 97
};

const config: HardhatUserConfig = {
  solidity: "0.8.17",

};

export default config;
