// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/PudgyPenguins.sol";

contract PudgyPenguinsTest is Test {
    PudgyPenguins public pudgy;

    function setUp() public {
        pudgy = new PudgyPenguins();
    }

    function testGetBaseURI() public {
        pudgy.initialize("ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/");
        assertEq(pudgy.getBaseURI(), "ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/");
    }

    function testGetTokenURI() public {
        pudgy.initialize("ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/");
        pudgy.mintNext();
        assertEq(pudgy.tokenURI(1), "ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/1");
    }

    function testGetPudgyInitHash() public view {
        bytes memory initCode = type(PudgyPenguins).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
