pragma solidity >=0.5.0 <0.9.0;

contract Init {

    struct OldFacetStorage {
        uint256  totalSupply;
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowed;
    }


    struct NewFacetStorage {
        uint256  totalSupply;
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowed;
        uint256 MAX_UINT256;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
