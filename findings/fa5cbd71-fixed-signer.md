---
id: fa5cbd71-fixed-signer
title: "0xfa5cbd71: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfa5cbd7199f9098cb464d2ddc2c3eff7f20f533a"
  family: "0f3b2ceec07fcd3db9da92d3e447fd7d"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner: calls stopPresale to open the public mint, or redeploys for deconstruct/reconstruct"
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
  rating: MEDIUM
  note: "The study note calls this a presale with deposit/claim, but it is actually an NFT mint. pause() and unPause() have no access control, so anyone can call them; the contract is paused right now."
---

## Summary

The only accepted signer is the constant ticket_signer, an EOA with no code today, and nothing can replace it. If that account gets code, signed presale/free mints and deconstruct/reconstruct stop working. No ETH is locked (the owner can drain it) and NFTs stay transferable. Deconstructed dolls could not be reconstructed.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dolls.sol: address constant ticket_signer = 0xD68a149D5646277cB271E283537b8A9C60D8A32f
- presaleMint/deconstruct/reconstruct: require(ticket_signer == signer, "wrong signer") after a raw ecrecover
- Row facts: the constant has code_bytes 0 and is not delegated; upgradeable: no
- No function writes ticket_signer; the only setter is transferOwnership

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the ticket_signer key as a plain EOA (or 7702-delegated). Otherwise the owner can call stopPresale to open the public mint, and redeploying is the only way to bring back signed deconstruct/reconstruct.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
