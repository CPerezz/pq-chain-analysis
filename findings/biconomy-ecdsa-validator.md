---
id: biconomy-ecdsa-validator
title: "Biconomy Nexus K1MeeValidator: a quantum attacker who recovers an account owner's ECDSA key controls the Nexus account until the owner swaps in a post-quantum validator; the 40 accounts seen hold about $33"
project: biconomy
status: confirmed
severity: LOW
patterns: [PQ-12]
primitives: [ecrecover]
trigger: owner-keys
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x00000000d12897ddadc2044614a9677b191a2d95"
  implementation: null
  name: K1MeeValidator
  upgradeable: "no"
  admin: none (no proxy, no owner); each account installs or uninstalls the validator module itself
  value_usd: 33
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 32
families: []
fix:
  layer: account-migration
  who_acts: each Nexus account owner (install a post-quantum validator, then uninstall K1MeeValidator); Biconomy to ship such a validator
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/biconomy-ecdsa-validator/classification.jsonl
  - evidence/biconomy-ecdsa-validator/onchain.json
  - evidence/biconomy-ecdsa-validator/activity.json
  - evidence/biconomy-ecdsa-validator/source-excerpts.md
  - evidence/biconomy-ecdsa-validator/review-reads.json
  - evidence/biconomy-ecdsa-validator/accounts.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl,out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review22)
  ref: evidence/biconomy-ecdsa-validator/accounts.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [unidentified-1c6ad754-signer-key]
---

## Summary

Biconomy's `K1MeeValidator` is the ERC-7579 validator module that lets a single secp256k1 owner key run a Nexus smart
account (PQ-12). A quantum attacker who recovers an owner's key (public once it has signed) can sign user operations and
ERC-1271 messages as that account and take everything in it. Accounts can fix this themselves: install a post-quantum
validator and uninstall this one. The 40 accounts seen with an owner registered since March 2026 hold about $33. Rated
LOW (step 4: MEDIUM, owners migrate their accounts in place; step 5: under $50k).

## Mechanism

- `validateUserOp` reads `getOwner(userOp.sender)` and, depending on the 4-byte signature type, calls
  `SimpleValidatorLib`, `TxValidatorLib`, `PermitValidatorLib` or `NoMeeFlowLib`. Every one of them ends in
  `EcdsaLib.isValidSignature(owner, hash, sig)`, which is Solady `tryRecover` on the hash and on its `eth_sign` form
  (`EcdsaLib.sol` lines 14-22). `isValidSignatureWithSender` (ERC-1271, lines 190-209) and `validateSignatureWithData`
  (lines 215-222) use the same `_validateSignatureForOwner`.
- `onInstall` and `transferOwnership` revert with `NewOwnerIsContract` if the new owner has code (lines 91, 110), so
  the owner cannot be a post-quantum contract signer. If no owner is stored, `getOwner` returns the account itself
  (lines 229-232): the EIP-7702 case, where the key is the account's own EOA key.

Excerpts: [`source-excerpts.md`](../evidence/biconomy-ecdsa-validator/source-excerpts.md).

## Evidence

- CHECKED (verified source on Blockscout, solc 0.8.27): the paths above; no proxy, no owner.
- CHECKED (RPC at block 26,431,523): no EIP-1967 implementation slot
  ([`review-reads.json`](../evidence/biconomy-ecdsa-validator/review-reads.json)).
- CHECKED (Xatu call frames since block 24,700,000; 661 transactions): the candidate accounts are `handleOps` senders,
  direct callees and contracts created in those transactions (279). Of these, 40 have `isInitialized` = true; they hold
  0.015 ETH and 6 USDT, about $33 (RPC and Multicall3 `balanceOf` for eight major tokens, about block 26,431,523;
  [`accounts.json`](../evidence/biconomy-ecdsa-validator/accounts.json)).
- CHECKED (Xatu, any function): 32 transactions in 2026-10-16 to 2026-11-16. There were 58,326 pre-quantum calls in the
  year to March 2026 (`curated_contracts.csv` `txs_y1`).
- INFERRED: accounts that used the validator only before block 24,700,000, and EIP-7702 accounts with no stored owner
  (exposed through their own EOA key anyway), are not counted.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000000…2d95` K1MeeValidator | no | $33 (escrow: 40 Nexus accounts) | 2026-11-15 | 32 |

The validator holds nothing; the value is in the accounts that use it.

## Remediation

- Nexus accounts: `installModule` a post-quantum validator (ML-DSA, Falcon or hash-based signatures), then
  `uninstallModule(K1MeeValidator)`. Until it is uninstalled, the old key still validates. Moving ownership to a
  contract signer is not possible (`NewOwnerIsContract`).
- Who acts: each account owner; Biconomy to provide the post-quantum validator. The module cannot be upgraded and
  does not need to be.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for an owner EOA that has moved to post-quantum account
  code.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: signer set fixed in code; funds must move, and many independent owners may not act).
- 2026-11-17 review (Review22): HIGH -> MEDIUM, step 4: both are pluggable account modules; each owner can install a post-quantum validator and remove this one in place, so funds do not have to move. `0xba418fa6…` identified as a third-party fork (deployer 0xac6a87, with an ECDSA co-signer), not Biconomy's module; `protocol_change` set to helps (EIP-8151).
- 2026-11-17 review (Review22): module `0xba418fa6…` moved to `unidentified-1c6ad754-signer-key` (same deployer 0xac6a87), with its evidence. MEDIUM -> LOW, step 5: K1MeeValidator accounts measured (40 initialized accounts, about $33).
