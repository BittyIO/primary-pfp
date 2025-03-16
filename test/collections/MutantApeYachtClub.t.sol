// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/MutantApeYachtClub.sol";

contract MutantApeYachtClubTest is Test {
    MutantApeYachtClub public mayc;

    function setUp() public {
        mayc = new MutantApeYachtClub();
    }

    function testGetBaseURI() public {
        mayc.initialize("https://boredapeyachtclub.com/api/mutants/");
        assertEq(mayc.getBaseURI(), "https://boredapeyachtclub.com/api/mutants/");
    }

    function testGetTokenURI() public {
        mayc.initialize("https://boredapeyachtclub.com/api/mutants/");
        mayc.mintNext();
        assertEq(mayc.tokenURI(1), "https://boredapeyachtclub.com/api/mutants/1");
    }

    function testGetMAYCInitHash() public view {
        bytes memory initCode = type(MutantApeYachtClub).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
