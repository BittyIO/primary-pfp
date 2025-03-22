// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/CoolCats.sol";

contract CoolCatsTest is Test {
    CoolCats public cats;

    function setUp() public {
        cats = new CoolCats();
    }

    function testGetBaseURI() public {
        cats.initialize("https://api.coolcats.com/cat/");
        assertEq(cats.getBaseURI(), "https://api.coolcatsnft.com/cat/");
    }

    function testGetTokenURI() public {
        cats.initialize("https://api.coolcats.com/cat/");
        cats.mintNext();
        assertEq(cats.tokenURI(1), "https://api.coolcatsnft.com/cat/");
    }

    function testGetCoolCatsInitHash() public view {
        bytes memory initCode = type(CoolCats).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
