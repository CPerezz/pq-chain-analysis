---
id: tokennetwork-a5c9ecf5-signature-rechecked
title: "TokenNetwork: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xa5c9ecf54790334b73e5dfa1ff5668eb425dc474"
  family: "5f8034f7a32a92fdd7f3d6349ec9c93c"
  name: "TokenNetwork"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 3845
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Raiden participants (close channels while partners can still sign)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "The receiving participant relied on the partner's signed balance proofs and loses them; the settle timeout does not help, and there is no update path."
---

## Summary

Raiden TokenNetwork 0.4.0: at close, a participant proves what it received with the partner's signed balance proof, and updateNonClosingBalanceProof does the same. If the partner's address takes code, the proof no longer verifies, and the participant can only close with nonce 0, losing every off-chain transfer received.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Raiden ECVerify: returns the signer, zero rejected / Raiden closeChannel: the closing party presents the partner's signed balance proof / Raiden updateNonClosingBalanceProof: balance proofs signed by…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TokenNetwork.sol:620-665 closeChannel: if nonce > 0, recoverAddressFromBalanceProof(...) must equal partner; nonce 0 is allowed but forfeits received transfers
- updateNonClosingBalanceProof (686-730) recovers both the non-closing and the closing participant
- contract_version 0.4.0; only deprecation_executor controls (no upgrade); txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $3,845 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Participants should settle channels before a partner's address takes code; no on-chain fix.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
