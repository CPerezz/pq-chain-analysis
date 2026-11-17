---
id: unidentified-54805468-owner-keys
title: "Unidentified 9-of-15 custody multisig 0x54805468 (factory 0x657975f6): a quantum attacker who recovers 9 owner ECDSA keys can move its $64.5M USDT"
project: unidentified-54805468
status: confirmed
severity: MEDIUM
patterns: [PQ-12]
primitives: [ecrecover]
trigger: owner-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x548054687ef6c56c6d82e8269e5fd93d8b88fcb2"
  implementation: "0x8ff1ae80507d4c714456b7535e736ef4cfdaea19"
  name: Wallet proxy → impl 0x8ff1ae80 (unverified multisig, selectors batchTransfer/execute/addOwner with uint8[] v, bytes32[] r, bytes32[] s)
  upgradeable: "no"
  admin: none for the code (proxy reads getWalletImpl() from factory 0x657975f60cd55b81e0c029dd0572d5e678b3a9cf, which has no setter); 15 EOA owners, 9 required, can add/replace owners and change the threshold with 9 signatures
  value_usd: 64502798
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 23
families: []
fix:
  layer: account-migration
  who_acts: the wallet's owners (9 of 15 EOAs, e.g. 0xa76d273815d9607f12ea03c9792b6b144e44bf19, 0x570eaec51b09200fb05db932b1fa672b3eaa0edc) moving the funds to a wallet with post-quantum signers
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-54805468-owner-keys/classification.jsonl
  - evidence/unidentified-54805468-owner-keys/onchain.json
  - evidence/unidentified-54805468-owner-keys/activity.json
  - evidence/unidentified-54805468-owner-keys/source-excerpts.md
  - evidence/unidentified-54805468-owner-keys/wallet.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review03 (registry review)
  ref: evidence/unidentified-54805468-owner-keys/wallet.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

0x54805468 is an unverified multisig wallet, created in 2025 by factory 0x657975f6, holding 64.5M USDT. Every
transfer, call and owner change needs 9 `(v, r, s)` signatures from its 15 EOA owners, checked with `ecrecover`
(PQ-12). All owners sign on-chain routinely, so a quantum attacker who recovers 9 of their keys can move the whole
balance. The code cannot change and accepts only ECDSA, so the fix is the owners moving the funds to a wallet with
post-quantum signers; they are one active operator, not independent parties. Rated MEDIUM (step 4: owners
migrating); the draft's HIGH assumed owners who may not act.

## Mechanism

- The 394-byte proxy staticcalls `getWalletImpl()` (0x34c5c27e) on the factory, whose address is compiled in, and
  delegatecalls the result, 0x8ff1ae80. The factory exposes only `getWalletImpl()` and
  `create(address[],uint256,bytes32,bool,uint256)`, so the implementation is fixed.
- Implementation selectors (resolved with the openchain signature database): `transfer`, `batchTransfer` and
  `execute(address,uint256,bytes,bytes32,uint8[],bytes32[],bytes32[],uint256)` move tokens, ETH or make arbitrary
  calls; `addOwner`, `removeOwner`, `replaceOwner`, `changeOwnerRequirement` and `changeSecurityParams` take the same
  signature arrays. All take `uint8[] v, bytes32[] r, bytes32[] s`.
- The bytecode has exactly one `STATICCALL`, inside a loop over `(v[i], r[i], s[i])`, in the shape Solidity emits
  for `ecrecover`, plus the secp256k1 half-order constant and `v ∈ {27, 28}` checks; there is no ERC-1271 selector.
  Owners are therefore keys, never contracts, and a post-quantum signer cannot be added in place.
- `isSecuritySwitchOn()` is true and `getDeactivatedInterval()` is 180 days; what they gate is not established from
  bytecode.

## Evidence

- CHECKED (bytecode of proxy, factory and implementation, block 26,431,578): structure, selectors and the single
  `ecrecover`-shaped `STATICCALL` as above; no verified source exists
  ([`wallet.json`](../evidence/unidentified-54805468-owner-keys/wallet.json)).
- CHECKED (precompile trace, all mainnet transactions to March 2026): the wallet calls `ecrecover` (`cats` =
  `ecrecover:1041` in `curated_contracts.csv`; `txs_y1` is empty there).
- CHECKED (on-chain read, block 26,431,578): `getOwners()` returns 15 addresses, all with no code; `getRequired()`
  = 9; factory `getWalletImpl()` = 0x8ff1ae80…; USDT balance 64,548,349
  ([`wallet.json`](../evidence/unidentified-54805468-owner-keys/wallet.json)).
- CHECKED (on-chain read, block 26,431,214): holdings $64.5M, almost all USDT
  ([`onchain.json`](../evidence/unidentified-54805468-owner-keys/onchain.json)).
- CHECKED (Xatu, any function): 23 transactions in 2026-10-16 to 2026-11-16, last 2026-11-14
  ([`activity.json`](../evidence/unidentified-54805468-owner-keys/activity.json)); recent transactions are
  `batchTransfer` calls sent by owner 0xa76d2738….
- CHECKED (Blockscout): no name, tag or ENS for the wallet, factory, factory deployer 0x4e1443a9… or the main
  counterparties; the operator is not identified.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x54805468…` Wallet proxy → 0x8ff1ae80 | no | $64.5M (USDT) | 2026-11-14 | 23 |

Siblings from the same factory (receipts of its 5 `create` calls, balances at block 26,431,596), not in the census
and not listed above: `0xca7fbeb7…` (1.57M USDT, created 2026-11-16), `0x573487d9…` (58.7k USDT, 5.6k USDC, 0.48
ETH), `0xe391cca8…` and `0x5096d787…` (empty). They run the same implementation and belong in this finding if the
census adds them.

## Remediation

- Post-quantum replacement: a wallet whose owners can be post-quantum signers (for example a Safe with ERC-1271
  signer contracts, or a smart account verifying ML-DSA), and the funds moved there with one `transfer` signed by 9
  current owners before a CRQC exists. Rotating owners inside this wallet does not help: new owners are ECDSA keys too.
- Who acts: the operator controlling the 15 owner keys. Not identified; the factory deployer is 0x4e1443a9….
- Protocol change: not needed. EIP-8151 would not help, since the wallet checks `ecrecover` against code-less keys.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: signer set fixed in code; funds must move, and many independent owners may not act).
- 2026-11-17 review (Review03): HIGH -> MEDIUM, step 4: the fix is the owners (one active operator, 9 of 15 EOAs) moving the funds to a post-quantum wallet. Status candidate -> confirmed: bytecode shows a single `ecrecover` loop and no ERC-1271 path, and owners, threshold and implementation were read on-chain. Operator still unidentified; 4 sibling wallets from the factory found.
