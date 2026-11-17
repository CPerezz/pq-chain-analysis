# Review reads: rayls-distributor-signer (2026-11-17, Review17)

Sourcify source of `0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af` (`src/sub/Distributor.sol:Distributor`, solc 0.8.30,
solady): NatSpec `@title Distributor1MC`, `@notice Clique Airdrop contract (Mekle + ECDSA), allows for multiple claims`;
`version()` = "3.0.0".

- `claim(_proof, _signature, _amount, _released, _handler, _onBehalfOf, _extra)` (BaseDistributor.sol 244-292):
  `_handler` must equal `keccak256(_onBehalfOf)` unless `dynamicRecipient`; `_rootCheck` requires the Merkle leaf
  `(handler, amount)` to resolve to a configured root; then `_signatureCheck` and `_execute(vault, _onBehalfOf, root,
  _released - claimedAmount, _extra)`.
- `_signatureCheck` (326-346): `ECDSA.recoverCalldata(toEthSignedMessageHash(keccak256(handler, onBehalfOf, amount,
  released, root, this, chainid, extra)), signature) == signer`. The signer decides how much of an allocation is
  released (`_released`) and the hook data (`_extra`).
- `Distributor._execute` (Distributor.sol 107-144) splits the amount over the root's configured hooks
  (`IHook.execute(vault, recipient, root, amount, data)`).
- `PROJECT_ADMIN` (`_ROLE_0`) functions: `setSigner`, `setClaimRoot`, `setVault`, `setToken`, `pause`, `unpause`,
  `setActiveWindow`, fee setters, `setHooks`; `withdrawFee` is `onlyOwner`.

On-chain reads (latest block 26,431,623, 2026-11-17):

- `signer()` = `0x0f828d66ec5eba50d80b234ef487f82edfecbb92` (no code, nonce 0: signs off-chain only; its signatures are
  in `claim` calldata).
- `owner()` = `0xfdacab3de84fc1ac6518cced5afc008b16a9c1ff` (no code; Blockscout: creator, last admin calls
  `setClaimRoot`/`setFixedFee` 2026-03-01, `withdrawFee` 2026-01-21).
- `token()` = RLS `0xb5f7b021a78f470d31d762c1dda05ea549904fbd` ("Rayls", 18 decimals); `isWrappedToken()` false;
  `dynamicRecipient()` false.
- `vault()` = `0x5b9089a93dd0f48fd74ab80d6b9dccfac64d9989` (Blockscout: SafeProxy, singleton Safe; `getThreshold()` = 1,
  owner `0x60f0e09e51704ea6e472f877f849269eede76309`).
- RLS `balanceOf(vault)` = 9,849,783.86 RLS; `allowance(vault, distributor)` = 30,581,168.9 RLS.
- Blockscout RLS token: price $0.00155938, circulating market cap $3.37M → vault balance ≈ $15,360.
- Distributor ETH balance 0.0669 ETH (claim fees; Blockscout coin_balance).
- Blockscout transactions: `claim` calls through 2026-11-01.
