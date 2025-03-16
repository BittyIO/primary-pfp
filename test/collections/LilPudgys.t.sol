// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/LilPudgys.sol";

contract LilPudgysTest is Test {
    LilPudgys public lilp;

    function setUp() public {
        lilp = new LilPudgys();
    }

    function testGetBaseURI() public {
        lilp.initialize("https://api.pudgypenguins.io/lil/");
        assertEq(lilp.getBaseURI(), "https://api.pudgypenguins.io/lil/");
    }

    function testGetTokenURI() public {
        lilp.initialize("https://api.pudgypenguins.io/lil/");
        lilp.mintNext();
        assertEq(lilp.tokenURI(1), "https://api.pudgypenguins.io/lil/1");
    }

    function testGetLilPudgysInitHash() public view {
        bytes memory initCode = type(LilPudgys).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
