import { expect, use } from "chai";
import { utils, constants, Contract } from "ethers";
import { deployContract, MockProvider, solidity } from "ethereum-waffle";

import InjectionFeeds from "../../../build/InjectionFeeds.json";

use(solidity);

describe("InjectionFeeds", () => {
  const [wallet] = new MockProvider().getWallets();
  let contract: Contract;

  beforeEach(async () => {
    contract = await deployContract(wallet, InjectionFeeds);
  });

  it("creates a personal feed", async () => {
    const id: string = utils.formatBytes32String("test-name");
    const description: string = "test description of arbitrary size";
    const permissions: Object = {
      owner: constants.AddressZero,
      providers: [wallet.address],
    };

    await expect(contract.createFeed(id, description, permissions)).to.emit(contract, "FeedCreated");
    expect(await contract.isCreated(id)).to.equal(true);
  });
});
