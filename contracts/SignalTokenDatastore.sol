pragma solidity ^0.4.18;

import './zeppelin/ownership/Ownable.sol';

contract SignalTokenDatastore is Ownable {
  struct Campaign {
    address advertiser;
    string title;
    string description;
    string contentUrl;
    uint256 reward;
    uint256 budget;
  }

  struct Referral {
    uint256 campaignId;
    address publisher;
    string endpoint;
  }

  mapping(uint256 => Campaign) public campaigns;
  uint256[] public campaignsTable;

  mapping(uint256 => Referral) public referrals;
  uint256[] public referralsTable;

  function SignalTokenDatastore(address _address) public {
    owner = _address;
  }

  function getCampaignsCount()
    public
    view
    returns (uint256)
  {
    return campaignsTable.length;
  }

  function getReferralsCount()
    public
    view
    returns (uint256)
  {
    return referralsTable.length;
  }

  function getCampaignContent(uint256 campaignId)
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

  function getCampaign(uint256 campaignId)
    public
    view
    returns (Campaign campaign) 
  {
    return campaigns[campaignId];
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

    return campaignId;
  }
}
