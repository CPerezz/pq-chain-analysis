---
id: everclear-fee-signer
title: "Everclear FeeAdapter (V1 and V2): a quantum attacker who recovers the fee-signer key can sign its own fee quotes and skip Everclear's fees on its own intents; no user or pooled funds are released"
project: everclear
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: auxiliary
contracts:
- address: "0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75"
  implementation: null
  name: FeeAdapter (superseded)
  upgradeable: config-only
  admin: owner Safe 0xa02a88f0bbd47045001bd460ad186c30f9a974d6 (2 of 6; updateFeeSigner)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-11-12
  txs_30d: 0
- address: "0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e"
  implementation: null
  name: FeeAdapterV2
  upgradeable: config-only
  admin: owner Safe 0xa02a88f0bbd47045001bd460ad186c30f9a974d6 (2 of 6; updateFeeSigner)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-04-08
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: Everclear (owner Safe 0xa02a88f0bbd47045001bd460ad186c30f9a974d6) deploys a fee adapter that verifies fee quotes through ERC-1271 or a post-quantum scheme
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/everclear-fee-signer/classification.jsonl
  - evidence/everclear-fee-signer/onchain.json
  - evidence/everclear-fee-signer/activity.json
  - evidence/everclear-fee-signer/source-excerpts.md
  - evidence/everclear-fee-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/everclear-fee-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Everclear's FeeAdapter takes the protocol fee for an intent only against a fee quote signed by one ECDSA key,
`feeSigner` (PQ-4). A quantum attacker who recovers that key can sign zero-fee quotes for its own intents and skip
Everclear's fee; the quote does not release user or pooled funds, which the Everclear spoke handles separately. The
original FeeAdapter has been unused since 2025-11-12; its replacement FeeAdapterV2 (same signer, same check) was last
used 2026-04-08; both hold nothing. Rated LOW (step 4): the check guards only the fee, through which nothing can be
taken from others.

## Mechanism

FeeAdapter: every `newIntent`/`newOrder` path calls `_handleFees` (FeeAdapter.sol lines 394–418), which requires
`ECDSA.recover(toEthSignedMessageHash(keccak256(abi.encode(tokenFee, nativeFee, inputAsset, deadline))), sig) ==
feeSigner` (lines 381–387) and then forwards the fees to `feeRecipient`; the intent itself is created on the Everclear
spoke. FeeAdapterV2 binds the signed data to the call, the adapter and the chain and checks the same `feeSigner`
(FeeAdapterV2.sol lines 423–436). `updateFeeSigner` is `onlyOwner`; any new signer is again an ECDSA key. Lines:
[`notes.md`](../evidence/everclear-fee-signer/notes.md).

## Evidence

- CHECKED (verified source, Sourcify, both adapters): the paths above.
- CHECKED (`cast` at block 26,431,599): both not proxies; `owner()` = `feeRecipient()` = Safe `0xa02a88f0…` (2 of 6);
  `feeSigner()` = `0xd148c7f3…81c8` on both; 0 ETH.
- CHECKED (Blockscout): V1 last called 2025-11-12; V2 deployed 2025-11-11, last called 2026-04-08; V2 holds ≈ $0.02.
- CHECKED (precompile trace to March 2026): 12,631 V1 transactions with `ecrecover` in the last year.
- CHECKED (Everclear docs, `resources/contracts/mainnet.md`): `FeeAdapter` on chain 1 is `0xd0185bfb…` (V2).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x15a7ca97…` FeeAdapter (superseded) | config-only | $0 | 2025-11-12 | 0 |
| `0xd0185bfb…` FeeAdapterV2 | config-only | $0 | 2026-04-08 | 0 |

The worst effect is lost fee revenue on intents the attacker submits itself; deposits and settlements run through the
Everclear spoke and hub, which this signature does not authorise. Fee adapters on other chains are out of scope.

## Remediation

- Everclear deploys a fee adapter that verifies quotes through ERC-1271 (a signer contract with a post-quantum key) or
  a post-quantum scheme, and points its API at it; the owner Safe's signers should also move to post-quantum
  accounts.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-11-12) and nothing held).
- 2026-11-17 review (Review07): LOW unchanged, now step 4 (the check only guards Everclear's own fee) since the
  current FeeAdapterV2 `0xd0185bfb…`, added here, was active in 2026-04. Impact funds-loss -> none, role core ->
  auxiliary.
