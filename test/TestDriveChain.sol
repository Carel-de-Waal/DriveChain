pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DriveChain.sol";

contract TestDriveChain {
  function testInitialBalanceUsingDeployedContract() {
    DriveChain driveChain = DriveChain(DeployedAddresses.DriveChain());
    uint expected = 1;
    Assert.equal(driveChain.requestLift(1, 1, 2, 2, 500), expected, "Index should start at 1");
  }

}