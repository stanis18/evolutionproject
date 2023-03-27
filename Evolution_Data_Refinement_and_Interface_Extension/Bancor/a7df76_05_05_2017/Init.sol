pragma solidity >=0.5.0 <0.9.0;

contract Init {

    struct OldFacetStorage {
        string  standard;
        string  name;
        string  symbol;
        uint256  _totalSupply;
        mapping (address => uint256) _balanceOf;
        mapping (address => mapping (address => uint256)) _allowance;

    }

    struct NewFacetStorage {
        string  standard;
        string  name;
        string  symbol;
        uint256  _totalSupply;
        mapping (address => uint256) _balanceOf;
        mapping (address => mapping (address => uint256)) _allowance;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
