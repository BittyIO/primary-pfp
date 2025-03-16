// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/SappySeals.sol";

contract SappySealsTest is Test {
    SappySeals public seals;

    function setUp() public {
        seals = new SappySeals();
    }

    function testGetBaseURI() public {
        seals.initialize("ipfs://QmXUUXRSAJeb4u8p4yKHmXN1iAKtAV7jwLHjw35TNm5jN7/");
        assertEq(seals.getBaseURI(), "ipfs://QmXUUXRSAJeb4u8p4yKHmXN1iAKtAV7jwLHjw35TNm5jN7/");
    }

    function testGetTokenURI() public {
        seals.initialize("ipfs://QmXUUXRSAJeb4u8p4yKHmXN1iAKtAV7jwLHjw35TNm5jN7/");
        seals.mintNext();
        assertEq(seals.tokenURI(1), "ipfs://QmXUUXRSAJeb4u8p4yKHmXN1iAKtAV7jwLHjw35TNm5jN7/1");
    }

    function testGetSappySealsInitHash() public view {
        bytes memory initCode = type(SappySeals).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
