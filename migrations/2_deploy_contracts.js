const SignalToken = artifacts.require("./SignalToken.sol");
const SignalTokenProtocol = artifacts.require("./SignalTokenProtocol.sol");

module.exports = function(deployer, network, accounts) {
  if (network == "live") {
    return deployer.deploy(SignalTokenProtocol, "0x6888a16ea9792c15a4dcf2f6c623d055c8ede792");
  } else {
    deployer.deploy(SignalToken).then(() => {
      return deployer.deploy(SignalTokenProtocol, SignalToken.address);
    });
  }
};
