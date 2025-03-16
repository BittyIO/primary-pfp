// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/Nakamigos.sol";

contract NakamigosTest is Test {
    Nakamigos public naka;

    function setUp() public {
        naka = new Nakamigos();
    }

    function testGetBaseURI() public {
        naka.initialize("ipfs://QmaN1jRPtmzeqhp6s3mR1SRK4q1xWPvFvwqW1jyN6trir9/");
        assertEq(naka.getBaseURI(), "ipfs://QmaN1jRPtmzeqhp6s3mR1SRK4q1xWPvFvwqW1jyN6trir9/");
    }

    function testGetTokenURI() public {
        naka.initialize("ipfs://QmaN1jRPtmzeqhp6s3mR1SRK4q1xWPvFvwqW1jyN6trir9/");
        naka.mintNext();
        assertEq(naka.tokenURI(1), "ipfs://QmaN1jRPtmzeqhp6s3mR1SRK4q1xWPvFvwqW1jyN6trir9/1");
    }

    function testGetNakamigosInitHash() public view {
        bytes memory initCode = type(Nakamigos).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
