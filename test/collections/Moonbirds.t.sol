// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/Moonbirds.sol";

contract MoonbirdsTest is Test {
    Moonbirds public moonbirds;

    function setUp() public {
        moonbirds = new Moonbirds();
    }

    function testGetBaseURI() public {
        moonbirds.initialize("https://live---metadata-5covpqijaa-uc.a.run.app/metadata/");
        assertEq(moonbirds.getBaseURI(), "https://live---metadata-5covpqijaa-uc.a.run.app/metadata/");
    }

    function testGetTokenURI() public {
        moonbirds.initialize("https://live---metadata-5covpqijaa-uc.a.run.app/metadata/");
        moonbirds.mintNext();
        assertEq(moonbirds.tokenURI(1), "https://live---metadata-5covpqijaa-uc.a.run.app/metadata/1");
    }

    function testGetMoonbirdsInitHash() public view {
        bytes memory initCode = type(Moonbirds).creationCode;
        console.logBytes32(keccak256(initCode));
    }

    function testMintAndTokenURI() public {
        moonbirds.initialize("https://live---metadata-5covpqijaa-uc.a.run.app/metadata/");
        moonbirds.mintNext();
        moonbirds.mintNext();
        
        assertEq(moonbirds.tokenURI(1), "https://live---metadata-5covpqijaa-uc.a.run.app/metadata/1");
        assertEq(moonbirds.tokenURI(2), "https://live---metadata-5covpqijaa-uc.a.run.app/metadata/2");
    }

    function testTokenURINonexistentToken() public {
        moonbirds.initialize("https://live---metadata-5covpqijaa-uc.a.run.app/metadata/");
        vm.expectRevert("ERC721Metadata: URI query for nonexistent token");
        moonbirds.tokenURI(1);
    }
} 