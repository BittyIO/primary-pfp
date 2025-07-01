// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/TestNFT.sol";

contract TestNFTTest is Test {
    TestNFT public testNFT;

    function setUp() public {
        testNFT = new TestNFT();
    }

    function testGetBaseURI() public {
        testNFT.initialize("ipfs://QmTestNFTBaseURI/");
        assertEq(testNFT.getBaseURI(), "ipfs://QmTestNFTBaseURI/");
    }

    function testGetTokenURI() public {
        testNFT.initialize("ipfs://QmTestNFTBaseURI/");
        testNFT.mintNext();
        assertEq(testNFT.tokenURI(1), "ipfs://QmTestNFTBaseURI/1");
    }

    function testGetTestNFTInitHash() public view {
        bytes memory initCode = type(TestNFT).creationCode;
        console.logBytes32(keccak256(initCode));
    }

    function testMintAndTokenURI() public {
        testNFT.initialize("https://api.testnft.com/metadata/");
        testNFT.mintNext();
        testNFT.mintNext();
        
        assertEq(testNFT.tokenURI(1), "https://api.testnft.com/metadata/1");
        assertEq(testNFT.tokenURI(2), "https://api.testnft.com/metadata/2");
    }

    function testTokenURINonexistentToken() public {
        testNFT.initialize("ipfs://QmTestNFTBaseURI/");
        vm.expectRevert("ERC721Metadata: URI query for nonexistent token");
        testNFT.tokenURI(1);
    }

    function testGetInitHash() public view {
        bytes memory initCode = type(TestNFT).creationCode;
        console.logBytes32(keccak256(initCode));
    }
} 