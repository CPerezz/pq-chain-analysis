---
id: adjudicator-29c031b5-signature-rechecked
title: "Adjudicator: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x29c031b5d6978f9c1d85cdd252297d2c95d51fe8"
  family: "78da1c6c204b1a1bbcaa77311d93819b"
  name: "Adjudicator"
  label: "any.sender: Adjudicator"
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
  note: "It is a real re-check of an earlier signature, but the adjudicator holds no money and never pays out on a verdict; the customer loses only the ability to force a lock flag. The function dies with nothing locked = MEDIUM, not CRITICAL."
---

## Summary

requestCompensation checks a receipt that the fixed receiptSigner signed earlier. The customer relies on it to start a compensation claim against a late relayer. If the signer takes real code, the request reverts and lock() can never fire. No funds are escrowed: compensation only moves if the relayer voluntarily calls issueCompensation.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Adjudicator requestCompensation: a relay transaction the relayer signed earlier is held against it later. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/Adjudicator.sol: require(receiptSigner == recover(sig)); receiptSigner is set once in initialize with no setter; issueCompensation is payable by the relayer; lock() only sets a flag
- receiptSigner 0x02111c61... is an EOA (code 0x) at block 26438999; relay 0xa404d121...; locked false
- No proxy slot or upgrade function; ETH balance 0
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New adjudicator accepting ERC-1271, or keep the receipt key an EOA/7702 account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
