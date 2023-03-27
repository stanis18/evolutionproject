pragma solidity >=0.5.0 <0.9.0;

// Abstract function: 
// nw.totalSupply_ -> od.totalSupply
// nw.balances -> od.balances
// nw.allowed -> od.allowed
// nw.tokens -> od.tokens
// nw.units -> od.units
// nw.name -> od.{}
// nw.symbol -> od.{}
// nw.decimals -> od.{}

contract Refinement {

    struct PartialRedeemStatus { uint unredeemedBalance; bool isRedeemed; }

    struct StateOld {
        mapping (address => mapping (address => uint256))  allowed;
        address[] tokens;
        uint[] units;
        mapping(address => uint256) balances;
        uint256 totalSupply;
        string name;
        string symbol;
        uint8 decimals;
        Component[] components;
        mapping(address => bool) isComponent;
        mapping(address => mapping(address => UnredeemedComponent)) unredeemedComponents;
        string  COMPONENTS_INPUT_MISMATCH;
        string  COMPONENTS_MISSING;
        string  UNITS_MISSING;
        string  ZERO_QUANTITY;
        string  INVALID_SENDER;
        address factory;
    }


    struct Component { address address_; uint unit_; }
    struct UnredeemedComponent { uint balance; bool isRedeemed; }

    struct StateNew {
        mapping (address => mapping (address => uint256))  allowed;
        address[] tokens;
        uint[] units;
        mapping(address => uint256) balances;
        uint256 totalSupply;
        string name;
        string symbol;
        uint8 decimals;
        Component[] components;
        mapping(address => bool) isComponent;
        mapping(address => mapping(address => UnredeemedComponent)) unredeemedComponents;
        address factory;
    }
    
    StateOld od;
    StateOld od_old;
    StateNew nw;
    StateNew nw_old;

    /// @notice precondition __verifier_sum_uint(od.balances) == od.totalSupply // Abs func 
    /// @notice precondition __verifier_sum_uint(nw.balances) == nw.totalSupply // Abs func 
    /// @notice precondition __verifier_sum_uint(od.balances) == __verifier_sum_uint(nw.balances) // Abs func 
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
    
    /// @notice precondition forall (address addr1, address addr2) od.allowed[addr1][addr2] == nw.allowed[addr1][addr2] // Abs func 
    /// @notice precondition od.allowed[owner][spender] == _remaining_
    /// @notice postcondition nw.allowed[owner][spender] == _remaining_
    function allowance_post(address owner, address spender, uint256 _remaining_) public view  returns (uint256) {}

    /// @notice precondition true
    /// @notice postcondition true
    function balanceOf_pre(address _owner, uint256 _balance_) public view returns (uint256){}

    /// @notice precondition forall (address addr) od.balances[addr] == nw.balances[addr] // Abs func 
    /// @notice precondition od.balances[_owner] == _balance_
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
    
    /// @notice precondition forall (address addr) od.balances[addr] == nw.balances[addr] // Abs func 
    /// @notice precondition forall (address addr) od_old.balances[addr] == nw_old.balances[addr] // Abs func 
    /// @notice precondition (( od.balances[msg.sender] == od_old.balances[msg.sender] - value  && msg.sender != to) || (od.balances[msg.sender] == od_old.balances[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (( od.balances[to] == od_old.balances[to] + value && msg.sender != to ) || ( od.balances[to] == od_old.balances[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balances[to] == nw_old.balances[to] + value && msg.sender != to ) || ( nw.balances[to] == nw_old.balances[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balances[msg.sender] == nw_old.balances[msg.sender] - value  && msg.sender != to) || (nw.balances[msg.sender] == nw_old.balances[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
	function transfer_post(address to, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition true
    /// @notice postcondition true
    function transferFrom_pre(address from, address to, uint256 value, bool _success_) external returns (bool) {}

    /// @notice precondition forall (address addr) od.balances[addr] == nw.balances[addr] // Abs func 
    /// @notice precondition forall (address addr) od_old.balances[addr] == nw_old.balances[addr] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od.allowed[addr1][addr2] == nw.allowed[addr1][addr2] // Abs func 
    /// @notice precondition forall (address addr1, address addr2) od_old.allowed[addr1][addr2] == nw_old.allowed[addr1][addr2] // Abs func 
    /// @notice precondition (( od.balances[msg.sender] == od_old.balances[msg.sender] - value  && msg.sender != to) || (od.balances[msg.sender] == od_old.balances[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (( od.balances[to] == od_old.balances[to] + value && msg.sender != to ) || ( od.balances[to] == od_old.balances[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice precondition (od.allowed[from][msg.sender] == od_old.allowed[from][msg.sender] - value && _success_) || (od.allowed[from ][msg.sender] == od_old.allowed[from][msg.sender] && !_success_) || from == msg.sender
    /// @notice precondition  od.allowed[from][msg.sender] <= od_old.allowed[from][msg.sender] || from  == msg.sender
    /// @notice postcondition (( nw.balances[to] == nw_old.balances[to] + value && msg.sender != to) || (nw.balances[to] == nw_old.balances[to] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (( nw.balances[msg.sender] == nw_old.balances[msg.sender] - value  && msg.sender != to) || (nw.balances[msg.sender] == nw_old.balances[msg.sender] && msg.sender == to ) && _success_ ) || !_success_
    /// @notice postcondition (nw.allowed[from][msg.sender] == nw_old.allowed[from][msg.sender] - value && _success_) || (nw.allowed[from ][msg.sender] == nw_old.allowed[from][msg.sender] && !_success_) || from == msg.sender
	/// @notice postcondition  nw.allowed[from][msg.sender] <= nw_old.allowed[from ][msg.sender] || from  == msg.sender
    function transferFrom_post(address from, address to, uint256 value, bool _success_) external returns (bool) {}

}

