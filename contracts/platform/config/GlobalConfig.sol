pragma solidity ^0.4.24;

import "../../common/token/ISmartIdeaToken.sol";


contract GlobalConfig {

    enum Vote {
        Abstain, Aye, Nay
    }

    uint8 constant MINIMUM_BALLOTS = 1;

    ISmartIdeaToken constant SUT = ISmartIdeaToken(0xFf06BAccd44400a356ba64A9Aba4d76Cb1c99847);
    
    string constant CREATE_MARKET_NTT_KEY = "create_market";

}