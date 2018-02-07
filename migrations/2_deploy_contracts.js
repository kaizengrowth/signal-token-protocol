const SignalToken = artifacts.require("./SignalToken.sol");
const SignalTokenProtocol = artifacts.require("./SignalTokenProtocol.sol");
const { SIGNALS_TOKEN_ADDRESS } = require('../config');

module.exports = function(deployer, network, accounts) {
  if (network == "live") {
    return deployer.deploy(SignalTokenProtocol, SIGNALS_TOKEN_ADDRESS);
  } else {
    deployer.deploy(SignalToken).then(() => {
      return deployer.deploy(SignalTokenProtocol, SignalToken.address);
    });
  }
};
