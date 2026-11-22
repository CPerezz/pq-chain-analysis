---
id: 7a984235-signature-rechecked
title: "0x7a984235: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x7a984235ee85d776eafaa1b0a09ce760748dd4a6"
  family: "98f05b387a3caac1555165638fcfa61e"
  copies: 2
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "bridge operator (redeploy); relayers"
evidence:
  level: bytecode
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
  note: "A wrong verdict slashes an honest relayer who did nothing wrong, and there is no update path; no owner or admin rescue returns the slashed half."
---

## Summary

A NEAR-style light-client bridge: a relayer submits a head and locks ETH, and anyone may challenge() a block-producer signature that does not verify, taking half the relayer's lock. For secp256k1 producer keys, ecrecover must equal the producer address. If that address has code, a valid signature looks invalid and an honest relayer is slashed.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: light-client bridge by its function names (challenge, checkBlockProducerSignatureInHead): anyone may challenge a block whose producer signature does not verify. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled challenge(address,uint256): ecrecover(...) compared with the producer address; 'Can't challenge valid signature'; on success it transfers store_u/2 to the challenger and the rest to store_v, and reverts the head
- checkBlockProducerSignatureInHead(uint256) uses the same ecrecover path; ed25519 keys go to an external checker (store_w)
- withdraw() 0x3ccfd60b is open to anyone except the current relayer (store_t); txs_90d 0, no proxy or upgrade

## Impact and exposure

- Value held at block 26,438,999: $5,414 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a code check or a non-ecrecover path for producer keys; relayers should not submit heads that rely on such producers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
