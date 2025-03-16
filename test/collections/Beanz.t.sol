// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/Beanz.sol";

contract BeanzTest is Test {
    Beanz public beanz;

    function setUp() public {
        beanz = new Beanz();
    }

    function testGetBaseURI() public {
        beanz.initialize("ipfs://QmdYeDpkVZedk1mkGodjNmF35UNxwafhFLVvsHrWgJoz6A/beanz_metadata/");
        assertEq(beanz.getBaseURI(), "ipfs://QmdYeDpkVZedk1mkGodjNmF35UNxwafhFLVvsHrWgJoz6A/beanz_metadata/");
    }

    function testGetTokenURI() public {
        beanz.initialize("ipfs://QmdYeDpkVZedk1mkGodjNmF35UNxwafhFLVvsHrWgJoz6A/beanz_metadata/");
        beanz.mintNext();
        assertEq(beanz.tokenURI(1), "ipfs://QmdYeDpkVZedk1mkGodjNmF35UNxwafhFLVvsHrWgJoz6A/beanz_metadata/1");
    }

    function testGetBeanzInitHash() public view {
        bytes memory initCode = type(Beanz).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
