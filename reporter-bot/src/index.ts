import * as cron from "node-cron";
import { Every } from "./utils/every";
import { wallet, provider } from "./wallet";

async function main() {
  console.log(await provider.getBlockNumber());
}

cron.schedule(Every.minute, main);
