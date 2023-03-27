import "./Counters.sol";
import "./Address.sol";
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
        string  _name;
        string  _symbol;
        mapping (uint256 => address)  _owners;
        mapping (uint256 => address)  _tokenApprovals;
        mapping (address => uint256)  _balances;
        mapping (address => mapping (address => bool))  _operatorApprovals;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
