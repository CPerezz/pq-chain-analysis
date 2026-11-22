---
id: 367b3f1a-signature-rechecked
title: "0x367b3f1a: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-locked
contracts:
- address: "0x367b3f1a56970628fe9318c721506bb6ca3475ea"
  family: "9e04da3166ca3afd031b75e71bee60e8"
  copies: 135
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 1263
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody can (promisor's key)"
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
  note: "The promisee, who did nothing, loses its locked payment with no update path and no owner/admin rescue."
---

## Summary

Robonomics liability (proxy to 0x02b133a8…): the promisee's 0.3 WETH cost is held until finalize, which requires the promisor's ECDSA signature on the result. If the promisor address takes code, finalize can never pass, and the promisee's payment is stuck with no refund path.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Robonomics robot liabilities (135): demand and offer are signed promises; a validator signs the result (as f36169d3). Bytecode and names.
- Update path, read at block 26,438,999: proxy to 0x02b133a8daa10f1ce6e3a75dc93959c0cfbc7bc2: no admin, no upgrade function in the implementation.
- decompiled implementation 0xc5213e31 (finalize): require(!isFinalized); recovered signer must equal promisor; payout only after that
- at 26438999: promisor 0xF737…d028 (EOA), promisee 0x6EFB…C3Ad, validator 0, isFinalized false, 0.3 WETH held, lighthouse 0xD06E…8fB7
- the implementation has no admin and no upgrade function, and no refund or timeout function

## Impact and exposure

- Value held at block 26,438,999: $1,263 (ETH and 49 priced tokens, over 135 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on chain; the promisor must finalize while its key still recovers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
