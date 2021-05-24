const Governance = artifacts.require("Governance");
const FomoStrategy = artifacts.require("FomoStrategy");
const FomoToken = artifacts.require("FomoToken");

module.exports = function(deployer) {
  // deployer.deploy(Governance);
  // deployer.deploy(FomoStrategy);
  deployer.deploy(FomoToken)
};
