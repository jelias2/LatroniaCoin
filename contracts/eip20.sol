/*
Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
.*/
pragma solidity >=0.4.22 <0.7.4;

import "hardhat/console.sol";

contract EIP20 {

    // Looks like here we are creatiing a uint256 constant to the max unsigned value we can use
    uint256 constant private MAX_UINT256 = 2**256 - 1;


    /* 
    This array will map the balances of the token to each address
    sort of like the ledger at the bank for each account, public means external to everyone
    */
    mapping (address => uint256) public balances;


    /* 
    This array will map what address has permission to spend on another addresses behalf
    Notice the transferFrom function. The fist mapping is the _from (who is being debted).
    We check if the from address has a allowed the msg.sender to spend up to a certian threshold
    allowed[from_addr][addr_which_have_permission_to_spend_on_from_addr][allowed_spending_balance]
    */
    mapping (address => mapping (address => uint256)) public allowed;

    /* 
    Total supply of the token
    */
    uint256 public totalSupply;

    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg SBX

    /*
    Constructor function
    */
    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
        totalSupply = _initialAmount;                        // Update total supply
        name = _tokenName;                                   // Set the name for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
        console.log("Inital amount is %d tokens", _initialAmount);
        console.log("_tokenName %s", _tokenName);
        console.log("Owner %s", msg.sender);
    }

    /*
    @notice Transfers the amount of token from the `msg.sender` to the recipient
    differs from transferFrom in that the msg.senders account will always be deducted
    @param _to The account that will receive the amount transferred
    @param _value The number of tokens to send from the sender to the recipient
    @return success Returns true for a successful transfer, false for an unsuccessful transfer
    */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }


    /*
    @notice Transfers `amount` tokens from `sender` to `recipient` up to the allowance given to the `msg.sender`
    Differs from transfer in that the msg sender can chose which address is deducted from ( Not explicity the senders )
    @param _from The account from which the transfer will be initiated
    @param _to The recipient of the transfer
    @param _value The amount of the transfer
    @return success Returns true for a successful transfer, false for unsuccessful
    */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }


    /*
    @notice Returns the balance of a token
    @param _owner The account for which to look up the number of tokens it has, i.e. its balance
    @return balance The number of tokens held by the account
    */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        console.log("balance of %s", _owner);
        return balances[_owner];
    }

    /*
    @notice Sets the allowance of a spender from the `msg.sender` to the value `amount`
    Sender is giving an external address ability to spend the coin
    @param spender The account which will be allowed to spend a given amount of the owners tokens
    @param amount The amount of tokens allowed to be used by `spender`
    @return Returns true for a successful approval, false for unsuccessful
    */

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    /* 
    @notice Returns the current allowance given to a spender by an owner
    If an address has given another address permision to spend, 
    look up how much money the permissioned account is able to spend
    @param owner The account of the token owner
    @param spender The account of the token spender
    @return The current allowance granted by `owner` to `spender`
    */
    function allowance(address _owner, address _spender) public returns (uint256 remaining) {
        emit Allowance(_owner, allowed[_owner][_spender]); //solhint-disable-line indent, no-unused-vars

        return allowed[_owner][_spender];
    }

    /*
    Transfer Event to emit and inform listeners
    */
    event Transfer(
        address owner,
        address addresses,
        uint _value
    );
    /*
    Transfer Event to emit and inform listeners
    */
    event Allowance(
        address owner,
        uint _owner
    );

    /*
    Approval Event to emit and inform listeners
    */
    event Approval(
        address sender,
        address spender,
        uint _value
    );
}


