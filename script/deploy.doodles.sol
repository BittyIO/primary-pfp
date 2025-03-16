// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import {console2} from "forge-std/console2.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Doodles} from "../src/collections/Doodles.sol";

interface ImmutableCreate2Factory {
    function safeCreate2(bytes32 salt, bytes calldata initCode) external payable returns (address deploymentAddress);
    function findCreate2Address(bytes32 salt, bytes calldata initCode)
        external
        view
        returns (address deploymentAddress);
    function findCreate2AddressViaHash(bytes32 salt, bytes32 initCodeHash)
        external
        view
        returns (address deploymentAddress);
}

contract Deploy is Script {
    ImmutableCreate2Factory immutable factory = ImmutableCreate2Factory(0x0000000000FFe8B47B3e2130213B802212439497);
    bytes initCode = type(Doodles).creationCode;
    bytes32 salt = 0x00000000000000000000000000000000000000005be6a7b9a5b9a0000017d563;

    function run() external {
        vm.startBroadcast();
        address doodlesAddress = factory.safeCreate2(salt, initCode);
        Doodles doodles = Doodles(doodlesAddress);
        console2.log(address(doodles));
        vm.stopBroadcast();
    }
}
