# Review reads: wormhole-guardian-signatures (2026-11-17, Review17)

Core bridge `0x98f3c9e6e3face36baad05fe09d375ef1464288b` (latest block 26,431,523):

- EIP-1967 implementation `0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0`; admin slot 0.
- `getCurrentGuardianSetIndex()` = 7; `getGuardianSet(7)` = 19 keys (first `0x5893b5a76c3f739645648885bdccc06cd70a3cd3`).
- `chainId()` = 2, `governanceChainId()` = 1, `governanceContract()` = 0x…04.
- Implementation bytecode contains `submitContractUpgrade(bytes)` (0x5cb8cae2) and `submitNewGuardianSet(bytes)`
  (0x6606b4e0): upgrades and guardian changes are governance VAAs signed by the guardians.
- Verified source `Messages.verifySignatures`: `ecrecover(hash, v, r, s) == guardianSet.keys[guardianIndex]` per
  signature; `verifyVM` (Messages.sol 54) requires `quorum(n) = n * 2 / 3 + 1` (line 172; 13 of 19).

Token bridge (Portal) `0x3ee18b2214aff97000d974cf647e7c347e8fa585` (latest block 26,431,713):

- `wormhole()` = core `0x98f3c9e6…`; EIP-1967 implementation `0x381752f5458282d317d12c30d2bd4d6e1fd8841e`
  (Blockscout name BridgeImplementation); admin slot 0; implementation has `upgrade(bytes)`, `completeTransfer(bytes)`,
  `registerChain(bytes)`, all VAA-driven.
- Holdings: see [`escrow.json`](escrow.json): ≥ $997.6M of priced ERC-20s plus 3.30 ETH (~$6k).
- NFT bridge `0x6ffd7ede62328b3af38fcd61461bbfc52f5651fe`: `wormhole()` = core; not valued.

Second contract `0x74f09cb3c7e2a01865f424fd14f6dc9a14e3e94e` (latest block 26,431,523):

- EIP-1967 implementation `0x87047526937246727e4869c5f76a347160e08672` (unverified); admin slot 0.
- Same `getCurrentGuardianSetIndex()` = 7 and an identical `getGuardianSet(7)` result (md5 of the return data
  equal); same chain/governance ids.
- Implementation bytecode has `parseAndVerifyVM` and `submitNewGuardianSet`, and no `submitContractUpgrade`,
  `upgradeTo`, `upgradeToAndCall` or `publishMessage`: a verify-only Wormhole receiver whose guardian set follows
  guardian-signed VAAs.
- Creator `0x78357316239040e19fc823372cc179ca75e64b81`; it relayed `submitNewGuardianSet` to it (2023-08-09 to
  2026-06-25) and also operates Pyth contracts (PythLazer proxy `0xacea761c…`, Pyth price-feed contract
  `0x4305fb66…`).
- Tx `0x960a2d4c…` (block 26,306,172, Blockscout internal calls): Pyth executor proxy
  `0xccd7e24e71ba746cbc758c39cbab11f4e0dfc46f` (impl `0x395921b6…`) staticcalls `0x74f09cb3…` to verify a VAA, then
  calls PythLazer `0xacea761c27a909d4d3895128ebe6370fde2df481` (impl name `PythLazer` on Sourcify), whose `owner()` is
  the executor. So `0x74f09cb3…` is Pyth's Wormhole receiver for Pyth Lazer governance, not a contract called by
  "unidentified diamond 0x2254c9a5" as the curation note said.
- The executor implementation has `upgradeTo`/`upgradeToAndCall` and the executor is its own owner: Pyth governance
  VAAs can repoint it.
- Pyth's price-feed contract `0x4305fb66…` uses a different receiver, `wormhole()` = `0x3a2dd09b4739d905183d503d594c8fb3e3d41820`
  (not in this registry; not checked).
