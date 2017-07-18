var Beacon = artifacts.require("./Beacon.sol");


module.exports = function(deployer) {
  deployer.deploy(Beacon);
};
