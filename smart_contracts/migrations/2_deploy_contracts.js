var Beacon = artifacts.require("./Beacon.sol");
var SmartDevice = artifacts.require("./SmartDevice.sol");
var ECVerify = artifacts.require("./lib/ECVerify.sol");

module.exports = function(deployer) {
  deployer.deploy(ECVerify);
  deployer.deploy(Beacon);
  deployer.deploy(SmartDevice);
  deployer.autolink(SmartDevice);
};
