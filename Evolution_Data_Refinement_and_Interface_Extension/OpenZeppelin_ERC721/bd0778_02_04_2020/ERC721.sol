pragma solidity >=0.5.0 <0.9.0;

import "./Context.sol";
import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./IERC721Enumerable.sol";
import "./IERC721Receiver.sol";
import "./ERC165.sol";
import "./SafeMath.sol";
import "./Address.sol";
import "./EnumerableSet.sol";
import "./EnumerableMap.sol";
import "./Counters.sol";

// / @notice invariant forall (address addr)  previous_ownedTokensCount[addr]  == _holderTokens[addr]._inner._values.length
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
    using SafeMath for uint256;
    using Address for address;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from holder address to their (enumerable) set of owned tokens <-->
    mapping (address => EnumerableSet.UintSet) private _holderTokens;

    // Enumerable mapping from token ids to their owners
    EnumerableMap.UintToAddressMap private _tokenOwners;


    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // Base URI
    string private _baseURI;

    
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;


    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

        /// @notice postcondition _holderTokens[owner]._inner._values.length  == balance
    function balanceOf(address owner) public view  returns (uint256 balance) {
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _holderTokens[owner].length();
    }

    // / @notice postcondition _tokenOwners[tokenId]._inner == _owner
    // / @notice postcondition  _owner !=  address(0)
    function ownerOf(uint256 tokenId) public view  returns (address _owner) {
        return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
    }

    
    function name() public view  returns (string memory) {
        return _name;
    }

  
    function symbol() public view  returns (string memory) {
        return _symbol;
    }

   
    function tokenURI(uint256 tokenId) public view  returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];

        // Even if there is a base URI, it is only appended to non-empty token-specific URIs
        if (bytes(_tokenURI).length == 0) {
            return "";
        } else {
            // abi.encodePacked is being used to concatenate strings
            // return string(abi.encodePacked(_baseURI, _tokenURI));
        }
    }

  
    function baseURI() public view returns (string memory) {
        return _baseURI;
    }

    
    function tokenOfOwnerByIndex(address owner, uint256 index) public view  returns (uint256) {
        return _holderTokens[owner].at(index);
    }

  
    function totalSupply() public view  returns (uint256) {
        // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
        return _tokenOwners.length();
    }

 
    function tokenByIndex(uint256 index) public view  returns (uint256) {
        (uint256 tokenId, ) = _tokenOwners.at(index);
        return tokenId;
    }

    /// @notice postcondition _tokenApprovals[tokenId] == to 
    /// @notice emits Approval
    function approve(address to, uint256 tokenId) public   {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    // / @notice postcondition _tokenOwner[tokenId] != address(0)
    /// @notice postcondition _tokenApprovals[tokenId] == approved
    function getApproved(uint256 tokenId) public view  returns (address approved) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /// @notice postcondition _operatorApprovals[msg.sender][operator] == approved
    /// @notice emits ApprovalForAll
    function setApprovalForAll(address operator, bool approved) public   {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /// @notice postcondition _operatorApprovals[owner][operator] == approved
    function isApprovedForAll(address owner, address operator) public view  returns (bool approved) {
        return _operatorApprovals[owner][operator];
    }


    /// @notice  postcondition ( ( _holderTokens[from]._inner._values.length ==  __verifier_old_uint (_holderTokens[from]._inner._values.length ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _holderTokens[to]._inner._values.length ==  __verifier_old_uint ( _holderTokens[to]._inner._values.length ) + 1  &&  from  != to ) || ( from  == to ) )
    // / @notice  postcondition  _tokenOwner[bytes32(tokenId)] == to
    /// @notice  emits Transfer
     /// @notice  emits Approval
    function transferFrom(address from, address to, uint256 tokenId) public   {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /// @notice  postcondition ( ( _holderTokens[from]._inner._values.length ==  __verifier_old_uint (_holderTokens[from]._inner._values.length ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _holderTokens[to]._inner._values.length ==  __verifier_old_uint ( _holderTokens[to]._inner._values.length ) + 1  &&  from  != to ) || ( from  == to ) )
    // / @notice  postcondition  _tokenOwner[tokenId] == to
    /// @notice  emits Approval
    /// @notice  emits Transfer
    function safeTransferFrom(address from, address to, uint256 tokenId) public   {
        safeTransferFrom(from, to, tokenId, "");
    }

    /// @notice  postcondition ( ( _holderTokens[from]._inner._values.length ==  __verifier_old_uint (_holderTokens[from]._inner._values.length ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _holderTokens[to]._inner._values.length ==  __verifier_old_uint ( _holderTokens[to]._inner._values.length ) + 1  &&  from  != to ) || ( from  == to ) )
    // / @notice  postcondition  _tokenOwner[tokenId] == to
    /// @notice  emits Approval
    /// @notice  emits Transfer
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public   {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /// @notice  emits Approval
    /// @notice  emits Transfer
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal  {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

   
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _tokenOwners.contains(tokenId);
    }

   
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /// @notice  emits Transfer
    function _safeMint(address to, uint256 tokenId) internal  {
        _safeMint(to, tokenId, "");
    }

     /// @notice  emits Transfer
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal  {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /// @notice  emits Transfer
    function _mint(address to, uint256 tokenId) internal  {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _holderTokens[to].add(tokenId);

        _tokenOwners.set(tokenId, to);

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice  emits Transfer
     /// @notice  emits Approval
    function _burn(uint256 tokenId) internal  {
        address owner = ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        // Clear metadata (if any)
        // if (bytes(_tokenURIs[tokenId]).length != 0) {
        //     delete _tokenURIs[tokenId];
        // }

        _holderTokens[owner].remove(tokenId);

        _tokenOwners.remove(tokenId);

        emit Transfer(owner, address(0), tokenId);
    }

    /// @notice  emits Approval
    /// @notice  emits Transfer
    function _transfer(address from, address to, uint256 tokenId) internal  {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _holderTokens[from].remove(tokenId);
        _holderTokens[to].add(tokenId);

        _tokenOwners.set(tokenId, to);

        emit Transfer(from, to, tokenId);
    }


    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal  {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

   
    function _setBaseURI(string memory baseURI_) internal  {
        _baseURI = baseURI_;
    }

 
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        private returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }
        // solhint- disable-next-line avoid-low-level-calls
        // (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
        //     IERC721Receiver(to).onERC721Received.selector,
        //     _msgSender(),
        //     from,
        //     tokenId,
        //     _data
        // ));
        // if (!success) {
        //     if (returndata.length > 0) {
        //         // s olhint- disable-next-line no-inline-assembly
        //         assembly {
        //             let returndata_size := mload(returndata)
        //             revert(add(32, returndata), returndata_size)
        //         }
        //     } else {
        //         revert("ERC721: transfer to non ERC721Receiver implementer");
        //     }
        // } else {
        //     bytes4 retval = abi.decode(returndata, (bytes4));
        //     return (retval == _ERC721_RECEIVED);
        // }
    }

    /// @notice  emits Approval
    function _approve(address to, uint256 tokenId) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

  
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal  { }

      event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    
}
