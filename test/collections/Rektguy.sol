// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/Rektguy.sol";

contract RektguyTest is Test {
    Rektguy public rektguy;

    function setUp() public {
        rektguy = new Rektguy();
    }

    function testGetBaseURI() public {
        rektguy.initialize("https://ipfs.io/ipfs/QmeGnSL9fbqkGfAUnLUWgcBkEwbD5BjNpdDWb5EzhhpVLN/");
        assertEq(rektguy.getBaseURI(), "https://ipfs.io/ipfs/QmeGnSL9fbqkGfAUnLUWgcBkEwbD5BjNpdDWb5EzhhpVLN/");
    }

    function testGetTokenURI() public {
        rektguy.initialize("https://ipfs.io/ipfs/QmeGnSL9fbqkGfAUnLUWgcBkEwbD5BjNpdDWb5EzhhpVLN/");
        rektguy.mintNext();
        assertEq(rektguy.tokenURI(1), "https://ipfs.io/ipfs/QmeGnSL9fbqkGfAUnLUWgcBkEwbD5BjNpdDWb5EzhhpVLN/1");
    }

    function testGetRektguyInitHash() public view {
        bytes memory initCode = type(Rektguy).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
