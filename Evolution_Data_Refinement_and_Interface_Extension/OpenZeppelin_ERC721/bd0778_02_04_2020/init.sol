pragma solidity >=0.5.0 <0.9.0;

import "./EnumerableSet.sol";
import "./EnumerableMap.sol";
import "./Counters.sol";

contract Init {

    struct OldFacetStorage {
        bytes4 _ERC721_RECEIVED;
        mapping (uint256 => address)  _tokenOwner;
        mapping (uint256 => address)  _tokenApprovals;
        mapping (address => Counters.Counter)  _ownedTokensCount;
        mapping (address => mapping (address => bool))  _operatorApprovals;
        bytes4 _INTERFACE_ID_ERC721;
    }


    struct NewFacetStorage {
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

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
