pragma solidity >=0.4.21 <0.6.0;

import "./ISmartIdeaToken.sol";


contract GlobalConfig {

    enum Vote {
        Abstain, Aye, Nay
    }

    uint8 constant MINIMUM_BALLOTS = 1; 

    ISmartIdeaToken constant  SUT = ISmartIdeaToken(0xF1899c6eB6940021C1aE4E9C3a8e29EE93704b03);
    
    //address constant Ad = address(0x692a70d2e424a56d2c6c27aa97d1a86395877b3a);

    
    
    string constant CREATE_MARKET_NTT_KEY = "create_market";
    

}