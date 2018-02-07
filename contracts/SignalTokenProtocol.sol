pragma solidity ^0.4.18;

import './zeppelin/math/SafeMath.sol';

interface ERC20 {
  function balanceOf(address who) public constant returns (uint);
  function allowance(address owner, address spender) public constant returns (uint);

  function transfer(address to, uint value) public returns (bool ok);
  function transferFrom(address from, address to, uint value) public returns (bool ok);
  function approve(address spender, uint value) public returns (bool ok);

  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

contract SignalTokenProtocol {
  struct Campaign {
    address advertiser;
    string title;
    string description;
    string contentUrl;
    uint256 reward;
    uint256 budget;
  }

  event CampaignCreated(address indexed _advertiser, string _title, uint256 _reward);
  event CampaignExecuted(uint256 _campaignId, address indexed _publisher, uint256 _reward);
  event CampaignDeleted(uint256 _campaignId);

  mapping(uint256 => Campaign) public campaigns;
  uint256[] public campaignsTable;

  ERC20 public signalToken;

  function SignalTokenProtocol(address _signalToken) public {
    signalToken = ERC20(_signalToken);
  }

  function getCampaignsCount()
    public
    view
    returns (uint256)
  {
    return campaignsTable.length;
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
    assert(bytes(title).length > 0);
    assert(bytes(contentUrl).length > 0);
    assert(budget >= reward);

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

  function deleteCampaign(uint256 campaignId)
    public
    returns (bool)
  {
    var campaign = campaigns[campaignId];
    assert(campaign.advertiser == msg.sender);
    delete campaigns[campaignId];
    CampaignDeleted(campaignId);
    return true;
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
