// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.5.0 <0.9.0;
import "./IERC20Token.sol";
import "./Utils.sol";
import "./SafeMath.sol";

/// @notice  invariant  totalSupply  ==  __verifier_sum_uint(balanceOf)
contract ERC20Token is IERC20Token, Utils {
    using SafeMath for uint256;


    string public  name;
    string public  symbol;
    uint8 public  decimals;
    uint256 public  totalSupply;
    mapping (address => uint256) public  balanceOf;
    mapping (address => mapping (address => uint256)) public  allowance;

    /**
      * @dev triggered when tokens are transferred between wallets
      *
      * @param _from    source address
      * @param _to      target address
      * @param _value   transfer amount
    */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
      * @dev triggered when a wallet allows another wallet to transfer tokens from on its behalf
      *
      * @param _owner   wallet that approves the allowance
      * @param _spender wallet that receives the allowance
      * @param _value   allowance amount
    */
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /**
      * @dev initializes a new ERC20Token instance
      *
      * @param _name        token name
      * @param _symbol      token symbol
      * @param _decimals    decimal points, for display purposes
      * @param _totalSupply total supply of token units
    */
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public {
        // validate input
        require(bytes(_name).length > 0, "ERR_INVALID_NAME");
        require(bytes(_symbol).length > 0, "ERR_INVALID_SYMBOL");

        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
    }

    /**
      * @dev transfers tokens to a given address
      * throws on any error rather then return a false flag to minimize user errors
      *
      * @param _to      target address
      * @param _value   transfer amount
      *
      * @return true if the transfer was successful, false if it wasn't
    */
    /// @notice  postcondition ( ( balanceOf[msg.sender] ==  __verifier_old_uint (balanceOf[msg.sender] ) - _value  && msg.sender  != _to ) || ( balanceOf[msg.sender] ==  __verifier_old_uint ( balanceOf[msg.sender]) && msg.sender  == _to ) &&  success ) || !success
    /// @notice  postcondition ( ( balanceOf[_to] ==  __verifier_old_uint ( balanceOf[_to] ) + _value  && msg.sender  != _to ) || ( balanceOf[_to] ==  __verifier_old_uint ( balanceOf[_to] ) && msg.sender  == _to ) &&  success ) || !success
    /// @notice  emits Transfer 
    function transfer(address _to, uint256 _value)
        public
        
        
        validAddress(_to)
        returns (bool success)
    {
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
      * @dev transfers tokens to a given address on behalf of another address
      * throws on any error rather then return a false flag to minimize user errors
      *
      * @param _from    source address
      * @param _to      target address
      * @param _value   transfer amount
      *
      * @return true if the transfer was successful, false if it wasn't
    */
    /// @notice  postcondition ( ( balanceOf[_from] ==  __verifier_old_uint (balanceOf[_from] ) - _value  &&  _from  != _to ) || ( balanceOf[_from] ==  __verifier_old_uint ( balanceOf[_from] ) &&  _from == _to ) &&  success ) || !success
    /// @notice  postcondition ( ( balanceOf[_to] ==  __verifier_old_uint ( balanceOf[_to] ) + _value  &&  _from  != _to ) || ( balanceOf[_to] ==  __verifier_old_uint ( balanceOf[_to] ) &&  _from  == _to ) &&  success ) || !success
    /// @notice  postcondition ( allowance[_from ][msg.sender] ==  __verifier_old_uint (allowance[_from ][msg.sender] ) - _value ) || ( allowance[_from ][msg.sender] ==  __verifier_old_uint (allowance[_from ][msg.sender] ) && !success) ||  _from  == msg.sender
    /// @notice  postcondition  allowance[_from ][msg.sender]  <= __verifier_old_uint (allowance[_from ][msg.sender] ) ||  _from  == msg.sender
    /// @notice  emits  Transfer
    function transferFrom(address _from, address _to, uint256 _value)
        public
        
        
        validAddress(_from)
        validAddress(_to)
        returns (bool success)
    {
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
      * @dev allows another account/contract to transfers tokens on behalf of the caller
      * throws on any error rather then return a false flag to minimize user errors
      *
      * @param _spender approved address
      * @param _value   allowance amount
      *
      * @return true if the approval was successful, false if it wasn't
    */
    /// @notice  postcondition (allowance[msg.sender ][ _spender] ==  _value  &&  success) || ( allowance[msg.sender ][ _spender] ==  __verifier_old_uint ( allowance[msg.sender ][ _spender] ) && !success )    
    /// @notice  emits  Approval
    function approve(address _spender, uint256 _value)
        public
        
        
        validAddress(_spender)
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
}
