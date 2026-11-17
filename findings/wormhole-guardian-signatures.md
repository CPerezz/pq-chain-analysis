---
id: wormhole-guardian-signatures
title: "Wormhole core bridge (0x98f3c9e6): a quantum attacker who recovers 13 of the 19 guardian ECDSA keys can forge VAAs that release the ~$1B held by the Portal token bridge and upgrade both contracts"
project: wormhole
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x98f3c9e6e3face36baad05fe09d375ef1464288b"
  implementation: "0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0"
  name: Wormhole core bridge (proxy) / Implementation
  upgradeable: "yes"
  admin: "Wormhole guardians: submitContractUpgrade and submitNewGuardianSet governance VAAs, 13 of 19 signatures (guardian set 7, block 26431523); EIP-1967 admin slot empty"
  value_usd: 997572946
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 87455
families: []
fix:
  layer: contract-upgrade
  who_acts: "Wormhole guardians (13 of 19) sign governance VAAs: submitContractUpgrade on core 0x98f3c9e6 and upgrade on token bridge 0x3ee18b22 to post-quantum guardian signatures"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wormhole-guardian-signatures
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review17 (on-chain reads, bytecode selectors, Blockscout holdings and internal calls)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wormhole-guardian-signatures/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [pyth-wormhole-receiver]
---

## Summary

Every Wormhole message (VAA) on Ethereum is accepted if 13 of the 19 guardians' secp256k1 signatures recover
correctly in the core bridge. The core itself holds ~$6, but the Portal token bridge `0x3ee18b22…`, which releases
tokens on VAAs verified by this core, holds at least $997.6M. A quantum attacker who recovers 13 guardian keys can
forge transfer VAAs to empty it, and forge governance VAAs to upgrade the core and the token bridge. The guardians
can fix it by a governance upgrade before that happens, so the rating is MEDIUM (step 4: contract upgrade by a
governance quorum).

## Mechanism

- `Messages.verifySignatures` (implementation `0x3c3d457f…`, `/contracts/Messages.sol` 89-95):
  `ecrecover(hash, sig.v, sig.r, sig.s) == guardianSet.keys[sig.guardianIndex]` for each signature;
  `verifyVM` (line 54) requires `quorum(n) = n * 2 / 3 + 1` signatures (line 172; 13 of 19). Consumers call `parseAndVerifyVM`.
- The token bridge's `completeTransfer(bytes)` and governance `upgrade(bytes)`/`registerChain(bytes)` act on VAAs
  verified by the core; the core's `submitContractUpgrade(bytes)` and `submitNewGuardianSet(bytes)` are VAAs too.
  So the guardian keys control both the funds and the upgrade path (PQ-5).
- Consumers that keep their own copy of the guardian set, such as Pyth's receiver `0x74f09cb3…`, are covered in
  [`pyth-wormhole-receiver`](pyth-wormhole-receiver.md).

## Evidence

- CHECKED (verified source of `0x3c3d457f…`): `verifySignatures` and the quorum
  ([`source-excerpts.md`](#source-excerpts-wormhole-guardian-signatures)).
- CHECKED (on-chain, latest block 26,431,523): core EIP-1967 implementation `0x3c3d457f…`, admin slot empty, guardian
  set index 7 with 19 keys; implementation bytecode contains `submitContractUpgrade` and `submitNewGuardianSet`
  ([`review-notes.md`](#review-reads-wormhole-guardian-signatures-2026-11-17-review17)).
- CHECKED (block 26,431,713): token bridge `0x3ee18b22…` `wormhole()` = core; implementation `0x381752f5…` has
  `completeTransfer` and `upgrade`.
- CHECKED (Blockscout holdings, 2026-11-17, remote box): token bridge holds ≥ $997.57M of priced ERC-20s (RENDER
  $628M, WBTC $159M, WETH $87M, SPX $32M, DEXE $24M, …) and 3.30 ETH ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wormhole-guardian-signatures/escrow.json)).
  The read stopped at 7 pages, so this is a lower bound.
- CHECKED (Xatu, any function): core 87,455 transactions 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wormhole-guardian-signatures/activity.json)); 1,034,627 `ecrecover` transactions
  through the core in the yearly window (`studies/top-callers-classification/results/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x98f3c9e6…` Wormhole core | yes (guardian VAA) | $6; escrow ≥ $997.6M (token bridge) | 2026-11-16 | 87,455 |

Escrow: Portal token bridge `0x3ee18b2214aff97000d974cf647e7c347e8fa585`, ≥ $997.6M on 2026-11-17 (Blockscout,
priced tokens only). Not counted: the NFT bridge `0x6ffd7ede…`, NTT managers, relayers and other integrators that
verify against the same core. Pyth's receivers are in [`pyth-wormhole-receiver`](pyth-wormhole-receiver.md).

## Remediation

- Wormhole guardians move to a post-quantum attestation (hash-based or ML-DSA guardian signatures, verified directly
  or aggregated in a STARK) and sign `submitContractUpgrade` for the core and `upgrade` for the token bridge to
  implementations that verify it. Because these governance VAAs are signed with the same ECDSA keys, the upgrade must
  happen while the keys are still safe.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review17): MEDIUM kept, step 4: guardian-signed governance upgrade. Escrow measured (token bridge ≥ $997.6M, replacing the core's $6 `held`); `0x74f09cb3…` identified as Pyth's Wormhole receiver used by the Pyth executor (curation note said an unidentified diamond); status candidate -> confirmed.
- 2026-11-17 review (Review17, follow-up): severity unchanged; `0x74f09cb3…` (Pyth's receiver) moved to the new finding `pyth-wormhole-receiver` and linked in `related`.

# Source excerpts: wormhole-guardian-signatures

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x98f3c9e6e3face36baad05fe09d375ef1464288b` — Wormhole (verified source via sourcify)

## Implementation `0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0` — Implementation (verified source via sourcify)

### `/contracts/Messages.sol`

```solidity
   89              /// semantics of solidity.
   90              require(sig.guardianIndex < guardianCount, "guardian index out of bounds");
   91  
   92              /// Check to see if the signer of the signature does not match a specific Guardian key at the provided index
   93              if(ecrecover(hash, sig.v, sig.r, sig.s) != guardianSet.keys[sig.guardianIndex]){
   94                  return (false, "VM signature invalid");
   95              }
   96          }
   97  
  ...
```


## Contract `0x74f09cb3c7e2a01865f424fd14f6dc9a14e3e94e`

No verified source on Sourcify or Blockscout.

## Implementation `0x87047526937246727e4869c5f76a347160e08672`

No verified source on Sourcify or Blockscout.

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
