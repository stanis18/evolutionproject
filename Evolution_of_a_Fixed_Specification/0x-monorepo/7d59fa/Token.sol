pragma solidity >=0.4.24 <0.9.0;

contract Token {

    function totalSupply() returns (uint supply) {}

    function balanceOf(address _owner) returns (uint balance) {}

    function transfer(address _to, uint _value) returns (bool success) {}

    function transferFrom(address _from, address _to, uint _value) returns (bool success) {}

    function approve(address _spender, uint _value) returns (bool success) {}

    function allowance(address _owner, address _spender) returns (uint remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
