
contract Init {

    struct OldFacetStorage {
            string  name_;
        string  symbol_;
        uint8  decimals_;
        uint256  totalSupply;
        mapping (address => uint256)  balanceOf;
        mapping (address => mapping (address => uint256))  allowance;
        mapping (address => uint)  nonceFor;
        bytes32  DOMAIN_SEPARATOR;
        bytes32  APPROVE_TYPEHASH;
    }


    struct NewFacetStorage {
        string  name_;
        string  symbol_;
        uint8  decimals_;
        uint256  totalSupply;
        mapping (address => uint256)  balanceOf;
        mapping (address => mapping (address => uint256))  allowance;
        mapping (address => uint)  nonceFor;
        bytes32  DOMAIN_SEPARATOR;
        bytes32  APPROVE_TYPEHASH;
        
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
