---
id: zerodev-ecdsa-validator
title: "ZeroDev Kernel v3 ECDSA validators: a quantum attacker who recovers an account owner's key controls every Kernel account that still has these validators installed"
project: zerodev
status: confirmed
severity: MEDIUM
patterns: [PQ-12, PQ-17]
primitives: [ecrecover]
trigger: owner-keys
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f"
  implementation: null
  name: MultiChainValidator
  upgradeable: "no"
  admin: "none; each Kernel account sets its owner on install and can change or uninstall its validators"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 246
- address: "0x845adb2c711129d4f3966735ed98a9f09fc4ce57"
  implementation: null
  name: ECDSAValidator
  upgradeable: "no"
  admin: "none; each Kernel account sets its owner on install and can change or uninstall its validators"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 8440
families: []
fix:
  layer: account-migration
  who_acts: "each Kernel account owner (changeRootValidator to a post-quantum validator module, then uninstallValidation of these ECDSA validators); ZeroDev or another party must first ship such a module"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zerodev-ecdsa-validator
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review08 (verified validator and Kernel sources)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zerodev-ecdsa-validator/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families eb5e632c, 28de8c06"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

ZeroDev Kernel v3 smart accounts that use these two validator modules are controlled by one secp256k1 owner key
(PQ-12). A quantum attacker who recovers it (the key signs user operations on-chain) can sign user operations and
ERC-1271 signatures for the account and take everything it holds. The exposure is the balances of all such Kernel
accounts, which were not enumerated. Rated MEDIUM (step 4): the modules are immutable, but each Kernel account can
switch its root validator in place and uninstall these ones, so owners migrate without moving funds. The draft's
HIGH assumed a fixed signer set.

## Mechanism

- `ECDSAValidator.validateUserOp` / `isValidSignatureWithSender` (`src/validator/ECDSAValidator.sol` lines 52-85):
  success iff `ecdsaValidatorStorage[msg.sender].owner == ECDSA.recover(hash, sig)`, on the raw or eth-signed hash.
- `MultiChainValidator` (lines 59-128): the same check. A longer signature is one ECDSA signature over a Merkle root
  of user-op hashes on several chains, so one forged signature also authorises operations on other chains.
- The Kernel account calls the validator selected by the user-op nonce. Validators are per-account modules;
  `onInstall` sets the owner.

Pattern PQ-12. Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zerodev-ecdsa-validator/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source of both validators): the checks above.
- CHECKED (Sourcify, Kernel v3.1 implementation `0xbac849bb…` and `0xd6cedde8…`): `changeRootValidator`,
  `uninstallValidation`, `invalidateNonce` and `uninstallModule` exist and are callable by the account through its
  root validator ([`notes.md`](#review-notes-review08-2026-11-17)).
- CHECKED (on-chain read, block 26,431,214): neither validator is a proxy and neither holds funds
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zerodev-ecdsa-validator/onchain.json)).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 246 and 8,440 transactions called the two validators
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zerodev-ecdsa-validator/activity.json)).
- CHECKED (precompile trace, year to March 2026, `curated_contracts.csv`): 21,843 (MultiChainValidator) and 132,888
  (ECDSAValidator) transactions with `ecrecover` in these modules.
- INFERRED: no post-quantum Kernel validator module is deployed on mainnet; ZeroDev's published alternatives
  (passkey/WebAuthn) use P-256, also pre-quantum.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x5c97aa67…` MultiChainValidator | no | — (module) | 2026-11-15 | 246 |
| `0x845adb2c…` ECDSAValidator | no | — (module) | 2026-11-16 | 8,440 |

The validators hold nothing. The exposure is the ETH and tokens held by every Kernel account with either module
installed. Measuring it needs the installing accounts (the `onInstall` calls) and their balances, which were not
enumerated here.

## Remediation

- ZeroDev (or a third party): publish an ERC-7579 validator that verifies a post-quantum signature (ML-DSA, Falcon,
  or a hash-based scheme).
- Each account owner: `changeRootValidator` to that module, then `uninstallValidation` of the ECDSA validator. A
  non-root ECDSA validator that stays installed keeps working; `invalidateNonce` can also revoke it. EIP-8141 frame
  accounts are another target.
- No protocol change is needed. EIP-8151 would help only an owner whose owner address itself gains account code;
  switching the validator is the direct fix.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: signer set fixed in code; funds must move, and many independent owners may not act).
- 2026-11-17 review (Review08): HIGH -> MEDIUM, step 4: Kernel v3 accounts can change their root validator and uninstall these modules in place (owners migrating their accounts), and the funds are each owner's own, not pooled; the fix needs a post-quantum validator module first.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

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
