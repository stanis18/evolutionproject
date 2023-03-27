pragma solidity >=0.5.0 <0.9.0;
import './ERC20TokenInterface.sol';
import './SafeMath.sol';

/*
    ERC20 Standard Token implementation
*/
/// @notice  invariant  _totalSupply  ==  __verifier_sum_uint(_balanceOf)
contract ERC20Token is ERC20TokenInterface, SafeMath {
    string public standard = 'Token 0.1';
    string public name = '';
    string public symbol = '';
    uint256 public _totalSupply = 0;
    mapping (address => uint256) public _balanceOf;
    mapping (address => mapping (address => uint256)) public _allowance;


    constructor (string memory _name, string memory _symbol) public {
        name = _name;
        symbol = _symbol;
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        assert(_address != address(0));
        _;
    }

    /*
        send coins
        note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors
    */
    /// @notice  postcondition ( ( _balanceOf[msg.sender] ==  __verifier_old_uint (_balanceOf[msg.sender] ) - _value  && msg.sender  != _to ) || ( _balanceOf[msg.sender] ==  __verifier_old_uint ( _balanceOf[msg.sender]) && msg.sender  == _to ) &&  success ) || !success
    /// @notice  postcondition ( ( _balanceOf[_to] ==  __verifier_old_uint ( _balanceOf[_to] ) + _value  && msg.sender  != _to ) || ( _balanceOf[_to] ==  __verifier_old_uint ( _balanceOf[_to] ) && msg.sender  == _to ) &&  success ) || !success
    /// @notice  emits Transfer 
    function transfer(address _to, uint256 _value)
        public
        validAddress(_to)
        returns (bool success)
    {
        _balanceOf[msg.sender] = safeSub(_balanceOf[msg.sender], _value);
        _balanceOf[_to] = safeAdd(_balanceOf[_to], _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /*
        an account/contract attempts to get the coins
        note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors
    */
    /// @notice  postcondition ( ( _balanceOf[_from] ==  __verifier_old_uint (_balanceOf[_from] ) - _value  &&  _from  != _to ) || ( _balanceOf[_from] ==  __verifier_old_uint ( _balanceOf[_from] ) &&  _from == _to ) &&  success ) || !success
    /// @notice  postcondition ( ( _balanceOf[_to] ==  __verifier_old_uint ( _balanceOf[_to] ) + _value  &&  _from  != _to ) || ( _balanceOf[_to] ==  __verifier_old_uint ( _balanceOf[_to] ) &&  _from  == _to ) &&  success ) || !success
    /// @notice  postcondition ( _allowance[_from ][msg.sender] ==  __verifier_old_uint (_allowance[_from ][msg.sender] ) - _value ) || ( _allowance[_from ][msg.sender] ==  __verifier_old_uint (_allowance[_from ][msg.sender] ) && !success) ||  _from  == msg.sender
    /// @notice  postcondition  _allowance[_from ][msg.sender]  <= __verifier_old_uint (_allowance[_from ][msg.sender] ) ||  _from  == msg.sender
    /// @notice  emits  Transfer
    function transferFrom(address _from, address _to, uint256 _value)
        public
        validAddress(_from)
        validAddress(_to)
        returns (bool success)
    {
        _allowance[_from][msg.sender] = safeSub(_allowance[_from][msg.sender], _value);
        _balanceOf[_from] = safeSub(_balanceOf[_from], _value);
        _balanceOf[_to] = safeAdd(_balanceOf[_to], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    /*
        allow another account/contract to spend some tokens on your behalf
        note that the function slightly deviates from the ERC20 standard and will throw on any error rather then return a boolean return value to minimize user errors

        also, to minimize the risk of the approve/transferFrom attack vector
        (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
        in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
    */
    /// @notice  postcondition (_allowance[msg.sender ][ _spender] ==  _value  &&  success) || ( _allowance[msg.sender ][ _spender] ==  __verifier_old_uint ( _allowance[msg.sender ][ _spender] ) && !success )    
    /// @notice  emits  Approval
    function approve(address _spender, uint256 _value)
        public
        validAddress(_spender)
        returns (bool success)
    {
        // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
        require(_value == 0 || _allowance[msg.sender][_spender] == 0);

        _allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
