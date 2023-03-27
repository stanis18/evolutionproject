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
        string  name;
        string  symbol;
        uint8   decimals;
        uint256 totalSupply;
        mapping (address => uint256)  balanceOf;
        mapping (address => mapping (address => uint256))  allowance;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
        new_storage.name = old_storage.name;
        new_storage.symbol = old_storage.symbol;
        new_storage.totalSupply = old_storage._totalSupply;
    }

}
