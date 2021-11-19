import * as ethers from "ethers";
import { config } from "./config";
const provider = new ethers.providers.InfuraProvider("homestead", process.env.INFURA_KEY);
const wallet = new ethers.Wallet(config.privateKey);

wallet.connect(provider);

export { wallet, provider };
