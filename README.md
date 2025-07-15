## Etherlink Tests

### Exercise 1: Vault Attack

Goal: Empty the vault

### Exercise 2: Unexpected Ether

- Part 1
  Goal: Claim funds and finish the game

- Part 2:
  Goal: Update the contract to prevent the above attack.

Solution: The above attack can be prevented by tracking and accounting for the total deposits to the contract manually.
This similar approach is used across ERC4626 Vault implementations to prevent price per share manipulations through airdrops.
