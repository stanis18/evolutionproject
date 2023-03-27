// https://github.com/makerdao/dss/blob/b1fdcfc9b2ab7961bf2ce7ab4008bfcec1c73a88/src/dai.sol
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/2f9ae975c8bdc5c7f7fa26204896f6c717f07164/contracts/token/ERC20
pragma solidity >=0.5.0 <0.9.0;

import './IUniswapV2ERC20.sol';

import "./SafeMath.sol";

/// @notice  invariant  totalSupply  ==  __verifier_sum_uint(balanceOf)
contract ERC20 is IUniswapV2ERC20 {
	using SafeMath for uint256;

	string public name_;
	string public symbol_;
	uint8 public decimals_;
	uint256 public totalSupply;
	mapping (address => uint256) public balanceOf;
	mapping (address => mapping (address => uint256)) public allowance;


	// EIP-712
    mapping (address => uint) public nonceFor;
	bytes32 public DOMAIN_SEPARATOR;
    bytes32 public APPROVE_TYPEHASH = keccak256(
		"Approve(address owner,address spender,uint256 value,uint256 nonce,uint256 expiration)"
	);

	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);

	/// @notice  emits  Transfer
	constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public {
		name_ = _name;
		symbol_ = _symbol;
		decimals_ = _decimals;
		mint(msg.sender, _totalSupply);
	}

    function initialize(uint256 chainId) internal {
		require(DOMAIN_SEPARATOR == bytes32(0), "ERC20: ALREADY_INITIALIZED");
		// DOMAIN_SEPARATOR = keccak256(abi.encode(
        //     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
        //     keccak256(bytes(name)),
        //     keccak256(bytes("1")),
        //     chainId,
        //     address(this)
        // ));
	}

	/// @notice  emits  Transfer
	function mint(address to, uint256 value) internal {
		totalSupply = totalSupply.add(value);
		balanceOf[to] = balanceOf[to].add(value);
		emit Transfer(address(0), to, value);
	}

	/// @notice  emits  Transfer
	function _transfer(address from, address to, uint256 value) private {
		balanceOf[from] = balanceOf[from].sub(value);
		balanceOf[to] = balanceOf[to].add(value);
		emit Transfer(from, to, value);
	}

	/// @notice  emits  Transfer
	function _burn(address from, uint256 value) private {
		balanceOf[from] = balanceOf[from].sub(value);
		totalSupply = totalSupply.sub(value);
		emit Transfer(from, address(0), value);
	}

	/// @notice  emits  Approval
	function _approve(address owner, address spender, uint256 value) private {
		allowance[owner][spender] = value;
		emit Approval(owner, spender, value);
	}

	/// @notice  postcondition ( ( balanceOf[msg.sender] ==  __verifier_old_uint (balanceOf[msg.sender] ) - value  && msg.sender  != to ) ||   ( balanceOf[msg.sender] ==  __verifier_old_uint ( balanceOf[msg.sender]) && msg.sender  == to ) &&  success )   || !success
    /// @notice  postcondition ( ( balanceOf[to] ==  __verifier_old_uint ( balanceOf[to] ) + value  && msg.sender  != to ) ||   ( balanceOf[to] ==  __verifier_old_uint ( balanceOf[to] ) && msg.sender  == to ) &&  success )   || !success
    /// @notice  emits  Transfer 
	function transfer(address to, uint256 value) external returns (bool success) {
		_transfer(msg.sender, to, value);
		return true;
	}

	/// @notice  postcondition ( ( balanceOf[from] ==  __verifier_old_uint (balanceOf[from] ) - value  &&  from  != to ) ||   ( balanceOf[from] ==  __verifier_old_uint ( balanceOf[from] ) &&  from== to ) &&  success )   || !success
    /// @notice  postcondition ( ( balanceOf[to] ==  __verifier_old_uint ( balanceOf[to] ) + value  &&  from  != to ) ||   ( balanceOf[to] ==  __verifier_old_uint ( balanceOf[to] ) &&  from  ==to ) &&  success )   || !success
    /// @notice  postcondition  (allowance[from ][msg.sender] ==  __verifier_old_uint (allowance[from ][msg.sender] ) - value && success)  || (allowance[from ][msg.sender] ==  __verifier_old_uint (allowance[from ][msg.sender] ) && !success) || from  == msg.sender
    /// @notice  postcondition  allowance[from ][msg.sender]  <= __verifier_old_uint (allowance[from ][msg.sender] ) ||  from  == msg.sender
    /// @notice  emits  Transfer
	function transferFrom(address from, address to, uint256 value) external returns (bool success) {
		if (allowance[from][msg.sender] != uint256(-1)) {
			allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
		}
		_transfer(from, to, value);
		return true;
	}

	/// @notice  emits  Transfer
	function burn(uint256 value) public {
		_burn(msg.sender, value);
	}

	/// @notice  emits  Transfer
	function burnFrom(address from, uint256 value) external {
		if (allowance[from][msg.sender] != uint256(-1)) {
			allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
		}
		_burn(from, value);
	}

	/// @notice  postcondition (allowance[msg.sender ][ spender] ==  value  &&  success) || ( allowance[msg.sender ][ spender] ==  __verifier_old_uint ( allowance[msg.sender ][ spender] ) && !success )    
    /// @notice  emits  Approval
	function approve(address spender, uint256 value) external returns (bool success) {
		_approve(msg.sender, spender, value);
		return true;
	}

	/// @notice  emits  Approval
	function approveMeta(
		address owner,
		address spender,
		uint256 value,
		uint256 nonce,
		uint256 expiration,
		uint8 v,
		bytes32 r,
		bytes32 s
	) external {
		require(DOMAIN_SEPARATOR != bytes32(0), "ERC20: UNINITIALIZED");
        require(nonce == nonceFor[owner]++, "ERC20: INVALID_NONCE");
		require(expiration > block.timestamp, "ERC20: EXPIRED_SIGNATURE");

        // bytes32 digest = keccak256(abi.encodePacked(
		// 	byte(0x19),
		// 	byte(0x01),
		// 	DOMAIN_SEPARATOR,
		// 	keccak256(abi.encode(
		// 		APPROVE_TYPEHASH, owner, spender, value, nonce, expiration
		// 	))
        // ));
        // require(owner == ecrecover(digest, v, r, s), "ERC20: INVALID_SIGNATURE"); // TODO add ECDSA checks? https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol

		_approve(msg.sender, spender, value);
	}
}
