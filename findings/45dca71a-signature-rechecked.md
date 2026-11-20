---
id: 45dca71a-signature-rechecked
title: "0x45dca71a: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x45dca71aeb0ade9ebdd2f868f06f7d13d8e88b27"
  family: "c631b95bcf1ee64ecab9e4207399f7d7"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "Refuted: each signature is a single-use meta-transaction authorization guarded by a nonce, never re-checked after a counterparty relied on it, and no child wallet or funds exist. Any future child's funds move by direct accessor calls, not by signature."
---

## Summary

Not a Connext LedgerChannel and not a re-check after reliance. This is a factory/relayer with a global nonce: it verifies a one-shot user signature (c4dd3b33, 'User signature must be the same as signed message') and then calls addAccessor/removeAccessor on a child access-control wallet it can CREATE. It was never used: no child was ever deployed and no signed operation ever ran.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher has only 15f2226e, 1bf38b28, 7bcaf585, affed0e0 (nonce), c4dd3b33, db4ad99f; the 15f2226e/1bf38b28 paths check 'Wrong nonce' and call child 0x2ec9ad44 removeAccessor / 0xd1b33094 addAccessor. The transfer/withdraw selectors in the facts belong to the embedded child bytecode (runtime at byte 3903), not to this contract
- Child runtime (decompiled separately): accessor bitmask, bit 4 = admin (add/remove accessor), bit 8 = transferEth/transferTokens/withdraw/withdrawTokens, all by direct msg.sender calls
- At 26438999: contract nonce 1 (never CREATEd a child), storage slot 0 (signed-op nonce) 0, all low slots 0, balance 0; EIP-1967 slots 0
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
