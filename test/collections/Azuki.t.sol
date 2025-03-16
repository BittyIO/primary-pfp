// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "src/collections/Azuki.sol";

contract AzukiTest is Test {
    Azuki public azuki;

    function setUp() public {
        azuki = new Azuki();
    }

    function testGetBaseURI() public {
        azuki.initialize("ipfs://QmZcH4YvBVVRJtdn4RdbaqgspFU8gH6P9vomDpBVpAL3u4/");
        assertEq(azuki.getBaseURI(), "ipfs://QmZcH4YvBVVRJtdn4RdbaqgspFU8gH6P9vomDpBVpAL3u4/");
    }

    function testGetTokenURI() public {
        azuki.initialize("ipfs://QmZcH4YvBVVRJtdn4RdbaqgspFU8gH6P9vomDpBVpAL3u4/");
        azuki.mintNext();
        assertEq(azuki.tokenURI(1), "ipfs://QmZcH4YvBVVRJtdn4RdbaqgspFU8gH6P9vomDpBVpAL3u4/1");
    }

    function testGetAzukiInitHash() public view {
        bytes memory initCode = type(Azuki).creationCode;
        console.logBytes32(keccak256(initCode));
    }
}
