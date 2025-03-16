// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/WrappedV1Punks.sol";

contract WrappedV1PunksTest is Test {
    WrappedV1Punks public wv1p;

    function setUp() public {
        wv1p = new WrappedV1Punks();
    }

    function testGetBaseURI() public {
        wv1p.initialize("ipfs://Qma3sC19HbnWHqeLgcsQnR7Kvgus4oPQirXNH7QYBeACaq/");
        assertEq(wv1p.getBaseURI(), "ipfs://Qma3sC19HbnWHqeLgcsQnR7Kvgus4oPQirXNH7QYBeACaq/");
    }

    function testGetTokenURI() public {
        wv1p.initialize("ipfs://Qma3sC19HbnWHqeLgcsQnR7Kvgus4oPQirXNH7QYBeACaq/");
        wv1p.mintNext();
        assertEq(wv1p.tokenURI(1), "ipfs://Qma3sC19HbnWHqeLgcsQnR7Kvgus4oPQirXNH7QYBeACaq/1");
    }

    function testGetWV1PInitHash() public view {
        bytes memory initCode = type(WrappedV1Punks).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
