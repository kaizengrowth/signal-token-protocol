const { INFURA_API_KEY } =require('./config');
const { MNEMONIC } = require('./config');

var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    development: {
      network_id: 5777,
      host: "localhost",
      port: 8545
    },
    ropsten:  {
      provider: new HDWalletProvider(MNEMONIC, "https://ropsten.infura.io/"+INFURA_API_KEY),
      network_id: 3,
      gas: 3000000
    }
  }
};
