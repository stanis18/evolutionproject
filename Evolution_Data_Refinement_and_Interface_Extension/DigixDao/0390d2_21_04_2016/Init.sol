pragma solidity >=0.5.0 <0.9.0;

contract Init {

     struct User {
        bool locked;
        uint256 balance;
        uint256 badges;
        mapping (address => uint256) allowed;
  }

    struct OldFacetStorage {
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowed;
        mapping (address => bool) seller;
        address config;
        address owner;
        address dao;
        bool locked;
        uint256  totalSupply;
    }


    struct NewFacetStorage {
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowed;
        mapping (address => bool) seller;
        address config;
        address owner;
        address dao;
        bool locked;
        uint256  totalSupply;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
        new_storage.config = old_storage.config;
        new_storage.owner = old_storage.owner;
        new_storage.dao = old_storage.dao;
        new_storage.locked = old_storage.locked;
        new_storage.totalSupply = old_storage.totalSupply;
    }

}
