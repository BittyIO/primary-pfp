// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/BoredApeYachtClub.sol";

contract BoredApeYachtClubTest is Test {
    BoredApeYachtClub public bayc;

    function setUp() public {
        bayc = new BoredApeYachtClub();
    }

    function testGetBaseURI() public {
        bayc.initialize("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/");
        assertEq(bayc.getBaseURI(), "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/");
    }

    function testGetTokenURI() public {
        bayc.initialize("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/");
        bayc.mintNext();
        assertEq(bayc.tokenURI(1), "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/1");
    }

    function testGetBAYCInitHash() public view {
        bytes memory initCode = type(BoredApeYachtClub).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
