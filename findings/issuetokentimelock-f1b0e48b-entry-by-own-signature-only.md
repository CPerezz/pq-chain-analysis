---
id: issuetokentimelock-f1b0e48b-entry-by-own-signature-only
title: "IssueTokenTimeLock: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0xf1b0e48bab6a7e1095107e8aacdd3ca302472e00"
  family: "3ce3dc6200657cf1ea8997f3f02b8610"
  name: "IssueTokenTimeLock"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the recipient (use an EOA) or the sender (plain transfer)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The recipient owns nothing yet; the sender keeps a plain transfer path."
---

## Summary

IssueTokenTimeLock: validateRequestTransferSignature (called only by IssueToken.requestTransfer) needs the recipient's signature to approve a peer-to-peer transfer that skips price locks. A recipient with code cannot approve.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: IssueTokenTimeLock validateRequestTransferSignature: the recipient named must sign a transfer request. Read (function text).
- IssueTokenTimeLock.sol L1104-1140: the recipient signs to accept; the sender's tokens are not locked by this check
- L866: price locks bite only on DEX transfers ('user can still transfer to wallets'), so plain transfers stay open to the sender; only time locks bind, and they expire
- state.json: 0 ETH at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
