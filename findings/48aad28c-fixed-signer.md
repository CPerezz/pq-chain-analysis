---
id: 48aad28c-fixed-signer
title: "0x48aad28c: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x48aad28c33a1bd93c2efb0c902d0b5be7d4e9d7b"
  family: "073a2ae7b6b9fb377445ff5a3678e922"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "The operator who holds the hotwallet key must keep that account free of real code (a plain EOA or an EIP-7702 delegation only)."
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "The signer is the owner of the funds-moving path, so a lost signature locks user deposits. Separately, the contract is not upgradeable, so a new deployment cannot recover bids already held here."
---

## Summary

The signer is a hardcoded constant that cannot be replaced. On-chain it has no code today and is not delegated, so it is a plain EOA. Users' escrowed ETH can only leave through cancelBid or claimBid, and both need a signature from this key. If the key's account gets real code, ecrecover stops returning it, and every reserved bid is locked with no owner rescue and no upgrade path.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address constant hotwallet = 0x1B93...A705` is compared in isSigned()
- Row facts: constant code_bytes=0, delegated=false
- cancelBid: require(isSigned(cancel,...)) comes before the refund msg.sender.call{value: bid.amount}
- claimBid: require(isSigned(claim,...)) comes before the payout

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the hotwallet key an EOA and never put real code on it; a 7702 delegation is acceptable. Use the key to sign cancelBid for any open bids so users can get their ETH back. Any future version should allow the signer to be rotated and should add a refund path that needs no signature, such as one that opens after a timeout.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
