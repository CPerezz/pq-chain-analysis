---
id: withdraw-ed911640-signature-rechecked
title: "Withdraw: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xed911640fd86f92fd1337526010adda8f3eb8344"
  family: "f2f3ce650f187943bcf9fb76fdc6e5c9"
  name: "Withdraw"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "The only signature checked is the resolver's own, and the timeout fallback protects the initiator. The note's channel-state claim belongs to the mastercopy, not this definition."
---

## Summary

This is Connext Vector's Withdraw transfer definition (pure create/resolve). resolve() checks the responder's own signature, and only the responder can resolve before dispute expiry; after expiry the adjudicator returns the initial balance to the initiator. No party that relied on someone else's signature loses: if the responder's address takes code, only the responder's own resolution fails.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Connext Vector channel: a channel state, a withdrawal or a transfer resolution counts only with the signatures of the channel's two participants, fixed when the channel is made / Connext Vector…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify verified source (scratch review_agents/036/src) transferDefinitions_Withdraw.sol resolve(): an empty 65-byte sig cancels, otherwise checkSignature(responderSignature, state.responder)
- CMCAdjudicator.defundTransfer: before expiry it requires msg.sender == responder or a responder signature; after expiry balance = cts.balance (initial balance back to the initiator)
- this address has 3 functions, no storage and no funds; the channel-state co-signature mechanism is the ChannelMastercopy (0x8407ef1b…, rated in batch 026 via 0xf83e14ab)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None here.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
