// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/MiladyMaker.sol";

contract MiladyMakerTest is Test {
    MiladyMaker public milady;

    function setUp() public {
        milady = new MiladyMaker();
    }

    function testGetBaseURI() public {
        milady.initialize("https://www.miladymaker.net/milady/json/");
        assertEq(milady.getBaseURI(), "https://www.miladymaker.net/milady/json/");
    }

    function testGetTokenURI() public {
        milady.initialize("https://www.miladymaker.net/milady/json/");
        milady.mintNext();
        assertEq(milady.tokenURI(1), "https://www.miladymaker.net/milady/json/1");
    }

    function testGetMiladyInitHash() public view {
        bytes memory initCode = type(MiladyMaker).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
