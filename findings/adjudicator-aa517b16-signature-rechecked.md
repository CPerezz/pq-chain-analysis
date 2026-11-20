---
id: adjudicator-aa517b16-signature-rechecked
title: "Adjudicator: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0xaa517b16caadc44b542c843aafcaf274f6965016"
  family: "566eb1b4858173a4448fee6683de8c2f"
  name: "Adjudicator"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "any.sender operator (new adjudicator)"
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
  rating: MEDIUM
  note: "The function dies but nothing is locked or paid on the signature = MEDIUM."
---

## Summary

This is the later any.sender Adjudicator (adds chainId), with the same requestCompensation check against the fixed receiptSigner. If that key takes code, customers cannot open compensation claims or lock the relay, but no funds are held or released by a verdict.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Adjudicator requestCompensation: a relay transaction the relayer signed earlier is held against it later. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/Adjudicator.sol: require(receiptSigner == recover(sig)); no setter; issueCompensation is voluntary and relayer-paid; lock() only sets a flag
- receiptSigner 0x02111c61... is an EOA at block 26438999; relay 0x9b4fa5a1...; compensationPeriod 180000
- No proxy slot or upgrade function; ETH balance 0
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

As 0x29c0.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
