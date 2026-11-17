---
id: zerodev-ecdsa-validator
title: "ZeroDev Kernel v3 ECDSA validators: a quantum attacker who recovers an account owner's key controls every Kernel account that still has these validators installed"
project: zerodev
status: confirmed
severity: MEDIUM
patterns: [PQ-12]
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
  links:
  - evidence/zerodev-ecdsa-validator/classification.jsonl
  - evidence/zerodev-ecdsa-validator/onchain.json
  - evidence/zerodev-ecdsa-validator/activity.json
  - evidence/zerodev-ecdsa-validator/source-excerpts.md
  - evidence/zerodev-ecdsa-validator/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review08 (verified validator and Kernel sources)
  ref: evidence/zerodev-ecdsa-validator/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
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

Pattern PQ-12. Excerpts: [`source-excerpts.md`](../evidence/zerodev-ecdsa-validator/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source of both validators): the checks above.
- CHECKED (Sourcify, Kernel v3.1 implementation `0xbac849bb…` and `0xd6cedde8…`): `changeRootValidator`,
  `uninstallValidation`, `invalidateNonce` and `uninstallModule` exist and are callable by the account through its
  root validator ([`notes.md`](../evidence/zerodev-ecdsa-validator/notes.md)).
- CHECKED (on-chain read, block 26,431,214): neither validator is a proxy and neither holds funds
  ([`onchain.json`](../evidence/zerodev-ecdsa-validator/onchain.json)).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 246 and 8,440 transactions called the two validators
  ([`activity.json`](../evidence/zerodev-ecdsa-validator/activity.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: signer set fixed in code; funds must move, and many independent owners may not act).
- 2026-11-17 review (Review08): HIGH -> MEDIUM, step 4: Kernel v3 accounts can change their root validator and uninstall these modules in place (owners migrating their accounts), and the funds are each owner's own, not pooled; the fix needs a post-quantum validator module first.
