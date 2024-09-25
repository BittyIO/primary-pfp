// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";

import "../lib/delegate-registry/src/DelegateRegistry.sol";

import "../src/PrimaryPFP.sol";
import "../src/IPrimaryPFP.sol";
import "../src/TestPFP.sol";

contract PrimaryCollectionPFPTest is Test {
    event CollectionPrimarySet(address indexed to, address indexed contract_, uint256 tokenId);

    event CollectionPrimarySetByDelegateCash(address indexed to, address indexed contract_, uint256 tokenId);

    event CollectionPrimaryRemoved(address indexed from, address indexed contract_, uint256 tokenId);

    DelegateRegistry dc;
    PrimaryPFP public ppfp;
    TestPFP public testPFP;
    TestPFP public testPFP1;
    address public testPFPAddress;
    address public testPFPAddress1;
    address public delegate;
    address contract_;
    uint256 tokenId;
    bytes32 rights;

    function setUp() public {
        dc = new DelegateRegistry();
        ppfp = new PrimaryPFP();
        ppfp.initialize(address(dc));
        testPFP = new TestPFP("Test PFP", "TPFP");
        testPFP1 = new TestPFP("Test PFP1", "TPFP1");
        testPFPAddress = address(testPFP);
        testPFPAddress1 = address(testPFP1);
        delegate = makeAddr("delegate");
        vm.prank(msg.sender);
        testPFP.mint(0);
        rights = bytes32(0);
    }

    function _setCollectionPrimaryPFP(uint256 _tokenId) internal {
        vm.prank(msg.sender);
        ppfp.setCollectionPrimary(testPFPAddress, _tokenId);
    }

    function testSetNotFromSender() public {
        vm.expectRevert("msg.sender is not the owner");
        ppfp.setCollectionPrimary(testPFPAddress, 0);
    }

    function testCollectionDuplicatedSet() public {
        _setCollectionPrimaryPFP(0);
        vm.expectRevert("collection duplicated set");
        _setCollectionPrimaryPFP(0);
    }

    function testGetPrimaryCollectionEmpty() public {
        tokenId = ppfp.getCollectionPrimary(msg.sender, contract_);
        assertEq(tokenId, 0);
    }

    function testSetCollectionPrimaryPFP() public {
        _setCollectionPrimaryPFP(0);

        vm.prank(msg.sender);
        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 0);
    }

    function testEventForSetPrimaryCollection() public {
        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit CollectionPrimarySet(msg.sender, testPFPAddress, 0);
        ppfp.setCollectionPrimary(testPFPAddress, 0);
    }

    function testSetPrimaryCollectionPFPByDelegateCashNotDelegated() public {
        vm.expectRevert("msg.sender is not delegated");
        ppfp.setCollectionPrimaryByDelegateCash(testPFPAddress, 0);
    }

    function testSetPrimaryCollectionPFPByDelegateCashToken() public {
        vm.prank(msg.sender);

        dc.delegateERC721(delegate, testPFPAddress, 0, rights, true);
        assertTrue(dc.checkDelegateForERC721(delegate, msg.sender, testPFPAddress, 0, rights));

        vm.prank(delegate);
        emit CollectionPrimarySetByDelegateCash(msg.sender, testPFPAddress, 0);
        ppfp.setCollectionPrimaryByDelegateCash(testPFPAddress, 0);

        tokenId = ppfp.getCollectionPrimary(delegate, contract_);
        assertEq(tokenId, 0);
    }

    function testSetPrimaryCollectionPFPByDelegateCashContract() public {
        vm.prank(msg.sender);

        dc.delegateContract(delegate, testPFPAddress, rights, true);
        assertTrue(dc.checkDelegateForContract(delegate, msg.sender, testPFPAddress, rights));

        vm.prank(delegate);
        ppfp.setCollectionPrimaryByDelegateCash(testPFPAddress, 0);

        tokenId = ppfp.getCollectionPrimary(delegate, testPFPAddress);
        assertEq(tokenId, 0);
    }

    function testSetPrimaryPFPByDelegateCashAll() public {
        vm.prank(msg.sender);

        dc.delegateAll(delegate, rights, true);
        assertTrue(dc.checkDelegateForAll(delegate, msg.sender, rights));

        vm.prank(delegate);
        ppfp.setCollectionPrimaryByDelegateCash(testPFPAddress, 0);

        tokenId = ppfp.getCollectionPrimary(delegate, contract_);
        assertEq(tokenId, 0);
    }

    function testSetCollectionOverrideByNewPFP() public {
        _setCollectionPrimaryPFP(0);

        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        testPFP.mint(1);
        _setCollectionPrimaryPFP(1);

        vm.prank(msg.sender);
        assertTrue(ppfp.hasCollectionPrimary(msg.sender, testPFPAddress));

        vm.prank(msg.sender);
        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 1);

        _setCollectionPrimaryPFP(0);

        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 0);

        assertTrue(ppfp.hasCollectionPrimary(msg.sender, testPFPAddress));
    }

    function testSetCollectionOverrideBySameOwner() public {
        _setCollectionPrimaryPFP(0);

        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        testPFP.mint(1);

        vm.expectEmit(true, true, true, true);
        emit CollectionPrimaryRemoved(msg.sender, testPFPAddress, 0);

        vm.expectEmit(true, true, true, true);
        emit CollectionPrimarySet(msg.sender, testPFPAddress, 1);

        _setCollectionPrimaryPFP(1);

        vm.prank(msg.sender);
        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 1);
    }

    function testRemovePrimaryFromTwoAddresses() public {
        _setCollectionPrimaryPFP(0);

        vm.prank(delegate);
        testPFP.mint(1);

        vm.prank(delegate);
        ppfp.setCollectionPrimary(testPFPAddress, 1);

        vm.prank(delegate);
        IERC721(testPFPAddress).transferFrom(delegate, msg.sender, 1);

        assertEq(IERC721(testPFPAddress).ownerOf(1), msg.sender);

        vm.expectEmit(true, true, true, true);
        emit CollectionPrimaryRemoved(msg.sender, testPFPAddress, 0);

        vm.expectEmit(true, true, true, true);
        emit CollectionPrimaryRemoved(delegate, testPFPAddress, 1);

        vm.expectEmit(true, true, true, true);
        emit CollectionPrimarySet(msg.sender, testPFPAddress, 1);

        _setCollectionPrimaryPFP(1);

        vm.prank(msg.sender);

        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 1);
    }

    function testSetOverrideByNewOwner() public {
        _setCollectionPrimaryPFP(0);

        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        IERC721(testPFPAddress).transferFrom(msg.sender, delegate, 0);

        vm.prank(delegate);
        vm.deal(delegate, 1 ether);

        ppfp.setPrimary(testPFPAddress, 0);

        vm.prank(msg.sender);
        tokenId = ppfp.getCollectionPrimary(delegate, testPFPAddress);
        assertEq(tokenId, 0);
    }

    function testSetOverrideBySameAddress() public {
        _setCollectionPrimaryPFP(0);

        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 0);

        vm.prank(msg.sender);
        testPFP.mint(1);
        _setCollectionPrimaryPFP(1);

        vm.prank(msg.sender);
        tokenId = ppfp.getCollectionPrimary(msg.sender, testPFPAddress);
        assertEq(tokenId, 1);
    }

    function testRemoveFromWrongSender() public {
        vm.expectRevert("msg.sender is not the owner");
        vm.prank(delegate);
        ppfp.removeCollectionPrimary(testPFPAddress, 0);
    }

    function testRemoveFromAddressNotSet() public {
        vm.expectRevert("collection primary PFP not set");
        vm.prank(msg.sender);
        ppfp.removeCollectionPrimary(testPFPAddress, 0);
    }

    function testRemovePrimaryCollection() public {
        _setCollectionPrimaryPFP(0);

        vm.prank(msg.sender);
        vm.expectEmit(true, true, false, true);
        emit CollectionPrimaryRemoved(msg.sender, testPFPAddress, 0);
        ppfp.removeCollectionPrimary(testPFPAddress, 0);

        vm.prank(msg.sender);
        tokenId = ppfp.getCollectionPrimary(msg.sender, contract_);
        assertEq(tokenId, 0);
        assertFalse(ppfp.hasCollectionPrimary(msg.sender, contract_));
    }
}
