// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0;
// pragma solidity ^0.4.11;

contract IERC20 {

  function allowance(address owner, address spender) public returns (uint);
  function transferFrom(address from, address to, uint value) public;
  function approve(address spender, uint value) public;
  function balanceOf(address who) public returns (uint);
  function transfer(address to, uint value) public;
  
}