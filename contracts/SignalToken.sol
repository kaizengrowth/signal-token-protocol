pragma solidity ^0.4.18;

import './zeppelin/token/MintableToken.sol';


contract SignalToken is MintableToken {
  string public name = "Signal Token";
  string public symbol = "SIG";
  string public version = "1.0";
  uint256 public decimals = 18;

  function SignalToken() public {
    owner = msg.sender;
    uint256 initialMint = 1000000 * (10**decimals);
    mint(msg.sender, initialMint);
  }
}
