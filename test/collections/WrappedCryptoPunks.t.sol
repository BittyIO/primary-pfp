// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/WrappedCryptoPunks.sol";

contract WrappedPunksTest is Test {
    WrappedCryptopunks public punks;

    function setUp() public {
        punks = new WrappedCryptopunks();
    }

    function testGetBaseURI() public {
        punks.initialize("https://wrappedpunks.com:3000/api/punks/metadata/");
        assertEq(punks.getBaseURI(), "https://wrappedpunks.com:3000/api/punks/metadata/");
    }

    function testGetTokenURI() public {
        punks.initialize("https://wrappedpunks.com:3000/api/punks/metadata/");
        punks.mintNext();
        assertEq(punks.tokenURI(1), "https://wrappedpunks.com:3000/api/punks/metadata/1");
    }

    function testGetWrappedPunkInitHash() public view {
        bytes memory initCode = type(WrappedCryptopunks).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
