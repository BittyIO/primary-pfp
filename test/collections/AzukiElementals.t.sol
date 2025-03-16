// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/AzukiElementals.sol";

contract AzukiElementalsTest is Test {
    AzukiElementals public elem;

    function setUp() public {
        elem = new AzukiElementals();
    }

    function testGetBaseURI() public {
        elem.initialize("https://elementals-metadata.azuki.com/elemental/");
        assertEq(elem.getBaseURI(), "https://elementals-metadata.azuki.com/elemental/");
    }

    function testGetTokenURI() public {
        elem.initialize("https://elementals-metadata.azuki.com/elemental/");
        elem.mintNext();
        assertEq(elem.tokenURI(1), "https://elementals-metadata.azuki.com/elemental/1");
    }

    function testGetElementalsInitHash() public view {
        bytes memory initCode = type(AzukiElementals).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
