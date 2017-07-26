var SmartDevice = artifacts.require("./SmartDevice.sol");
var Ownership = artifacts.require("../../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownership);
  deployer.link(Ownership, SmartDevice);
  deployer.deploy(SmartDevice, {gas:2000000});
};
