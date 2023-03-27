pragma solidity >=0.5.0 <0.9.0;

/**
 * @title AddressArrayUtil
 */
library AddressArrayUtils {
  function hasValue(address[] memory addresses, address value) internal pure returns (bool) {
    for (uint i = 0; i < addresses.length; i++) {
      if (addresses[i] == value) {
        return true;
      }
    }

    return false;
  }

  function removeByIndex(address[] storage a, uint256 index) internal returns (uint256) {
    a[index] = a[a.length - 1];
    a.length -= 1;
  }
}