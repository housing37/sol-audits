// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.2;

interface IStaking {
   function checkHighestStaker(address user) external returns (bool);
   function mapUserInfo(address voter) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256);
}

contract pTGCDAO {
	uint256 public immutable votingPeriod;
	uint256 public proposalCount;
	
	uint256[] public activeProposal;
	address public immutable staking;
	uint256 public lockedAmount;
	
	struct Proposal {
      uint256 id;
	  uint256 fundRequest;
      uint256 startTime;
      uint256 endTime;
      uint256 forVotes;
      uint256 againstVotes;
	  uint256 voters;
	  bool claimed;
	  address proposer;
	  mapping (address => Receipt) receipts;
    }
	
	struct Receipt {
	  bool hasVoted;
	  uint256 support;
    }
	
	enum ProposalState {
	  Active,
	  Defeated,
	  Succeeded    
	}
	
	mapping (address => uint256) public latestProposalIds;
	mapping (uint => Proposal) public proposals;
	
    event ProposalCreated(uint256 id, address proposer, uint256 startTime, uint256 endTime, string description);
    event VoteCast(address indexed voter, uint256 proposalId, uint256 support, uint256 votes);
    event ProposalCanceled(uint256 id);
	event ProposalApproved(uint256 id);
	
    constructor () {
	   votingPeriod = 7 * 86400;
	   staking = address(0xC71f597a2AC39E47F07102E849d18489C96f39EF);
    }
	
	receive() external payable {}
	
    function propose(uint256 fundRequest, string memory description) public returns (uint256) {
        uint256 latestProposalId = latestProposalIds[msg.sender];
		if (latestProposalId != 0) {
           ProposalState proposersLatestProposalState = state(latestProposalId);
           require(proposersLatestProposalState != ProposalState.Active, "Governor::propose: one live proposal per proposer, found an already active proposal");
        }
		
		removeDefeatedProposal();
		
		require(IStaking(staking).checkHighestStaker(msg.sender),"Governor::propose: only top staker");
		require(fundRequest <= 100000000 * 10**18,"Governor::propose: max 100000000  PLS limit");
		require(fundRequest >= 1 * 10**18,"Governor::propose: min 1 PLS limit");
		require(address(this).balance - lockedAmount >= fundRequest,"Governor::propose: insufficient fund");
		
        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
		
        newProposal.id = proposalCount;
		newProposal.fundRequest = fundRequest;
        newProposal.proposer = msg.sender;
        newProposal.startTime = block.timestamp;
        newProposal.endTime = block.timestamp + votingPeriod;
        newProposal.forVotes = 0;
        newProposal.againstVotes = 0;
		newProposal.claimed = false;
		newProposal.voters = 0;
		
        latestProposalIds[newProposal.proposer] = newProposal.id;
		lockedAmount += fundRequest; 
		
        emit ProposalCreated(newProposal.id, msg.sender, block.timestamp, (block.timestamp + votingPeriod), description);
        activeProposal.push(proposalCount);
		return newProposal.id;
    }
	
	function removeDefeatedProposal() public {
	    if(activeProposal.length > 0)
		{
		   for (uint256 i = 0; i < activeProposal.length; i++) 
		   {
		       uint256 proposalId = activeProposal[i];
			   Proposal storage proposal = proposals[proposalId];
			   if(state(proposalId) == ProposalState.Defeated)
			   {
				   lockedAmount -= proposal.fundRequest; 
				   activeProposal[i] = activeProposal[activeProposal.length - 1];
				   activeProposal.pop();
				   removeDefeatedProposal();
				   break;
			   } 
			   else if(state(proposalId) == ProposalState.Succeeded)
			   {
			       activeProposal[i] = activeProposal[activeProposal.length - 1];
				   activeProposal.pop();
				   removeDefeatedProposal();
				   break;
			   }
		   }
		}
	}
	
    function getReceipt(uint256 proposalId, address voter) external view returns (Receipt memory) {
       return proposals[proposalId].receipts[voter];
    }
	
    function state(uint256 proposalId) public view returns (ProposalState) {
        require(proposalCount >= proposalId, "Governor::state: invalid proposal id");
        Proposal storage proposal = proposals[proposalId];
        if (block.timestamp <= proposal.endTime) {
            return ProposalState.Active;
        } else if (proposal.forVotes <= proposal.againstVotes) {
            return ProposalState.Defeated;
        } if (proposal.forVotes > proposal.againstVotes && votingPercent(proposalId) >= 65 && proposal.voters >= 5) {
            return ProposalState.Succeeded;
        } else {
            return ProposalState.Defeated;
        }
    }
	
    function castVote(uint256 proposalId, uint256 support) external {
        removeDefeatedProposal();
		emit VoteCast(msg.sender, proposalId, support, castVoteInternal(msg.sender, proposalId, support));
    }
	
    function castVoteInternal(address voter, uint proposalId, uint256 support) internal returns (uint256) {
        (uint256 amount, , , , , , ) = IStaking(staking).mapUserInfo(voter);
		require(state(proposalId) == ProposalState.Active, "Governor::castVoteInternal: voting is closed");
		require(support <= 1, "Governor::castVoteInternal: invalid vote type");
        Proposal storage proposal = proposals[proposalId];
        Receipt storage receipt = proposal.receipts[voter];
        require(receipt.hasVoted == false, "Governor::castVoteInternal: voter already voted");
        require(amount > 0, "Governor::castVoteInternal: not eligible for voting");
		
        if (support == 0) 
		{
           proposal.againstVotes += amount;
        } 
		else if (support == 1) 
		{
           proposal.forVotes += amount;
        } 
		proposal.voters += 1;
        receipt.hasVoted = true;
        receipt.support = support;
        return (proposal.forVotes + proposal.againstVotes);
    }
	
	function claimFund(uint256 proposalId) external {
	   Proposal storage proposal = proposals[proposalId];
	   require(state(proposalId) == ProposalState.Succeeded, "Governor::claimFund: proposal is not succeeded");
	   require(proposal.claimed == false, "Governor::claimFund: Fund already claimed");
	   
	   proposal.claimed = true;
	   lockedAmount -= proposal.fundRequest; 
	   payable(address(proposal.proposer)).transfer(proposal.fundRequest);
    }
	
	function votingPercent(uint256 proposalId) public view returns(uint256){
	   Proposal storage proposal = proposals[proposalId];
	   
	   uint256 totalVote = proposal.forVotes + proposal.againstVotes;
	   return proposal.forVotes * 100 / totalVote;
    }
}