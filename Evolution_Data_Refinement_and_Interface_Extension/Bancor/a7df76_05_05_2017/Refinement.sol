pragma solidity >=0.5.0 <0.9.0;

// Abstract function: 
// nw.standard-> od.standard
// nw.symbol_ -> od.symbol
// nw._totalSupply -> od._totalSupply 
// nw._balanceOf -> od._balanceOf
// nw._allowance -> od._allowance

contract Refinement {

    struct StateOld {
        string  standard;
        string  name;
        string  symbol;
        uint256  _totalSupply;
        mapping (address => uint256) _balanceOf;
        mapping (address => mapping (address => uint256)) _allowance;

    }
    struct StateNew {
        string  standard;
        string  name;
        string  symbol;
        uint256  _totalSupply;
        mapping (address => uint256) _balanceOf;
        mapping (address => mapping (address => uint256)) _allowance;
    }
    
    StateOld od;
    StateOld od_old;
    StateNew nw;
    StateNew nw_old;

    /// @notice precondition __verifier_sum_uint(od._balanceOf) == od._totalSupply // Abs func 
    /// @notice precondition __verifier_sum_uint(nw._balanceOf) == nw._totalSupply // Abs func 
    /// @notice precondition __verifier_sum_uint(od._balanceOf) == __verifier_sum_uint(nw._balanceOf) // Abs func 
    /// @notice postcondition nw._totalSupply == od._totalSupply
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
    
    /// @notice precondition forall (address addr1, address addr2) od._allowance[addr1][addr2] == nw._allowance[addr1][addr2] // Abs func 
    /// @notice precondition od._allowance[owner][spender] == _remaining_
    /// @notice postcondition nw._allowance[owner][spender] == _remaining_
    function allowance_post(address owner, address spender, uint256 _remaining_) public view  returns (uint256) {}

    /// @notice precondition true
    /// @notice postcondition true
    function balanceOf_pre(address _owner, uint256 _balance_) public view returns (uint256){}

    /// @notice precondition forall (address addr) od._balanceOf[addr] == nw._balanceOf[addr] // Abs func 
    /// @notice precondition od._balanceOf[_owner] == _balance_
    /// @notice postcondition nw._balanceOf[_owner] == _balance_
    function balanceOf_post(address _owner, uint256 _balance_) public view returns (uint256){}

    /// @notice precondition true
    /// @notice postcondition true
    function approve_pre(address spender, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition forall (address addr1, address addr2) od._allowance[addr1][addr2] == nw._allowance[addr1][addr2] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od_old._allowance[addr1][addr2] == nw_old._allowance[addr1][addr2] // Abs func 
    /// @notice precondition (od._allowance[msg.sender][spender] == value && _success_) || (od._allowance[msg.sender][spender] == od_old._allowance[msg.sender][spender] && !_success_)
    /// @notice postcondition (nw._allowance[msg.sender][spender] == value && _success_) || (nw._allowance[msg.sender][spender] == nw_old._allowance[msg.sender][spender] && !_success_)
    function approve_post(address spender, uint256 value, bool _success_) external returns (bool) {}
    
    /// @notice precondition true
    /// @notice postcondition true
    function transfer_pre(address to, uint256 value, bool _success_) external returns (bool) {}
    
    /// @notice precondition forall (address addr) od._balanceOf[addr] == nw._balanceOf[addr] // Abs func 
    /// @notice precondition forall (address addr) od_old._balanceOf[addr] == nw_old._balanceOf[addr] // Abs func 
    /// @notice precondition (( od._balanceOf[msg.sender] == od_old._balanceOf[msg.sender] - value  && msg.sender != to) || (od._balanceOf[msg.sender] == od_old._balanceOf[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (( od._balanceOf[to] == od_old._balanceOf[to] + value && msg.sender != to ) || ( od._balanceOf[to] == od_old._balanceOf[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw._balanceOf[to] == nw_old._balanceOf[to] + value && msg.sender != to ) || ( nw._balanceOf[to] == nw_old._balanceOf[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw._balanceOf[msg.sender] == nw_old._balanceOf[msg.sender] - value  && msg.sender != to) || (nw._balanceOf[msg.sender] == nw_old._balanceOf[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
	function transfer_post(address to, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition true
    /// @notice postcondition true
    function transferFrom_pre(address from, address to, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition forall (address addr) od._balanceOf[addr] == nw._balanceOf[addr] // Abs func 
    /// @notice precondition forall (address addr) od_old._balanceOf[addr] == nw_old._balanceOf[addr] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od._allowance[addr1][addr2] == nw._allowance[addr1][addr2] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od_old._allowance[addr1][addr2] == nw_old._allowance[addr1][addr2] // Abs func 
    /// @notice precondition (( od._balanceOf[msg.sender] == od_old._balanceOf[msg.sender] - value  && msg.sender != to) || (od._balanceOf[msg.sender] == od_old._balanceOf[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (( od._balanceOf[to] == od_old._balanceOf[to] + value && msg.sender != to ) || ( od._balanceOf[to] == od_old._balanceOf[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (od._allowance[from][msg.sender] == od_old._allowance[from][msg.sender] - value && _success_) || (od._allowance[from ][msg.sender] == od_old._allowance[from][msg.sender] && !_success_) || from == msg.sender
    /// @notice precondition  od._allowance[from][msg.sender] <= od_old._allowance[from][msg.sender] || from  == msg.sender
    /// @notice postcondition (( nw._balanceOf[to] == nw_old._balanceOf[to] + value && msg.sender != to) || (nw._balanceOf[to] == nw_old._balanceOf[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw._balanceOf[msg.sender] == nw_old._balanceOf[msg.sender] - value  && msg.sender != to) || (nw._balanceOf[msg.sender] == nw_old._balanceOf[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (nw._allowance[from][msg.sender] == nw_old._allowance[from][msg.sender] - value && _success_) || (nw._allowance[from ][msg.sender] == nw_old._allowance[from][msg.sender] && !_success_) || from == msg.sender
	/// @notice postcondition  nw._allowance[from][msg.sender] <= nw_old._allowance[from ][msg.sender] || from  == msg.sender
    function transferFrom_post(address from, address to, uint256 value, bool _success_) external returns (bool) {}

}

