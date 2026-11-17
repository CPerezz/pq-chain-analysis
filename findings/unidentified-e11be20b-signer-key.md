---
id: unidentified-e11be20b-signer-key
title: "Unidentified EIP-7702 wallet co-signer verifier 0xe11be20b: requires both the account's own key and a service key, so a recovered service key alone moves nothing"
project: unidentified-e11be20b
status: not-affected
severity: NONE
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: core
contracts:
- address: "0xe11be20b572a80e1fb9c5ec852595ad65cf09fe0"
  implementation: null
  name: unverified co-signature verifier (signer()/setSigner, operator()/setOperator, isNonceUsed, EIP-712 domain, pause)
  upgradeable: config-only
  admin: owner Safe 0x9287b8e84d972dd02f618bbed45b9a6d7ed16384 (3 of 5) sets signer and operator, pauses; no proxy
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-04-10
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: nobody for this check; each user's EIP-7702 account is as safe as its own EOA key
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-e11be20b-signer-key/classification.jsonl
  - evidence/unidentified-e11be20b-signer-key/onchain.json
  - evidence/unidentified-e11be20b-signer-key/activity.json
  - evidence/unidentified-e11be20b-signer-key/source-excerpts.md
  - evidence/unidentified-e11be20b-signer-key/cosign.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review03 (registry review)
  ref: evidence/unidentified-e11be20b-signer-key/cosign.json
  date: 2026-11-17
  verdict: refuted
  rating: NONE
related: []
---

## Summary

0xe11be20b is an unverified contract that EIP-7702-delegated user accounts call before executing a batch of their own
transfers. Replaying a real call shows it checks two ECDSA signatures over the same digest: one from a service
`signer()` EOA and one from the calling account's own key. A quantum attacker who recovers the service key still
needs the user's key, and with the user's key could send transactions from the EOA directly. Nothing beyond the
user's own account key is exposed, and the verifier holds nothing. Rated NONE (step 2: impact none); the draft
read it as a single-operator voucher (PQ-4, MEDIUM).

## Mechanism

- Callers are EIP-7702 accounts whose delegate (0x4428a93b… at the sampled block; a sibling delegate 0x490aac77…
  from the same deployer exposes `validateUserOp`, `isValidSignature` and the batch-execute selector 0x9265bb9d) call
  the verifier's unresolved selector 0x0db39b93 from inside 0x9265bb9d, then execute the batch from the account
  (in the sample, a 29.58 USDT transfer out of the account).
- The verifier's 0x0db39b93 hashes the batch with a nonce and deadline (EIP-712 domain), runs `ecrecover` twice and
  succeeds only if the first signature recovers to `signer()` and the second to `msg.sender` (the account).
  `operator()` is not checked on this path.
- So the service key is a co-signer (a second factor on the user's account), not a key that authorises value on
  its own.

## Evidence

- CHECKED (bytecode and selectors, block 26,431,613): no verified source; selectors resolved with the openchain
  database (`signer()`, `setSigner`, `operator()`, `setOperator`, `isNonceUsed`, `DOMAIN_SEPARATOR`, `pause`,
  `rescueETH`, `rescueERC20`, five unresolved); `owner()` = Safe 0x9287b8e8… (3 of 5), `signer()` = 0xdbea7a79… (no
  code), `operator()` = 0x5db8606f… (EIP-7702 EOA), not paused
  ([`cosign.json`](../evidence/unidentified-e11be20b-signer-key/cosign.json)).
- CHECKED (archive `debug_traceCall` and `eth_call` replays at block 23,270,944 of sample tx 0x951ca90a…): two
  `ecrecover` calls recovering `signer()` and the calling account; the call reverts (0x8baa579f) from any other
  sender, with a different signer in storage, or with either signature altered; changing `operator` has no effect.
- CHECKED (precompile corpus, `data/agg/y1_caller.parquet`): 66,106 `ecrecover` calls in 33,057 transactions,
  exactly two per transaction, blocks 22,573,205 to 24,287,159: every recorded use took the two-signature path.
- CHECKED (on-chain read, block 26,431,214): the verifier holds nothing
  ([`onchain.json`](../evidence/unidentified-e11be20b-signer-key/onchain.json)).
- CHECKED (Xatu, any function): no call in 2026-10-16 to 2026-11-16; last call a reverted transaction on 2026-04-10
  ([`activity.json`](../evidence/unidentified-e11be20b-signer-key/activity.json)). The sampled account now delegates to a
  different contract, 0xa845c743….
- INFERRED: the four unresolved selectors that take arguments were not decoded; the two-per-transaction precompile
  count indicates none of them verified a single signature in practice.
- CHECKED (Blockscout): no name, tag or ENS for the verifier, delegates, deployers 0xd7061474… / 0x31ba2234… or the
  signer; the project is not identified.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe11be20b…` co-signature verifier | config-only | $0 | 2026-04-10 | 0 |

Users' funds stay in their own EIP-7702 accounts, where the EOA key already controls everything; that key is out of
scope here.

## Remediation

- None needed for this check. If the wallet later supports post-quantum account keys, the co-signer check should
  verify the account through its code (ERC-1271 with the full signature) instead of `ecrecover` against
  `msg.sender`, and the service signer should move to a post-quantum scheme to keep its second-factor role.
- Protocol change: not needed for this contract.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review03): MEDIUM -> NONE, step 2: replay and trace show the verifier requires the calling account's own signature next to the service signer's, so a forged service key moves nothing; status candidate -> not-affected, impact none, fix layer none.
