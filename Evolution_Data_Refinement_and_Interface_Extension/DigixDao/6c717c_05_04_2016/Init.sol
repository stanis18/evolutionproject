pragma solidity >=0.5.0 <0.9.0;

contract Init {

     struct User {
        bool locked;
        uint256 balance;
        uint256 badges;
        mapping (address => uint256) allowed;
  }

    struct OldFacetStorage {
        mapping (address => User) users;
        mapping (address => uint256) balances;
        mapping (address => mapping (address => uint256)) allowed;
        mapping (address => bool) seller;
        address config;
        address owner;
        uint256  totalSupply;
        uint256  totalBadges;
        address dao;
        bool locked;
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
       
    }

}
