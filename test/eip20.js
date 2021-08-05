const { expect } = require("chai");
const truffleAssert = require('truffle-assertions');

describe("EIP20 Constructor", function () {
  it("should deploy the contract and give the owner all the tokens", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const EIP20factory = await ethers.getContractFactory("EIP20");
    const ltc_contract = await EIP20factory.deploy(10, "latronicoin", 1, "LTC");
    await ltc_contract.deployed();
    expect(await ltc_contract.balanceOf(owner.address)).to.equal(10);
    //TODO: Add get functions for things like token name and total supply
    // and test those value here
  });
});


describe("EIP20 Transfer function", function () {
  it("transfers tokens from owner to addr 1 successfully", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const EIP20factory = await ethers.getContractFactory("EIP20");
    const ltc_contract = await EIP20factory.deploy(10, "latronicoin", 1, "LTC");
    await ltc_contract.deployed();

    // Check the balances at the beginning
    expect(await ltc_contract.balanceOf(owner.address)).to.equal(10);
    expect(await ltc_contract.balanceOf(addr1.address)).to.equal(0);

    // Perform the transfer 
    await ltc_contract.transfer(addr1.address, 1);

    // Check the balances at the beginning
    expect(await ltc_contract.balanceOf(owner.address)).to.equal(9);
    expect(await ltc_contract.balanceOf(addr1.address)).to.equal(1);
  });

  it("fails to transfer tokens from addr1 if addr1 does not have tokens", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const EIP20factory = await ethers.getContractFactory("EIP20");
    const ltc_contract = await EIP20factory.deploy(0, "latronicoin", 1, "LTC");
    await ltc_contract.deployed();

    // Check the balances at the beginning
    expect(await ltc_contract.balanceOf(addr1.address)).to.equal(0);
    expect(await ltc_contract.balanceOf(owner.address)).to.equal(0);

    // Perform the failing transfer 
    await truffleAssert.reverts(ltc_contract.transfer(addr1.address, 1), "");
  });
});


describe("EIP20 approve function", function () {
  it("owner can successfuly approves addr1", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const EIP20factory = await ethers.getContractFactory("EIP20");
    const ltc_contract = await EIP20factory.deploy(10, "latronicoin", 1, "LTC");
    await ltc_contract.deployed();

    // Check the approval balances to be zero at the start
    expect(await ltc_contract.allowance(addr1.address, owner.address)).to.equal(true);
    
    // // Send the approval function
    expect(await ltc_contract.approve(addr1.address, 1)).to.equal(true);

    // Should be 1 now
    expect(await ltc_contract.allowance(owner.address,addr1.address)).to.equal(1);
  });
});