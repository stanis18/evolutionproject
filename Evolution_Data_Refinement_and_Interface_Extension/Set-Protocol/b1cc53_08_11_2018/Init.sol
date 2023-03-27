pragma solidity >=0.5.0 <0.9.0;

contract Init {

    struct PartialRedeemStatus { uint unredeemedBalance; bool isRedeemed; }

    struct OldFacetStorage {
        mapping (address => mapping (address => uint256))  allowed;
        address[] tokens;
        uint[] units;
        mapping(address => uint256) balances;
        uint256 totalSupply;
        string name;
        string symbol;
        uint8 decimals;
        Component[] components;
        mapping(address => bool) isComponent;
        mapping(address => mapping(address => UnredeemedComponent)) unredeemedComponents;
        string  COMPONENTS_INPUT_MISMATCH;
        string  COMPONENTS_MISSING;
        string  UNITS_MISSING;
        string  ZERO_QUANTITY;
        string  INVALID_SENDER;
        address factory;
    }

    struct Component { address address_; uint unit_; }
    struct UnredeemedComponent { uint balance; bool isRedeemed; }

    struct NewFacetStorage {
        mapping (address => mapping (address => uint256))  allowed;
        address[] tokens;
        uint[] units;
        mapping(address => uint256) balances;
        uint256 totalSupply;
        string name;
        string symbol;
        uint8 decimals;
        Component[] components;
        mapping(address => bool) isComponent;
        mapping(address => mapping(address => UnredeemedComponent)) unredeemedComponents;
        address factory;
    }

    OldFacetStorage old_storage;
    NewFacetStorage new_storage;


    function init() public {
       
    }

}
