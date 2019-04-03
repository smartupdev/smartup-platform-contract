pragma solidity ^0.4.24;


/**
 * @title IGradeable
 */
interface IGradeable {
    
    function isAllow(address user, string action) external view returns (bool);

    function raiseCredit(address user, uint256 score) external;

    function lowerCredit(address user, uint256 score) external;
}