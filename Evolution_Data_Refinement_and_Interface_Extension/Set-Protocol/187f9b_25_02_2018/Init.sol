pragma solidity >=0.5.0 <0.9.0;

contract Init {

    struct OldFacetStorage {
        uint256  totalSupply;
        mapping(address => uint256) balances;
        mapping (address => mapping (address => uint256))  allowed;
        address[] tokens;
        uint[] units;
    }


    struct NewFacetStorage {
        mapping (address => mapping (address => uint256))  allowed;
        address[] tokens;
        uint[] units;
        mapping(address => uint256) balances;
        uint256 totalSupply;
        string name;
        string symbol;
        uint8 decimals;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
