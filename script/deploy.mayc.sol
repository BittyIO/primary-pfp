// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.27;

import {console2} from "forge-std/console2.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MutantApeYachtClub} from "../src/collections/MutantApeYachtClub.sol";

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
    bytes initCode = type(MutantApeYachtClub).creationCode;
    bytes32 salt = 0x0000000000000000000000000000000000000000da3e0a91f79e20000016b83a;

    function run() external {
        vm.startBroadcast();
        address maycAddress = factory.safeCreate2(salt, initCode);
        MutantApeYachtClub mayc = MutantApeYachtClub(maycAddress);
        console2.log(address(mayc));
        vm.stopBroadcast();
    }
}
