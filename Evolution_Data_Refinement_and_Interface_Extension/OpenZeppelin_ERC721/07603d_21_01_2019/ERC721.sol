pragma solidity >=0.5.0 <0.9.0;

import "./IERC721.sol";
import "./IERC721Receiver.sol";
import "./SafeMath.sol";
import "./Address.sol";
import "./Counters.sol";
import "./ERC165.sol";


// forall _ownedTokensCount[addr] == _ownedTokensCount[addr]._value 
contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => Counters.Counter) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    
     /// @notice postcondition _ownedTokensCount[owner]._value  == balance
    function balanceOf(address owner) public view returns (uint256 balance) {
        require(owner != address(0));
        return _ownedTokensCount[owner].current();
    }

     /// @notice postcondition _tokenOwner[tokenId] == _owner
     /// @notice postcondition  _owner !=  address(0)
    function ownerOf(uint256 tokenId) public view returns (address _owner) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0));
        return owner;
    }

    
    /// @notice postcondition _tokenApprovals[tokenId] == to 
    /// @notice emits Approval
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /// @notice postcondition _tokenOwner[tokenId] != address(0)
    /// @notice postcondition _tokenApprovals[tokenId] == approved
    function getApproved(uint256 tokenId) public view returns (address approved) {
        require(_exists(tokenId));
        return _tokenApprovals[tokenId];
    }

    /// @notice postcondition _operatorApprovals[msg.sender][to] == approved
    /// @notice emits ApprovalForAll
    function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender);
        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }

   /// @notice postcondition _operatorApprovals[owner][operator] == approved
    function isApprovedForAll(address owner, address operator) public view returns (bool approved) {
        return _operatorApprovals[owner][operator];
    }

    
    /// @notice  postcondition ( ( _ownedTokensCount[from]._value ==  __verifier_old_uint (_ownedTokensCount[from]._value ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _ownedTokensCount[to]._value ==  __verifier_old_uint ( _ownedTokensCount[to]._value ) + 1  &&  from  != to ) || ( from  == to ) )
    /// @notice  postcondition  _tokenOwner[tokenId] == to
    /// @notice  emits Transfer
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId));

        _transferFrom(from, to, tokenId);
    }

   
    /// @notice  postcondition ( ( _ownedTokensCount[from]._value ==  __verifier_old_uint (_ownedTokensCount[from]._value ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _ownedTokensCount[to]._value ==  __verifier_old_uint ( _ownedTokensCount[to]._value ) + 1  &&  from  != to ) || ( from  == to ) )
    /// @notice  postcondition  _tokenOwner[tokenId] == to
    /// @notice  emits Transfer
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    /// @notice  postcondition ( ( _ownedTokensCount[from]._value ==  __verifier_old_uint (_ownedTokensCount[from]._value ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _ownedTokensCount[to]._value ==  __verifier_old_uint ( _ownedTokensCount[to]._value ) + 1  &&  from  != to ) || ( from  == to ) )
    /// @notice  postcondition  _tokenOwner[tokenId] == to
    /// @notice  emits Transfer
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data));
    }

   
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

   
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

     /// @notice  emits Transfer
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0));
        require(!_exists(tokenId));

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();

        emit Transfer(address(0), to, tokenId);
    }

     /// @notice  emits Transfer
    function _burn(address owner, uint256 tokenId) internal {
        require(ownerOf(tokenId) == owner);

        _clearApproval(tokenId);

        _ownedTokensCount[owner].decrement();
        _tokenOwner[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }

     /// @notice  emits Transfer
    function _burn(uint256 tokenId) internal {
        _burn(ownerOf(tokenId), tokenId);
    }

    /// @notice  emits Transfer
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from);
        require(to != address(0));

        _clearApproval(tokenId);

        _ownedTokensCount[from].decrement();
        _ownedTokensCount[to].increment();

        _tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        internal returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    
    function _clearApproval(uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}
