pragma solidity >=0.5.0 <0.9.0;

import "./Interfaces.sol";

contract Badge  {
  mapping (address => uint256) balances;
  mapping (address => mapping (address => uint256)) allowed;
  mapping (address => bool) seller;

  address owner;
  bool locked;

  /// @return total amount of tokens
  uint256 public totalSupply;

  modifier ifOwner() {
    if (msg.sender != owner) revert();
    _;
  }

  event Transfer(address indexed _from, address indexed _to, uint256 indexed _value);
  event Mint(address indexed _recipient, uint256 indexed _amount);
  event Approval(address indexed _owner, address indexed _spender, uint256 indexed _value);

  constructor (address _config) public {
    owner = msg.sender;
  }

  function balanceOf(address _owner) public returns (uint256 balance) {
    return balances[_owner];
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
    if (balances[msg.sender] >= _value && _value > 0) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      emit Transfer(msg.sender, _to, _value);
      success = true;
    } else {
      success = false;
    }
    return success;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
      balances[_to] += _value;
      balances[_from] -= _value;
      allowed[_from][msg.sender] -= _value;
      emit Transfer(_from, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    success = true;
    return success;
  }

  function allowance(address _owner, address _spender) public returns (uint256 remaining) {
    remaining = allowed[_owner][_spender];
    return remaining;
  }

  function mint(address _owner, uint256 _amount) public ifOwner returns (bool success) {
    totalSupply += _amount;
    balances[_owner] += _amount;
    emit Mint(_owner, _amount);
    return true;
  }

}

contract Token is TokenInterface {

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

  constructor(address _config) public {
    // config = _config;
    // owner = msg.sender;
    // address _initseller = ConfigInterface(_config).getConfigAddress("sale1:address");
    // seller[_initseller] = true; 
    // badgeLedger = new Badge(_config);
    // locked = false;
  }

  function balanceOf(address _owner) public returns (uint256 balance) {
    return balances[_owner];
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
    if (balances[msg.sender] >= _value && _value > 0) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      emit Transfer(msg.sender, _to, _value);
      success = true;
    } else {
      success = false;
    }
    return success;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
      balances[_to] += _value;
      balances[_from] -= _value;
      allowed[_from][msg.sender] -= _value;
      emit Transfer(_from, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  function approve(address _spender, uint256 _value) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    success = true;
    return success;
  }

  function allowance(address _owner, address _spender) public returns (uint256 remaining) {
    remaining = allowed[_owner][_spender];
    return remaining;
  }
  function mint(address _owner, uint256 _amount) public ifSales returns (bool success) {
    totalSupply += _amount;
    balances[_owner] += _amount;
    return true;
  }

  function mintBadge(address _owner, uint256 _amount) public ifSales returns (bool success) {
    if (!Badge(badgeLedger).mint(_owner, _amount)) return false;
    return true;
  }

  function registerDao(address _dao) public ifOwner returns (bool success) {
    if (locked == true) return false;
    dao = _dao;
    locked = true;
    return true;
  }

  function registerSeller(address _tokensales) public ifDao returns (bool success) {
    seller[_tokensales] = true;
    return true;
  }

  function unregisterSeller(address _tokensales) public ifDao returns (bool success) {
    seller[_tokensales] = false;
    return true;
  }
}
