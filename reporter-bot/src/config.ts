import * as dotenv from "dotenv";

dotenv.config();

export const config = {
  jsonRpcUrl: process.env.JSON_RPC_URL ?? "http://localhost:8545",
  privateKey: process.env.PRIVATE_KEY,
};
