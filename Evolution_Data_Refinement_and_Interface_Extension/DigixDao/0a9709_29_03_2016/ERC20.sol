pragma solidity >=0.5.0 <0.9.0;

import "./Interfaces.sol";

// / @notice  invariant  totalSupply  ==  __verifier_sum_uint(users[addr].balance)
contract Token is TokenInterface {

  modifier noEther() {
    if (msg.value > 0) revert();
    _;
  }

  modifier ifSales() {
    if (!seller[msg.sender]) revert(); 
    _; 
  }

  modifier ifOwner() {
    if (msg.sender != owner) revert();
    _;
  }

  modifier ifDao() {
    if (msg.sender != dao) revert();
    _;
  }

  constructor (address _config) public {
    config = _config;
    owner = msg.sender;
    // address _initseller = ConfigInterface(_config).getConfigAddress("sale1:address");
    // seller[_initseller] = true; 
    // locked = false;
  }
  
  /// @notice postcondition  users[_owner].balance == balance
  function balanceOf(address _owner) public returns (uint256 balance)  {
    return users[_owner].balance;
  }

  function badgesOf(address _owner) public returns (uint256 badge)  {
    return users[_owner].badges;
  }

  
  /// @notice  postcondition ( ( users[msg.sender].balance ==  __verifier_old_uint (users[msg.sender].balance ) - _value  && msg.sender  != _to ) ||   ( users[msg.sender].balance ==  __verifier_old_uint ( users[msg.sender].balance ) && msg.sender  == _to ) &&  success )  || !success
  /// @notice  postcondition ( ( users[_to].balance ==  __verifier_old_uint ( users[_to].balance ) + _value  && msg.sender  != _to ) ||   ( users[_to].balance ==  __verifier_old_uint ( users[_to].balance ) && msg.sender  == _to ) &&  success )   || !success
  /// @notice  emits  Transfer 
  function transfer(address _to, uint256 _value) public returns (bool success)  {
    if (users[msg.sender].balance >= _value && _value > 0) {
      users[msg.sender].balance -= _value;
      users[_to].balance += _value;
      emit Transfer(msg.sender, _to, _value);
      success = true;
    } else {
      success = false;
    }
    return success;
  }

   /// @notice  emits  Transfer 
  function sendBadge(address _to, uint256 _value) public returns (bool success)  {
    if (users[msg.sender].badges >= _value && _value > 0) {
      users[msg.sender].badges -= _value;
      users[_to].badges += _value;
      emit Transfer(msg.sender, _to, _value);
      success = true;
    } else {
      success = false;
    }
    return success;
  }

  /// @notice  postcondition ( ( users[_from].balance ==  __verifier_old_uint (users[_from].balance ) - _value  &&  _from  != _to ) || ( users[_from].balance ==  __verifier_old_uint ( users[_from].balance ) &&  _from == _to ) &&  success ) || !success
  /// @notice  postcondition ( ( users[_to].balance ==  __verifier_old_uint ( users[_to].balance ) + _value  &&  _from  != _to ) || ( users[_to].balance ==  __verifier_old_uint ( users[_to].balance ) &&  _from  == _to ) &&  success ) || !success
  /// @notice  postcondition ( allowed[_from ][msg.sender] ==  __verifier_old_uint (allowed[_from ][msg.sender] ) - _value ) || ( allowed[_from ][msg.sender] ==  __verifier_old_uint (allowed[_from ][msg.sender] ) && !success) ||  _from  == msg.sender
  /// @notice  postcondition  allowed[_from ][msg.sender]  <= __verifier_old_uint (allowed[_from ][msg.sender] ) ||  _from  == msg.sender
  /// @notice  emits  Transfer
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    if (users[_from].balance >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
      users[_to].balance += _value;
      users[_from].balance -= _value;
      allowed[_from][msg.sender] -= _value;
      emit Transfer(_from, _to, _value);
      success = true;
    } else {
      success = false;
    }
    return success;
  }

  /// @notice  postcondition (allowed[msg.sender ][ _spender] ==  _value  &&  success) || ( allowed[msg.sender ][ _spender] ==  __verifier_old_uint ( allowed[msg.sender ][ _spender] ) && !success )    
  /// @notice  emits  Approval
  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /// @notice postcondition allowed[_owner][_spender] == remaining
  function allowance(address _owner, address _spender) public  returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  function mint(address _owner, uint256 _amount) ifSales public returns (bool success) {
    totalSupply += _amount;
    users[_owner].balance += _amount;
    return true;
  }

  function mintBadge(address _owner, uint256 _amount) ifSales public returns (bool success) {
    totalBadges += _amount;
    users[_owner].badges += _amount;
    return true;
  }

  function registerDao(address _dao) ifOwner public returns (bool success) {
    if (locked == true) return false;
    dao = _dao;
    locked = true;
    return true;
  }

  function registerSeller(address _tokensales) ifDao public returns (bool success) {
    seller[_tokensales] = true;
  }

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
      event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event SendBadge(address indexed _from, address indexed _to, uint256 _amount);
}
