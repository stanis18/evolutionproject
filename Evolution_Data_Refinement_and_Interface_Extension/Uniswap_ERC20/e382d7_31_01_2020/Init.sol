pragma solidity >=0.5.0 <0.9.0;

contract Init {

    struct OldFacetStorage {
        string  name_;
        string  symbol_;
        uint8  decimals_;
        uint256 totalSupply;
        mapping (address => uint256)  balanceOf;
        mapping (address => mapping (address => uint256))  allowance;
        bytes32  DOMAIN_SEPARATOR;
        bytes32  APPROVE_TYPEHASH;
        mapping (address => uint)  nonceFor;
    }


    struct NewFacetStorage {
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

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
