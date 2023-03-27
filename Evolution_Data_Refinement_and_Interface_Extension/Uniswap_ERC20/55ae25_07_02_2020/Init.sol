
contract Init {

    struct OldFacetStorage {
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


    struct NewFacetStorage {
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

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
