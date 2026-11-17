---
id: zama-coprocessor-signers
title: "Zama FHEVM: a quantum attacker who recovers 3 of 5 coprocessor ECDSA keys can get unproven ciphertext inputs accepted by every FHEVM application on mainnet"
project: zama
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: unknown
alternative: key-rotation-only
role: core
contracts:
- address: "0xce0fc2e05cfff1b719eff7169f7d80af770c8ea2"
  implementation: "0xc4a1a1bae73ca6aceb2faa62ce08bfabcd2323b6"
  name: InputVerifier (ERC1967 UUPS proxy)
  upgradeable: "yes"
  admin: "ACL owner = Aragon OSx DAO 0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3 (onlyACLOwner: upgrade, defineNewContext, setThreshold); read at block 26431457"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 15160
families: []
fix:
  layer: contract-upgrade
  who_acts: "Zama governance: the Aragon OSx DAO 0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3 that owns the ACL 0xca2e8f1f656cd25c01f05d0b243ab1ecd4a8ffb6 upgrades InputVerifier; the coprocessors must sign with a post-quantum scheme"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/zama-coprocessor-signers/classification.jsonl
  - evidence/zama-coprocessor-signers/onchain.json
  - evidence/zama-coprocessor-signers/activity.json
  - evidence/zama-coprocessor-signers/source-excerpts.md
  - evidence/zama-coprocessor-signers/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review09 (finding review)
  ref: evidence/zama-coprocessor-signers/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [zama-kms-verifier-signers]
---

## Summary

Zama's FHEVM accepts an encrypted user input only with an input proof signed by at least 3 of 5 coprocessor ECDSA
keys, attesting that the ciphertext came with a valid zero-knowledge proof of knowledge and is bound to the user and
the application (PQ-5). A quantum attacker who recovers three keys can have any handle list accepted as a user's input
for any application, skipping the proof of knowledge. What that releases depends on each FHEVM application
(confidential tokens and others); it was not measured. Rated MEDIUM (step 4): the governing DAO can upgrade the
verifier.

## Mechanism

- `InputVerifier.verifyInput(context, inputHandle, inputProof)` (l.239-328), called by FHEVMExecutor
  `0xd82385dada1ae3e969447f20a3164f6213100e75` when an application takes an encrypted input: the proof carries the
  handles, 65-byte coprocessor signatures and extra data; the EIP-712 `CiphertextVerification` binds handles, user,
  contract and chain id (l.298-312).
- `_verifySignaturesDigest` (l.442-474): each signature through `_recoverSigner` -> `ECDSA.recover` (l.519-520), must be
  a registered signer; at least `getThreshold()` distinct signers.
- `defineNewContext` (l.169) and `setThreshold` (l.205) rotate signers and threshold; `_authorizeUpgrade` (l.552); all
  `onlyACLOwner`, i.e. `msg.sender == ACL(0xca2e8f1f…).owner()`.

Pattern PQ-5. Excerpts: [`source-excerpts.md`](../evidence/zama-coprocessor-signers/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source of `0xc4a1a1ba…`, read 2026-11-17): the functions above
  ([`review-reads.json`](../evidence/zama-coprocessor-signers/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): EIP-1967 implementation `0xc4a1a1ba…`; `getCoprocessorSigners()` 5 addresses,
  `getThreshold()` 3; ACL `owner()` = `0xb6d69d5f…`, an ERC-1967 proxy to an Aragon OSx `DAO` implementation
  (`0x58c1f7bc…`; Blockscout name), not a Safe.
- CHECKED (precompile trace to March 2026): 32,655 pre-quantum calls in the year (`data/report/curated_contracts.csv`,
  `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 15,160 transactions reached it (all through other contracts)
  ([`activity.json`](../evidence/zama-coprocessor-signers/activity.json)).
- NOT READ: which Aragon plugin (multisig or token vote) can make the DAO execute, and the FHEVM applications that
  consume inputs.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xce0fc2e0…` InputVerifier (ERC1967 UUPS proxy) | yes | — | 2026-11-16 | 15,160 |

The verifier holds nothing. The funds it guards sit in each FHEVM application (for example confidential-token
wrappers holding the underlying tokens); there is no single escrow, so the exposure is not measured and `impact` is
`unknown`: forged inputs remove the proof-of-knowledge guarantee and let an attacker bind arbitrary handles, but
whether that moves funds depends on each application's logic. The decryption side, where forged results release
wrapper funds directly, is KMSVerifier `0x77627828a55156b04ac0dc0eb30467f1a552bb03`: see `zama-kms-verifier-signers`.

## Remediation

- Zama governance (DAO `0xb6d69d5f…`): upgrade InputVerifier to verify post-quantum coprocessor signatures (ML-DSA or
  hash-based, or one succinct proof over them); `defineNewContext` alone only rotates ECDSA keys. The underlying FHE
  scheme is lattice-based and is not the issue.
- Applications: nothing they can do alone; they depend on the host contracts.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM kept (step 4: upgrade by the ACL owner, an Aragon OSx DAO 0xb6d69d5f…; value unmeasured, so step 5 lowers nothing). `impact` funds-loss -> unknown: forged input attestations skip proof of knowledge, but no direct fund release was established. Signers (5) and threshold (3) read at block 26,431,457; KMSVerifier 0x77627828… found and filed as `zama-kms-verifier-signers`.
