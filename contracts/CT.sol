pragma solidity >=0.4.21 <0.6.0;



import "./MigratableToken.sol";

import "./RateCalc.sol";

import "./MarketConfig.sol";

import "./GlobalConfig.sol";

import "./ISmartUp.sol";

import "./TokenRecipient.sol";

import "./LockRequestable.sol";


/**

 * @title CT

 */

contract CT is MigratableToken, tokenRecipient, MarketConfig, GlobalConfig, LockRequestable {

    using RateCalc for uint256;

    using IterableSet for IterableSet.AddressSet;

    IterableSet.AddressSet private _jurors; //pei shengyuan 

    uint8[] private _jurorsVote;

    address public creator;

    ISmartUp private _smartup; //addmenber

    uint8 public ballots; //xuanju

    uint256 public proposedPayoutAmount;

    // totalTraderSut = balanceOf(this) - totalPaidSut

    uint256 public totalTraderSut; 

    uint256 public totalPaidSut;

    uint256 private votingStart;

    bool public payoutNotRequested;

    bool public dissolved;

   // propose var
    struct Proposal {

        uint256  validTime; //validity 3 days;

        uint256[] score;     //choice vote count;

        address[] voters;

        address   origin; 

    }

    //uint256 internal DEFAULT_VALITIME = 15 minutes;
    mapping(bytes32 => Proposal)  proposalId;

    mapping(address => mapping(bytes32 => uint256[]))  voterInfo;

    mapping(address => mapping(bytes32 => uint256))  perProposalVoterCt;

    mapping(bytes32 => bool)  isVoterWithdraw;

    modifier whenTrading() {

        require(payoutNotRequested && !dissolved);

        _;

    }

    // event Voting(uint8 _appealRound, address[] _jurors, uint256 _flaggedTime);

    event BuyCt(address _ctAddress, address _buyer, uint256 _setSut, uint256 _costSut, uint256 _ct);

    event SellCt(address _ctAddress, address _sell, uint256 _sut, uint256 _ct);

    event NewProposal(address _ctAddress, address _proposer, bytes32 _proId);

    event NewVoter(address _ctAddress, uint8 _choice, uint256 _ct, address _voter, bytes32 _proId);

    event WithDraw(address _ctAddress, address _drawer, uint256 _totoal, bytes32 _proId);

    event ProposePayout(address _ctAddress, address _proposer, uint256 _amount);

    event JurorVote(address _ctAddress, address _juror, bool _approve);

    event DissolveMarket(address _ctAddress,  uint256 _sutAmount);

    constructor(address owner, address marketCreator) public Pausable(owner, true) {

        creator = marketCreator;

        payoutNotRequested = true;

        dissolved = false;

        _smartup = ISmartUp(msg.sender);

        //_tokenHolders.add(address(this));

    }

    
    function receiveApproval(address sutOwner, uint256 approvedSutAmount, address token, bytes calldata extraData) external {

        require(msg.sender == address(SUT));

        require(token == address(SUT));

        buy(sutOwner, approvedSutAmount, bytesToUint256(extraData, 0));

    }


    // Utility function to convert bytes type to uint256. Noone but this contract can call this function.

    function bytesToUint256(bytes memory input, uint offset) internal pure returns (uint256 output) {

        assembly {output := mload(add(add(input, 32), offset))}

    }


    function finalizeMigration(address tokenHolder, uint256 migratedAmount) internal {

        tokenHolder;

        migratedAmount;

    }

       /**********************************************************************************

     *                                                                                *

     * proposal session                                                                 *

     *                                                                                *

     **********************************************************************************/
    // create propose 
    function propose(uint8 choiceNum, uint8 validTime) external returns (bytes32 _proId) {

        require(_tokenHolders.contains(msg.sender));

        require( 2 <= choiceNum  && choiceNum <= 5, "proposal must in 2 - 5!");

        require(validTime == 0 || validTime == 3 || validTime == 5 || validTime == 7);

        _proId = _propose(choiceNum, validTime);

    }

    function _propose(uint8 _choiceNum, uint8 _validTime) private returns (bytes32 _proposalId) {
        uint256 time;

        if (_validTime == 0 || _validTime ==7) {
            //time = 7 days;
            time = 7 minutes;
        }else if(_validTime == 3) {
            //time = 3 days;
            time = 3 minutes;
        }else{
            //time = 5 days;
            time = 5 minutes;
        }

        _proposalId = generateLockId();

        uint256[] memory _score = new uint256[](uint256(_choiceNum));

        address[] memory _voters = new address[](uint256(0));

        Proposal memory newProposal = Proposal(now + time, _score, _voters, msg.sender);

        proposalId[_proposalId] = newProposal;

        emit NewProposal(address(this), msg.sender, _proposalId);

    }
    
    //vote for proposal
    function voteForProposal(uint8 mychoice, uint256 ctAmount, bytes32 _proposalId) external {
        require(ctAmount >= ONE_CT && ctAmount % ONE_CT == 0);
        require(now <= proposalId[_proposalId].validTime, "more than voting period!");
        require(_balances[msg.sender] > ctAmount, "not enough ct!");
        require(1 <= mychoice && mychoice <= proposalId[_proposalId].score.length);

        _balances[msg.sender] = _balances[msg.sender].sub(ctAmount);

        _balances[address(this)] = _balances[address(this)].add(ctAmount);

        if(voterInfo[msg.sender][_proposalId].length == 0) {
            // when this voter never vote for this proposal
            uint256[] memory myInfo = new uint256[](proposalId[_proposalId].score.length);
           
            voterInfo[msg.sender][_proposalId] = myInfo;

            voterInfo[msg.sender][_proposalId][mychoice - 1] = ctAmount;
            
            proposalId[_proposalId].voters.push(msg.sender);

            perProposalVoterCt[msg.sender][_proposalId] = ctAmount;

        }else if(voterInfo[msg.sender][_proposalId][mychoice - 1] == 0){
            //when this voter never vote for this choice of this proposal
            voterInfo[msg.sender][_proposalId][mychoice - 1] = ctAmount;

            perProposalVoterCt[msg.sender][_proposalId] = perProposalVoterCt[msg.sender][_proposalId].add(ctAmount);

        }else{
           // when this voter have already vote for this choice of this proposal
            voterInfo[msg.sender][_proposalId][mychoice - 1] = voterInfo[msg.sender][_proposalId][mychoice - 1].add(ctAmount);
            perProposalVoterCt[msg.sender][_proposalId] = perProposalVoterCt[msg.sender][_proposalId].add(ctAmount);
        }

        // add the vote for this choice;
        proposalId[_proposalId].score[mychoice - 1] = proposalId[_proposalId].score[mychoice - 1].add(ctAmount);

        emit NewVoter(address(this), mychoice, ctAmount, msg.sender, _proposalId);

    }
    

    function withdrawProposalCt(bytes32 _proposalId)external{

        require(proposalId[_proposalId].validTime != 0);

        require(now > proposalId[_proposalId].validTime, "proposal still in voting now!");

        require(isVoterWithdraw[_proposalId] == false, "you are alreday withdraw!");

        uint256 total;

        for(uint256 i = 0; i < proposalId[_proposalId].voters.length; i++ ){

        uint256 myCt = perProposalVoterCt[proposalId[_proposalId].voters[i]][_proposalId];

        delete perProposalVoterCt[proposalId[_proposalId].voters[i]][_proposalId];

        _balances[proposalId[_proposalId].voters[i]] = _balances[proposalId[_proposalId].voters[i]].add(myCt);

        _balances[address(this)] = _balances[address(this)].sub(myCt);

        total = total.add(myCt);     

        }

        isVoterWithdraw[_proposalId] = true;

        emit WithDraw(address(this), msg.sender, total, _proposalId);      

    }


    function getProposal(bytes32 _proposalId) external view returns(uint256 _validTime, uint256[] memory voteDetails, address[] memory _voters, address _origin){

        return (proposalId[_proposalId].validTime, proposalId[_proposalId].score, proposalId[_proposalId].voters, proposalId[_proposalId].origin);

    }


    /**********************************************************************************

     *                                                                                *

     * payout session                                                                 *

     *                                                                                *

     **********************************************************************************/

    function proposePayout(uint256 amount) external {

        require(msg.sender == creator);

        require(payoutNotRequested);

        // make sure the market has enough sut to withdraw

        require(amount <= totalTraderSut.sub(totalPaidSut));

        require(amount <= SUT.balanceOf(address(this)));

        drawJurors(msg.sender);

        proposedPayoutAmount = amount;

        votingStart = now;

        payoutNotRequested = false;

        emit ProposePayout(address(this), msg.sender, amount);

    }


    function votingPeriod() external view returns (uint256 start, uint256 end) {

        if (votingStart == 0) {

            start = 0;

            end = 0;

        } else {

            start = votingStart;

            end = votingStart.add(PAYOUT_VOTING_PERIOD);

        }

    }


    function drawJurors(address seeder) private {

        require(_tokenHolders.size() >= JUROR_COUNT, "Not enough remaining members to choose from");



        uint256 seed = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), seeder)));

        while (_jurors.size() < JUROR_COUNT) {

            uint256 index = seed % _tokenHolders.size();

            // make sure the member is neither a juror nor a flagger

            address holder = _tokenHolders.at(index);

            while (_jurors.contains(holder)) {

                holder = _tokenHolders.at(++index % _tokenHolders.size());

            }

            _jurors.add(holder);

            _jurorsVote.push(0);

            seed = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), seeder, index)));

        }
        // state = State.Voting;

    }


    function jurors() external view returns (address[] memory) {

        return _jurors.list();

    }

    function jurorVotes() external view returns (uint8[] memory) {

        return _jurorsVote;

    }


    function vote(bool approve) external {

        require(now - votingStart <= PAYOUT_VOTING_PERIOD);

        uint256 pos = _jurors.position(msg.sender);

        require(pos != 0);

        if (_jurorsVote[pos - 1] == 0) {

            ++ballots;

        }

        // should have been initialized

        _jurorsVote[pos - 1] = approve ? 1 : 2;

        emit JurorVote(address(this), msg.sender, approve);

    }


    function conclude() external {

        require(ballots == JUROR_COUNT || now - votingStart > PAYOUT_VOTING_PERIOD, "Voting still in process");

        uint256 aye = 0;

        uint256 nay = 0;

        for (uint256 i = 0; i < JUROR_COUNT; ++i) {

            if (_jurorsVote[i] == 2) {

                nay = nay.add(_balances[_jurors.at(i)]);

            } else if (_jurorsVote[i] == 1) {

                aye = aye.add(_balances[_jurors.at(i)]);

            }

        }

        if (aye > nay) {

            SUT.transfer(creator, proposedPayoutAmount);

            totalPaidSut = totalPaidSut.add(proposedPayoutAmount);

        }

        // cleanup once concluded

        ballots = 0;

        proposedPayoutAmount = 0;

        _jurors.destroy();

        delete _jurorsVote;

        votingStart = 0;

        payoutNotRequested = true;

    }


    function dissolve() external {

        require(msg.sender == address(_smartup));

        dissolved = true;

        // refund token _tokenHolders, TODO: split into multiple steps

        uint256 sutBalance = SUT.balanceOf(address(this));

        if (sutBalance > 0 && _totalSupply > 0) {

            for (uint256 i = 0; i < _tokenHolders.size(); ++i) {

                uint256 refundAmount = sutBalance.mul(_balances[_tokenHolders.at(i)]).div(_totalSupply);

                _balances[_tokenHolders.at(i)] = 0;

                SUT.transfer(_tokenHolders.at(i), refundAmount);

            }

        }

        _totalSupply = 0;

        emit DissolveMarket(address(this),  sutBalance);

    }


    /**********************************************************************************

     *                                                                                *

     * trading session                                                                *

     *                                                                                *

     **********************************************************************************/

    function buy(address buyer, uint256 approvedSutAmount, uint256 ctAmount) private whenTrading {

        require(ctAmount >= ONE_CT && ctAmount % ONE_CT == 0);

        uint256 i = _totalSupply.add(ONE_CT);

        uint256 j = i.add(ctAmount);

        uint256 tradedSut = uint256(i.calcSUT(j));

        require(approvedSutAmount >= tradedSut);

        require(SUT.transferFrom(buyer, address(this), tradedSut));

        _totalSupply = _totalSupply.add(ctAmount);

        _balances[buyer] = _balances[buyer].add(ctAmount);

        totalTraderSut = totalTraderSut.add(tradedSut);

        _tokenHolders.add(buyer);

        _smartup.addMember(buyer);

        emit BuyCt(address(this), buyer, approvedSutAmount, tradedSut, ctAmount);

    }

    function sell(uint256 ctAmount) public {

        _sell(msg.sender, ctAmount);
         
    }

    function _sell(address seller, uint256 ctAmount) private whenTrading {

        require(ctAmount >= ONE_CT && ctAmount % ONE_CT == 0);

        require(_totalSupply >= ctAmount);

        require(_balances[seller] >= ctAmount);
        

        uint256 j = _totalSupply.add(ONE_CT);

        uint256 i = j.sub(ctAmount);

        uint256 tradedSut = uint256(i.calcSUT(j));

        SUT.transfer(seller, tradedSut);

        _totalSupply = _totalSupply.sub(ctAmount);


        _balances[seller] = _balances[seller].sub(ctAmount);
        

        totalTraderSut = totalTraderSut.sub(tradedSut);
        
        if (_balances[seller] == 0) {

            _tokenHolders.remove(seller);

        }

        emit  SellCt(address(this), seller, tradedSut, ctAmount);

    }


    function bidQuote(uint256 ctAmount) public view returns (uint256) {

        require(ctAmount >= ONE_CT && ctAmount % ONE_CT == 0);

        uint256 i = _totalSupply.add(ONE_CT);

        uint256 j = i.add(ctAmount);

        return uint256(i.calcSUT(j));

    }

    function askQuote(uint256 ctAmount) public view returns (uint256) {

        require(ctAmount >= ONE_CT && ctAmount % ONE_CT == 0);

        require(_totalSupply >= ctAmount);

        uint256 j = _totalSupply.add(ONE_CT);

        uint256 i = j.sub(ctAmount);

        return uint256(i.calcSUT(j));

    }

}