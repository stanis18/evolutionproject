pragma solidity >=0.5.0 <0.9.0;


/**
 * @title Set interface
 */
contract SetFactory {
  function createSet(address[] memory _tokens, uint[] memory _units, uint _naturalUnit) public returns (address);
}
