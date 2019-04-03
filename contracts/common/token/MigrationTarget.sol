pragma solidity ^0.4.24;

/**
 * @title Migration target
 * @dev Implement this interface to make migration target
 */
contract MigrationTarget {
    function migrateFrom(address from, uint256 amount) external;
}