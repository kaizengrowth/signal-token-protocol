pragma solidity ^0.4.18;

import './SignalToken.sol';
import './zeppelin/math/SafeMath.sol';


contract SignalTokenProtocol {
  struct Campaign {
    address advertiser;
    string title;
    string description;
    string contentUrl;
    uint256 reward;
    uint256 budget;
  }

  event Faucet(address indexed _address, uint256 _amount);
  event CampaignCreated(
    address indexed _advertiser,
    string _title,
    uint256 _reward
  );
  event CampaignExecuted(
    uint256 _campaignId,
    address indexed _publisher,
    uint256 _reward
  );

  mapping(uint256 => Campaign) public campaigns;
  uint256[] public campaignsTable;

  SignalToken public signalToken;

  function SignalTokenProtocol() public {
    signalToken = new SignalToken(this);
  }

  function getCampaignsCount()
    public
    view
    returns (uint256)
  {
    return campaignsTable.length;
  }

  function getSignalTokenAddress()
    public
    constant
    returns (SignalToken)
  {
    return signalToken;
  }

  function faucet()
    public
    returns (bool)
  {
    uint256 amount = 500000;
    Faucet(msg.sender, amount);
    return signalToken.mint(msg.sender, amount);
  }

  function createCampaign(
    string title,
    string description,
    string contentUrl,
    uint256 reward,
    uint256 budget
  )
    public
    returns (uint256 campaignId)
  {
    campaignId = campaignsTable.length++;
    campaignsTable[campaignId] = campaignId;

    campaigns[campaignId] = Campaign(
      msg.sender,
      title,
      description,
      contentUrl,
      reward,
      budget
    );

    CampaignCreated(msg.sender, title, reward);
    return campaignId;
  }

  function getCampaign(uint256 campaignId)
    public
    view
    returns (
      address advertiser,
      string title,
      string description,
      string contentUrl,
      uint256 reward,
      uint256 budget
    ) {
    Campaign storage campaign = campaigns[campaignId];

    advertiser = campaign.advertiser;
    title = campaign.title;
    description = campaign.description;
    contentUrl = campaign.contentUrl;
    reward = campaign.reward;
    budget = campaign.budget;

    return (advertiser, title, description, contentUrl, reward, budget);
  }

  function executeCampaign(uint256 campaignId, address publisher)
    public
    returns (bool)
  {
    var campaign = campaigns[campaignId];
    assert(campaign.budget > campaign.reward);

    bool success = signalToken.transferFrom(campaign.advertiser, publisher, campaign.reward);
    if (success) {
      campaign.budget = SafeMath.sub(campaign.budget, campaign.reward);
      CampaignExecuted(campaignId, publisher, campaign.reward);
    }

    return success;
  }  
}
