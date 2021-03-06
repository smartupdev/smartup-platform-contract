pragma solidity ^0.4.24;

import "./IGradeable.sol";
import "../common/token/MigratableToken.sol";


/**
 * @title NTT
 */
contract NTT is IGradeable, MigratableToken {

    // using positive number as score, as '0' represents not exists (default value for nonexistent entry is '0')
    uint256 constant ZERO_NTT = 1;


    uint256 private _defaultNtt = 100;
    uint256 private _createMarketMinimum = 100;
    uint256 private _flagMarketMinimum = 50;

    mapping(string => uint256) private _nttRequired;

    mapping(address => bool) private _graders;

    modifier onlyGrader() {
        require(_graders[msg.sender]);
        _;
    }


    // NTT is not transferrable, at least at the beginning
    constructor(address owner) public Pausable(owner, true) {
        _nttRequired["create_market"] = 100;
        _nttRequired["flag_market"] = 50;
    }


    /**
     * @dev prevent eth to be sent to this contract
     */
    function() external payable {
        revert();
    }


    function isAllow(address user, string action) external view returns (bool) {
        if (_nttRequired[action] != 0) {
            return checkCredit(user) >= _nttRequired[action];
        } else {
            return false;
        }
    }


    function adjustDefaultNtt(uint256 newDefault) external onlyOwner {
        _defaultNtt = newDefault;
    }


    function adjustNttRequirement(string action, uint256 min) external onlyOwner {
        _nttRequired[action] = min;
    }


    function addGrader(address grader) external onlyOwner {
        // TODO: maybe check if _address is from a eligible contract?
        _graders[grader] = true;
    }


    function removeGrader(address grader) external onlyOwner {
        delete _graders[grader];
    }


    /**
     * @dev check the NTT credit score for a user
     * @param user the address of user to check
     * @return NTT score range from 0 to MAX of uint256
     */
    function checkCredit(address user) public view returns (uint256) {
        if (_balances[user] != 0) {
            return _balances[user].sub(ZERO_NTT);
        }
        return _defaultNtt;
    }


    /**
     * @dev raise the NTT credit score for a user
     * @param user the address of user to raise
     * @param score NTT score to raise
     */
    function raiseCredit(address user, uint256 score) external whenMigrationUnstarted onlyGrader {
        _initIfNotExist(user);
        _balances[user] = _balances[user].add(score);
    }


    /**
     * @dev lower the NTT credit score for a user
     * @param user the address of user to lower
     * @param score NTT score to lower
     */
    function lowerCredit(address user, uint256 score) external whenMigrationUnstarted onlyGrader {
        _initIfNotExist(user);

        if (_balances[user] <= score) {
            // make sure minimum balance of an existing user is ZERO_SCORE, where 0 represents nonexistent user
            _balances[user] = ZERO_NTT;
        } else {
            _balances[user] = _balances[user].sub(score);
        }
    }


    function _initIfNotExist(address user) private {
        if (_balances[user] == 0) {
            _balances[user] = _defaultNtt.add(ZERO_NTT);
            _tokenHolders.add(user);
        }
    }


    /**
     * @dev Override totalSupply() as it's not applicable to NTT
     */
    function totalSupply() public view returns (uint256) {
        return 0;
    }


    /**
     * @dev Override balanceOf() to return credit score instead of actual balance
     * @param owner The address to query the balance of.
     * @return A uint256 representing the NTT score of the passed address.
     */
    function balanceOf(address owner) public view returns (uint256) {
        return checkCredit(owner);
    }


    function finalizeMigration(address tokenHolder, uint256 migratedAmount) internal {
        // doing nothing, just to get rid of compiler warnings
        tokenHolder;
        migratedAmount;
    }
}