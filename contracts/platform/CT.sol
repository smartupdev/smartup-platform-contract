pragma solidity ^0.4.24;

import "../common/token/MigratableToken.sol";
import "../common/libraries/RateCalc.sol";
import "./config/MarketConfig.sol";
import "./config/GlobalConfig.sol";
import "./ISmartUp.sol";
import "./TokenRecipient.sol";



/**
 * @title CT
 */
contract CT is MigratableToken, tokenRecipient, MarketConfig, GlobalConfig {

    using RateCalc for uint256;
    using IterableSet for IterableSet.AddressSet;


    IterableSet.AddressSet private _jurors;
    uint8[] private _jurorsVote;


    address public creator;
    ISmartUp private _smartup;

    uint8 public ballots;
    uint256 public proposedPayoutAmount;

    // totalTraderSut = balanceOf(this) - totalPaidSut
    uint256 public totalTraderSut;
    uint256 public totalPaidSut;
    uint256 private votingStart;

    bool public payoutNotRequested;
    bool public dissolved;


    modifier whenTrading() {
        require(payoutNotRequested && !dissolved);
        _;
    }


    // event Voting(uint8 _appealRound, address[] _jurors, uint256 _flaggedTime);



    constructor(address owner, address marketCreator) public Pausable(owner, true) {
        creator = marketCreator;
        payoutNotRequested = true;
        dissolved = false;
        _smartup = ISmartUp(msg.sender);
    }


    function receiveApproval(address sutOwner, uint256 approvedSutAmount, address token, bytes extraData) external {
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


    function jurors() external view returns (address[]) {
        return _jurors.list();
    }

    function jurorVotes() external view returns (uint8[]) {
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
    }


    function sell(uint256 ctAmount) public {
        sell(msg.sender, ctAmount);
    }


    function sell(address seller, uint256 ctAmount) private whenTrading {
        require(ctAmount >= ONE_CT && ctAmount % ONE_CT == 0);
        require(_totalSupply >= ctAmount);
        require(_balances[seller] >= ctAmount);

        uint256 j = _totalSupply.add(ONE_CT);
        uint256 i = j.sub(ctAmount);

        uint256 tradedSut = uint256(i.calcSUT(j)).mul(SUT.balanceOf(address(this))).div(totalTraderSut);

        SUT.transfer(seller, tradedSut);

        _totalSupply = _totalSupply.sub(ctAmount);
        _balances[seller] = _balances[seller].sub(ctAmount);
        totalTraderSut = totalTraderSut.sub(tradedSut);
        if (_balances[seller] == 0) {
            _tokenHolders.remove(seller);
        }
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

        return uint256(i.calcSUT(j)).mul(SUT.balanceOf(address(this))).div(totalTraderSut);
    }
}