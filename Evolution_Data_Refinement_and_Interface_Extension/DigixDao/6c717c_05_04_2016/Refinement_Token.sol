pragma solidity >=0.5.0 <0.9.0;

// Abstract function: 
// nw.balances -> od.balances
// nw.allowed -> od.allowed
// nw.seller -> od.seller
// nw.config -> od.config 
// nw.owner -> od.owner
// nw.totalSupply -> od.totalSupply
// nw.totalBadges -> od.totalBadges
// nw.dao -> od.{}
// nw.locked -> od.{}

contract Refinement {

    struct User {
        bool locked;
        uint256 balance;
        uint256 badges;
        mapping (address => uint256) allowed;
  }

    struct StateOld {
        mapping (address => User) users;
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowed;
        mapping (address => bool) seller;
        address config;
        address owner;
        uint256  totalSupply;
        uint256  totalBadges;
        address dao;
        bool locked;
    }

    struct StateNew {

        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowed;
        mapping (address => bool) seller;
        address config;
        address owner;
        address dao;
        bool locked;
        uint256  totalSupply;
    }
    
    StateOld od;
    StateOld od_old;
    StateNew nw;
    StateNew nw_old;

    // / @notice precondition __verifier_sum_uint(od.balances) == od.totalSupply // Abs func 
    // / @notice precondition __verifier_sum_uint(nw.balances) == nw.totalSupply // Abs func 
    // / @notice precondition __verifier_sum_uint(od.balances) == __verifier_sum_uint(nw.balances) // Abs func 
    // / @notice postcondition nw.totalSupply == od.totalSupply
    function inv() public {}

    /// @notice precondition true
    /// @notice postcondition true
    function cons_pre() public {}

    /// @notice precondition true
    /// @notice postcondition true
    function cons_post() public {}

    /// @notice precondition true
    /// @notice postcondition true
    function allowance_pre(address owner, address spender, uint256 _remaining_) public view  returns (uint256) {}
    
    /// @notice precondition forall (address addr1, address addr2) od.allowed[addr1][addr2] == nw.allowed[addr1][addr2] // Abs func 
    /// @notice precondition od.allowed[owner][spender] == _remaining_
    /// @notice postcondition nw.allowed[owner][spender] == _remaining_
    function allowance_post(address owner, address spender, uint256 _remaining_) public view  returns (uint256) {}

    /// @notice precondition true
    /// @notice postcondition true
    function balanceOf_pre(address _owner, uint256 _balance_) public view returns (uint256){}

    /// @notice precondition forall (address addr) od.users[addr].balance == nw.balances[addr] // Abs func 
    /// @notice precondition od.users[_owner].balance == _balance_
    /// @notice postcondition nw.balances[_owner] == _balance_
    function balanceOf_post(address _owner, uint256 _balance_) public view returns (uint256){}

    /// @notice precondition true
    /// @notice postcondition true
    function approve_pre(address spender, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition forall (address addr1, address addr2) od.allowed[addr1][addr2] == nw.allowed[addr1][addr2] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od_old.allowed[addr1][addr2] == nw_old.allowed[addr1][addr2] // Abs func 
    /// @notice precondition (od.allowed[msg.sender][spender] == value && _success_) || (od.allowed[msg.sender][spender] == od_old.allowed[msg.sender][spender] && !_success_)
    /// @notice postcondition (nw.allowed[msg.sender][spender] == value && _success_) || (nw.allowed[msg.sender][spender] == nw_old.allowed[msg.sender][spender] && !_success_)
    function approve_post(address spender, uint256 value, bool _success_) external returns (bool) {}
    
    /// @notice precondition true
    /// @notice postcondition true
    function transfer_pre(address to, uint256 value, bool _success_) external returns (bool) {}
    
    /// @notice precondition forall (address addr) od.users[addr].balance == nw.balances[addr] // Abs func 
    /// @notice precondition forall (address addr) od_old.users[addr].balance == nw_old.balances[addr] // Abs func 
    /// @notice precondition (( od.users[msg.sender].balance == od_old.users[msg.sender].balance - value  && msg.sender != to) || (od.users[msg.sender].balance == od_old.users[msg.sender].balance && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (( od.users[to].balance == od_old.users[to].balance + value && msg.sender != to ) || ( od.users[to].balance == od_old.users[to].balance && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balances[to] == nw_old.balances[to] + value && msg.sender != to ) || ( nw.balances[to] == nw_old.balances[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balances[msg.sender] == nw_old.balances[msg.sender] - value  && msg.sender != to) || (nw.balances[msg.sender] == nw_old.balances[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
	function transfer_post(address to, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition true
    /// @notice postcondition true
    function transferFrom_pre(address from, address to, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition forall (address addr) od.users[addr].balance == nw.balances[addr] // Abs func 
    /// @notice precondition forall (address addr) od_old.users[addr].balance == nw_old.balances[addr] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od.allowed[addr1][addr2] == nw.allowed[addr1][addr2] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od_old.allowed[addr1][addr2] == nw_old.allowed[addr1][addr2] // Abs func 
    /// @notice precondition (( od.users[msg.sender].balance == od_old.users[msg.sender].balance - value  && msg.sender != to) || (od.users[msg.sender].balance == od_old.users[msg.sender].balance && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (( od.users[to].balance == od_old.users[to].balance + value && msg.sender != to ) || ( od.users[to].balance == od_old.users[to].balance && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (od.allowed[from][msg.sender] == od_old.allowed[from][msg.sender] - value && _success_) || (od.allowed[from ][msg.sender] == od_old.allowed[from][msg.sender] && !_success_) || from == msg.sender
    /// @notice precondition  od.allowed[from][msg.sender] <= od_old.allowed[from][msg.sender] || from  == msg.sender
    /// @notice postcondition (( nw.balances[to] == nw_old.balances[to] + value && msg.sender != to) || (nw.balances[to] == nw_old.balances[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balances[msg.sender] == nw_old.balances[msg.sender] - value  && msg.sender != to) || (nw.balances[msg.sender] == nw_old.balances[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (nw.allowed[from][msg.sender] == nw_old.allowed[from][msg.sender] - value && _success_) || (nw.allowed[from ][msg.sender] == nw_old.allowed[from][msg.sender] && !_success_) || from == msg.sender
	/// @notice postcondition  nw.allowed[from][msg.sender] <= nw_old.allowed[from ][msg.sender] || from  == msg.sender
    function transferFrom_post(address from, address to, uint256 value, bool _success_) external returns (bool) {}

}

