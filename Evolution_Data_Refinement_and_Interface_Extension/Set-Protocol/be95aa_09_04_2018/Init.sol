pragma solidity >=0.5.0 <0.9.0;

contract Init {

    struct OldFacetStorage {
        mapping (address => mapping (address => uint256))  allowed;
        address[] tokens;
        uint[] units;
        mapping(address => uint256) balances;
        uint256 totalSupply;
        string name;
        string symbol;
        uint8 decimals;
    }

    struct PartialRedeemStatus { uint unredeemedBalance; bool isRedeemed; }

    struct NewFacetStorage {
        mapping (address => mapping (address => uint256))  allowed;
        address[] tokens;
        uint[] units;
        mapping(address => uint256) balances;
        uint256 totalSupply;
        string name;
        string symbol;
        uint8 decimals;
        mapping(address => mapping(address => PartialRedeemStatus)) unredeemedComponents;
        mapping(address => bool) isComponent;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
