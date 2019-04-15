pragma solidity >=0.4.21 <0.6.0;

import "./IGradeable.sol";


contract PlatformConfig {
    
    IGradeable constant NTT = IGradeable(0x846cE03199A759A183ccCB35146124Cd3F120548); 
    uint8 constant CREATE_MARKET_ACTION = 1;
    uint8 constant FLAG_MARKET_ACTION = 2;
    uint8 constant APPEAL_MARKET_ACTION = 3;
    
    uint256 constant MINIMUM_FLAGGING_DEPOSIT = 100 * (10 ** 18);
    uint256 constant FLAGGING_DEPOSIT_REQUIRED = 2500 * (10 ** 18);
    uint256 constant APPEALING_DEPOSIT_REQUIRED = 2500 * (10 ** 18);
    uint256 constant CREATE_MARKET_DEPOSIT_REQUIRED = 2500 * (10 ** 18);

    uint256 constant JUROR_COUNT = 3;
    
    uint256 constant PROTECTION_PERIOD = 90 seconds;
    uint256 constant VOTING_PERIOD = 3 minutes;
    uint256 constant FLAGGING_PERIOD = 3 minutes;
    uint256 constant APPEALING_PERIOD = 3 minutes;

}