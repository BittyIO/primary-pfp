// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "ds-test/test.sol";
import "../src/TestPFP.sol";
import "../src/PrimaryPFP.sol";

contract CollectionVerificationTest is Test {
    event CollectionVerified(address indexed contract_);

    event CollectionVerificationRemoved(address indexed contract_);

    PrimaryPFP public ppfp;
    TestPFP public testPFP;
    address public testPFPAddress;
    address[] public pfpAddresses;

    function setUp() public {
        ppfp = new PrimaryPFP();
        testPFP = new TestPFP("Test PFP", "TPFP");
        testPFPAddress = address(testPFP);
        pfpAddresses.push(testPFPAddress);
    }

    function testAddVerification() public {
        vm.expectEmit(true, false, false, true);

        emit CollectionVerified(testPFPAddress);

        vm.prank(tx.origin);
        ppfp.addVerification(pfpAddresses);
        assertTrue(ppfp.isCollectionVerified(testPFPAddress));
    }

    function testRemoveVerification() public {
        vm.prank(tx.origin);
        ppfp.addVerification(pfpAddresses);

        vm.expectEmit(true, false, false, true);

        emit CollectionVerificationRemoved(testPFPAddress);

        vm.prank(tx.origin);
        ppfp.removeVerification(pfpAddresses);
        assertFalse(ppfp.isCollectionVerified(testPFPAddress));
    }
}
