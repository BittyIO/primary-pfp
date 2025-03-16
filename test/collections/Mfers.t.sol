// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/Mfers.sol";

contract MfersTest is Test {
    Mfers public mfers;

    function setUp() public {
        mfers = new Mfers();
    }

    function testGetBaseURI() public {
        mfers.initialize("ipfs://QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/");
        assertEq(mfers.getBaseURI(), "ipfs://QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/");
    }

    function testGetTokenURI() public {
        mfers.initialize("ipfs://QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/");
        mfers.mintNext();
        assertEq(mfers.tokenURI(1), "ipfs://QmWiQE65tmpYzcokCheQmng2DCM33DEhjXcPB6PanwpAZo/1");
    }

    function testGetMfersInitHash() public view {
        bytes memory initCode = type(Mfers).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
