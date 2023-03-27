pragma solidity >=0.5.0 <0.9.0;


import "./EnumerableSet.sol";
import "./EnumerableMap.sol";
import "./Counters.sol";


// Abstract function: 
// _ERC721_RECEIVED = nw._ERC721_RECEIVED -> od._ERC721_RECEIVED
// _tokenApprovals = nw._tokenApprovals -> od._tokenApprovals 
// _operatorApprovals = nw._operatorApprovals -> od._operatorApprovals 
// _INTERFACE_ID_ERC721 = nw._INTERFACE_ID_ERC721 -> od._INTERFACE_ID_ERC721 
// _tokenOwner =  nw._tokenOwners -> od._tokenOwner 
// _ownedTokensCount = nw._holderTokens -> od._ownedTokensCount
// nw._name -> od.{}
// nw._symbol -> od.{}
// nw._baseURI -> od.{}
// nw._INTERFACE_ID_ERC721_METADATA -> od.{}
// nw._INTERFACE_ID_ERC721_ENUMERABLE -> od.{}


contract Refinement {

    struct StateOld {
        bytes4 _ERC721_RECEIVED;
        mapping (uint256 => address)  _tokenOwner;
        mapping (uint256 => address)  _tokenApprovals;
        mapping (address => Counters.Counter)  _ownedTokensCount;
        mapping (address => mapping (address => bool))  _operatorApprovals;
        bytes4 _INTERFACE_ID_ERC721;
    }

    struct StateNew {
        mapping (address => EnumerableSet.UintSet)  _holderTokens;
        EnumerableMap.UintToAddressMap  _tokenOwners;
        mapping (uint256 => address)  _tokenApprovals;
        mapping (address => mapping (address => bool))  _operatorApprovals;
        mapping(uint256 => string)  _tokenURIs;
        string  _name;
        string  _symbol;
        string  _baseURI;
        bytes4  _ERC721_RECEIVED;
        bytes4  _INTERFACE_ID_ERC721;
        bytes4  _INTERFACE_ID_ERC721_METADATA;
        bytes4  _INTERFACE_ID_ERC721_ENUMERABLE;
    }

    StateOld od;
    StateNew nw;

    ///@notice precondition true
    ///@notice postcondition true
    function inv() public {}

    ///@notice precondition true
    ///@notice postcondition true
    function cons_pre() public {}

    ///@notice precondition true
    ///@notice postcondition true
    function cons_post() public {}

    ///@notice precondition true
    ///@notice postcondition true
    function balanceOf_pre(address owner) public view returns (uint256) {
    }
    
    /// @notice precondition  od._ownedTokensCount[owner]._value == nw._holderTokens[owner]._inner._values.length && od._ownedTokensCount[owner]._value  == _balance_
    /// @notice postcondition nw._holderTokens[owner]._inner._values.length == _balance_
    function balanceOf_post(address owner, uint256 _balance_) public view returns (uint256) {
    }

    /// @notice precondition true
    /// @notice postcondition true
    function ownerOf_pre(uint256 tokenId) public view returns (address) {
    }

    //Ajustar Conversões

    // /// @notice precondition od._tokenOwner[tokenId] == address(uint256 ( nw.map._entries[ nw._tokenOwners.map._indexes[ bytes32(tokenId) ] - 1]._value ) ) && od._tokenOwner[tokenId] == _owner_
    // /// @notice postcondition address(uint256 ( nw.map._entries[ nw._tokenOwners.map._indexes[ bytes32(tokenId) ] - 1]._value ) ) == _owner_
    // function ownerOf_post(uint256 tokenId, address _owner_) public view returns (address) {
    // }

    ///@notice precondition true
    ///@notice postcondition true
    function approve_pre(address to, uint256 tokenId) public {
    }

    /// @notice precondition od._tokenApprovals[tokenId] == nw._tokenApprovals[tokenId] && od._tokenApprovals[tokenId] == to
    /// @notice postcondition nw._tokenApprovals[tokenId] == to 
    function approve_post(address to, uint256 tokenId) public {
    }

    /// @notice precondition true
    /// @notice postcondition true
    function getApproved_pre(uint256 tokenId) public view returns (address) {
    }

    /// @notice precondition od._tokenApprovals[tokenId] == nw._tokenApprovals[tokenId] && od._tokenApprovals[tokenId] == _approved_
    /// @notice postcondition nw._tokenApprovals[tokenId] == _approved_ 
    function getApproved_post(uint256 tokenId, address _approved_) public view returns (address) {
    }

    /// @notice precondition true
    /// @notice postcondition true
    function setApprovalForAll_pre(address to, bool approved) public {
    }

    /// @notice precondition od._operatorApprovals[msg.sender][to] == nw._operatorApprovals[msg.sender][to] && od._operatorApprovals[msg.sender][to] == approved
    /// @notice postcondition nw._operatorApprovals[msg.sender][to] == approved
    function setApprovalForAll_post(address to, bool approved) public {
    }

    /// @notice precondition true
    /// @notice postcondition true
    function isApprovedForAll_pre(address owner, address operator) public view returns (bool) {
    }

    /// @notice precondition od._operatorApprovals[owner][operator] == nw._operatorApprovals[owner][operator] && od._operatorApprovals[owner][operator] == _approved_
    /// @notice postcondition nw._operatorApprovals[owner][operator] == _approved_
    function isApprovedForAll_post(address owner, address operator, bool _approved_) public view returns (bool) {
    }

    /// @notice precondition true
    /// @notice postcondition true
    function transferFrom_pre(address from, address to, uint256 tokenId) public {
    }

    //Ajustar Conversões
    
    // /// @notice precondition od._tokenOwner[tokenId] == address(uint256 ( nw.map._entries[ nw._tokenOwners.map._indexes[ bytes32(tokenId) ] - 1]._value ) ) && od._tokenOwner[tokenId] == to
    // /// @notice postcondition address(uint256 ( nw.map._entries[ nw._tokenOwners.map._indexes[ bytes32(tokenId) ] - 1]._value ) ) == to
    // function transferFrom_post(address from, address to, uint256 tokenId) public {
    // }

    /// @notice precondition true
    /// @notice postcondition true
    function safeTransferFrom_pre(address from, address to, uint256 tokenId) public {
    }

    //Ajustar Conversões

    // /// @notice precondition od._tokenOwner[tokenId] == address(uint256 ( nw.map._entries[ nw._tokenOwners.map._indexes[ bytes32(tokenId) ] - 1]._value ) ) && od._tokenOwner[tokenId] == to
    // /// @notice postcondition address(uint256 ( nw.map._entries[ nw._tokenOwners.map._indexes[ bytes32(tokenId) ] - 1]._value ) ) == to
    // function safeTransferFrom_post(address from, address to, uint256 tokenId) public {
    // }

    /// @notice precondition true
    /// @notice postcondition true
    function safeTransferFrom_pre(address from, address to, uint256 tokenId, bytes memory _data) public {
    }

    // /// @notice precondition od._tokenOwner[tokenId] == address(uint256 ( nw.map._entries[ nw._tokenOwners.map._indexes[ bytes32(tokenId) ] - 1]._value ) ) && od._tokenOwner[tokenId] == to
    // /// @notice postcondition address(uint256 ( nw.map._entries[ nw._tokenOwners.map._indexes[ bytes32(tokenId) ] - 1]._value ) ) == to
    // function safeTransferFrom_post(address from, address to, uint256 tokenId, bytes memory _data) public {
    // }

}

