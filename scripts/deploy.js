async function main() {

  var token_name = "LatronicaCoin";
  // 1000 due to 18 decimals in solidity
  var initial_supply = 1000000000000000;  
  var decimal_units = 5;
  var token_symbol = "LatronaCoin";

  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Token = await ethers.getContractFactory("EIP20");
  const token = await Token.deploy( initial_supply, token_name, decimal_units,token_symbol);

  console.log("Token address:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });