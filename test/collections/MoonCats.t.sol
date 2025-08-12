// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/MoonCats.sol";

contract MoonCatsTest is Test {
    MoonCats public moonCats;

    function setUp() public {
        moonCats = new MoonCats();
    }

    function testGetBaseURI() public {
        moonCats.initialize("https://api.mooncat.community/traits/");
        assertEq(moonCats.getBaseURI(), "https://api.mooncat.community/traits/");
    }

    function testGetTokenURI() public {
        moonCats.initialize("https://api.mooncat.community/traits/");
        moonCats.mintNext();
        assertEq(moonCats.tokenURI(1), "https://api.mooncat.community/traits/1");
    }

    function testGetMoonCatsInitHash() public view {
        bytes memory initCode = type(MoonCats).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
