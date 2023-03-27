pragma solidity >=0.5.0 <0.9.0;

// Abstract function: 
//  nw.name -> od.name_
//  nw.symbol -> od.symbol_
//  nw.decimals -> od.decimals_
//  nw.totalSupply -> od.totalSupply 
//  nw.balanceOf -> od.balanceOf
//  nw.allowance -> od.allowance
//  nw.nonceFor -> od.nonceFor
//  nw.DOMAIN_SEPARATOR -> od.DOMAIN_SEPARATOR
//  nw.APPROVE_TYPEHASH -> od.APPROVE_TYPEHASH
//  nw.{} -> od.THRESHOLD

contract Refinement {

    struct StateOld {
        string name;
        string symbol;
        uint8  decimals;
        uint  totalSupply;
        mapping(address => uint)  balanceOf;
        mapping(address => mapping(address => uint)) allowance;
        bytes32 DOMAIN_SEPARATOR;
        bytes32 PERMIT_TYPEHASH;
        uint   THRESHOLD;
        mapping(address => uint)  nonces;
    }
    
    struct StateNew {
        string  name;
        string  symbol;
        uint8   decimals;
        uint   totalSupply;
        mapping(address => uint) balanceOf;
        mapping(address => mapping(address => uint)) allowance;
        bytes32  DOMAIN_SEPARATOR;
        bytes32  PERMIT_TYPEHASH;
        mapping(address => uint) nonces;
    }
    
    StateOld od;
    StateOld od_old;
    StateNew nw;
    StateNew nw_old;

    /// @notice precondition __verifier_sum_uint(od.balanceOf) == od.totalSupply // Abs func 
    /// @notice precondition __verifier_sum_uint(nw.balanceOf) == nw.totalSupply // Abs func 
    /// @notice precondition __verifier_sum_uint(od.balanceOf) == __verifier_sum_uint(nw.balanceOf) // Abs func 
    /// @notice postcondition nw.totalSupply == od.totalSupply
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
    
    /// @notice precondition forall (address addr1, address addr2) od.allowance[addr1][addr2] == nw.allowance[addr1][addr2] // Abs func 
    /// @notice precondition od.allowance[owner][spender] == _remaining_
    /// @notice postcondition nw.allowance[owner][spender] == _remaining_
    function allowance_post(address owner, address spender, uint256 _remaining_) public view  returns (uint256) {}

    /// @notice precondition true
    /// @notice postcondition true
    function balanceOf_pre(address _owner, uint256 _balance_) public view returns (uint256){}

    /// @notice precondition forall (address addr) od.balanceOf[addr] == nw.balanceOf[addr] // Abs func 
    /// @notice precondition od.balanceOf[_owner] == _balance_
    /// @notice postcondition nw.balanceOf[_owner] == _balance_
    function balanceOf_post(address _owner, uint256 _balance_) public view returns (uint256){}

    /// @notice precondition true
    /// @notice postcondition true
    function approve_pre(address spender, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition forall (address addr1, address addr2) od.allowance[addr1][addr2] == nw.allowance[addr1][addr2] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od_old.allowance[addr1][addr2] == nw_old.allowance[addr1][addr2] // Abs func 
    /// @notice precondition (od.allowance[msg.sender][spender] == value && _success_) || (od.allowance[msg.sender][spender] == od_old.allowance[msg.sender][spender] && !_success_)
    /// @notice postcondition (nw.allowance[msg.sender][spender] == value && _success_) || (nw.allowance[msg.sender][spender] == nw_old.allowance[msg.sender][spender] && !_success_)
    function approve_post(address spender, uint256 value, bool _success_) external returns (bool) {}
    
    /// @notice precondition true
    /// @notice postcondition true
    function transfer_pre(address to, uint256 value, bool _success_) external returns (bool) {}
    
    /// @notice precondition forall (address addr) od.balanceOf[addr] == nw.balanceOf[addr] // Abs func 
    /// @notice precondition forall (address addr) od_old.balanceOf[addr] == nw_old.balanceOf[addr] // Abs func 
    /// @notice precondition (( od.balanceOf[msg.sender] == od_old.balanceOf[msg.sender] - value  && msg.sender != to) || (od.balanceOf[msg.sender] == od_old.balanceOf[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (( od.balanceOf[to] == od_old.balanceOf[to] + value && msg.sender != to ) || ( od.balanceOf[to] == od_old.balanceOf[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balanceOf[to] == nw_old.balanceOf[to] + value && msg.sender != to ) || ( nw.balanceOf[to] == nw_old.balanceOf[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balanceOf[msg.sender] == nw_old.balanceOf[msg.sender] - value  && msg.sender != to) || (nw.balanceOf[msg.sender] == nw_old.balanceOf[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
	function transfer_post(address to, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition true
    /// @notice postcondition true
    function transferFrom_pre(address from, address to, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition forall (address addr) od.balanceOf[addr] == nw.balanceOf[addr] // Abs func 
    /// @notice precondition forall (address addr) od_old.balanceOf[addr] == nw_old.balanceOf[addr] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od.allowance[addr1][addr2] == nw.allowance[addr1][addr2] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od_old.allowance[addr1][addr2] == nw_old.allowance[addr1][addr2] // Abs func 
    /// @notice precondition (( od.balanceOf[msg.sender] == od_old.balanceOf[msg.sender] - value  && msg.sender != to) || (od.balanceOf[msg.sender] == od_old.balanceOf[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (( od.balanceOf[to] == od_old.balanceOf[to] + value && msg.sender != to ) || ( od.balanceOf[to] == od_old.balanceOf[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (od.allowance[from][msg.sender] == od_old.allowance[from][msg.sender] - value && _success_) || (od.allowance[from ][msg.sender] == od_old.allowance[from][msg.sender] && !_success_) || from == msg.sender
    /// @notice precondition  od.allowance[from][msg.sender] <= od_old.allowance[from][msg.sender] || from  == msg.sender
    /// @notice postcondition (( nw.balanceOf[to] == nw_old.balanceOf[to] + value && msg.sender != to) || (nw.balanceOf[to] == nw_old.balanceOf[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balanceOf[msg.sender] == nw_old.balanceOf[msg.sender] - value  && msg.sender != to) || (nw.balanceOf[msg.sender] == nw_old.balanceOf[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (nw.allowance[from][msg.sender] == nw_old.allowance[from][msg.sender] - value && _success_) || (nw.allowance[from ][msg.sender] == nw_old.allowance[from][msg.sender] && !_success_) || from == msg.sender
	/// @notice postcondition  nw.allowance[from][msg.sender] <= nw_old.allowance[from ][msg.sender] || from  == msg.sender
    function transferFrom_post(address from, address to, uint256 value, bool _success_) external returns (bool) {}

}

