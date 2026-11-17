# Review notes (Review08, 2026-11-17)

Validators (Sourcify, verified):
- `ECDSAValidator` `0x845adb2c…`: `validateUserOp` (lines 52-67) and `isValidSignatureWithSender` (69-85) return success
  iff `ecdsaValidatorStorage[msg.sender].owner == ECDSA.recover(hash, sig)` (raw hash or eth-signed hash). Owner is set
  by `onInstall` from the Kernel account; there is no other admin.
- `MultiChainValidator` `0x5c97aa67…`: same check; a signature longer than 65 bytes signs a Merkle root of user-op
  hashes across chains (lines 59-128).
- Neither is a proxy; neither holds ETH or tokens (onchain.json, block 26,431,214).

Kernel v3 accounts (Sourcify, `src/Kernel.sol`): implementation `0xbac849bb641841b44e965fb01a4bf5f074f84b4d` (v3.1)
has `changeRootValidator` (line 124), `installValidations` (421), `uninstallValidation` (430), `invalidateNonce`
(439), `uninstallModule` (443); implementation `0xd6cedde84be40893d153be9d467cd6ad37875b28` has the same functions
(lines 135, 396, 405, 425, 429). All are `onlyEntryPointOrSelfOrRoot`: the account's current root validator (here the
ECDSA owner) authorises the switch.

Usage: `data/report/curated_contracts.csv`: `0x5c97aa67…` 21,843 transactions with `ecrecover` in the year to March
2026; `0x845adb2c…` 132,888. The number of Kernel accounts with these validators installed and their balances were
not enumerated.
