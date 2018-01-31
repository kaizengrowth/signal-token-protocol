import INFURA_API_KEY from './config'
import MNEMONIC from './config'

var HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  networks: {
    development: {
      network_id: 5777,
      host: "localhost",
      port: 8545
    },
    ropsten:  {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+infura_apikey),
      network_id: 3,
      gas: 3000000
    }
  }
};
