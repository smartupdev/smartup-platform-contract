pragma solidity ^0.4.24;

contract Ownable {
    
    address private _owner;
    address private _newOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    constructor (address owner) internal {
        if (owner == address(0)) {
            _owner = msg.sender;
        } else {
            _owner = owner;
        }
    }

    function initiateOwnershipTransfer(address newOwner) external onlyOwner {
        _newOwner = newOwner;
    }

    function cancelOwnershipTransfer() external onlyOwner {
        _newOwner = address(0);
    }

    function confirmOwnershipTransfer() external {
        require(msg.sender == _newOwner);
        emit OwnershipTransferred(_owner, _newOwner);
        _owner = _newOwner;
    }
    
    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function owner() public view returns (address) {
        return _owner;
    }
}