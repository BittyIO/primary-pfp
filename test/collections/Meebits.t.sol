// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/Meebits.sol";

contract MeebitsTest is Test {
    Meebits public meebits;

    function setUp() public {
        meebits = new Meebits();
    }

    function testGetBaseURI() public {
        meebits.initialize("https://meebits.larvalabs.com/meebit/");
        assertEq(meebits.getBaseURI(), "https://meebits.larvalabs.com/meebit/");
    }

    function testGetTokenURI() public {
        meebits.initialize("https://meebits.larvalabs.com/meebit/");
        meebits.mintNext();
        assertEq(meebits.tokenURI(1), "https://meebits.larvalabs.com/meebit/1");
    }

    function testGetMeebitsInitHash() public view {
        bytes memory initCode = type(Meebits).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
