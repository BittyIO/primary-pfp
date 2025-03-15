// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "ds-test/test.sol";
import "../src/PrimaryPFP.sol";

contract GetInitCodeHashTest is Test {
    PrimaryPFP public ppfp;

    function setUp() public {
        ppfp = new PrimaryPFP();
    }

    function testGetInitCodeHash() public view {
        bytes memory bytecode = type(PrimaryPFP).creationCode;
        console.logBytes32(keccak256(bytecode));
    }
}
