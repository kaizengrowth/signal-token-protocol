const SignalToken = artifacts.require("./SignalToken.sol");
const SignalTokenProtocol = artifacts.require("./SignalTokenProtocol.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(SignalToken).then(() => {
    return deployer.deploy(SignalTokenProtocol, SignalToken.address);
  });
};
