contract Init {

    struct OldFacetStorage {
        bytes4  _ERC721_RECEIVED;
        mapping (uint256 => address) _tokenOwner;
        mapping (uint256 => address) _tokenApprovals;
        mapping (address => uint256) _ownedTokensCount;
        mapping (address => mapping (address => bool)) _operatorApprovals;
        bytes4  _INTERFACE_ID_ERC721;
    }


    struct NewFacetStorage {
        bytes4  _ERC721_RECEIVED;
        mapping (uint256 => address) _tokenOwner;
        mapping (uint256 => address) _tokenApprovals;
        mapping (address => uint256) _ownedTokensCount;
        mapping (address => mapping (address => bool)) _operatorApprovals;
        bytes4 _INTERFACE_ID_ERC721;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
