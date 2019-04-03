pragma solidity ^0.4.24;

import "../IGradeable.sol";


contract PlatformConfig {
    
    IGradeable constant NTT = IGradeable(0xA01f5244B17b0D206903ac40A940FE981768090d);
    
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