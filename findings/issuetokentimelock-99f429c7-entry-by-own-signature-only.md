---
id: issuetokentimelock-99f429c7-entry-by-own-signature-only
title: "IssueTokenTimeLock: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x99f429c74e5387983085fbb125f374bd4b1d8e25"
  family: "c39a66019703d66e7c4aab6836904ffd"
  copies: 2
  name: "IssueTokenTimeLock"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "transfer recipient (signs from an EOA/7702 key) or sender (uses another recipient)"
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
  note: "Acceptance by recipient only; nothing held behind it. IssueToken.requestTransfer source not in the dossier, so whether ordinary transfers stay open under its locks was not read."
---

## Summary

IssueTokenTimeLock: validateRequestTransferSignature (called only by the issue token) checks that the recipient signed a request-transfer. Under EIP-8151 a recipient with non-7702 code cannot approve an incoming request-transfer; the recipient holds nothing yet.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: IssueTokenTimeLock validateRequestTransferSignature: the recipient named must sign a transfer request. Read (function text).
- IssueTokenTimeLock.sol:1104-1139: msg.sender == issueToken; ECDSA.recover(...) == recipient else return false; only ecrecover in the source
- the signer is the receiving party, not the holder of the tokens; the sender moves its own tokens by its own call
- state at 26438999: balance 0, slot_0 = 0x396796de… (issue token), slot_1 = USDC; 0 txs in 90 days

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Recipient approves from an EOA or 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
