---
id: 2ad5866c-fixed-signer
title: "0x2ad5866c: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2ad5866ccac6f9b83baffd14bcc08169b1c59bbe"
  family: "733ad5d282da9ebf939bea1c4a1dfae7"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new contract. Drop creators revoke their allowances."
evidence:
  level: bytecode
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
  note: "Rated MEDIUM because only claims stop and nothing already held gets locked. The decompilation is rough, but the signer comparison and the transferFrom source are clear."
---

## Summary

The claim signer is a hard-coded constant with no setter. It is an EOA today. If that key's account gets code, claims stop working. No funds are locked, because drop tokens stay in the creators' wallets and are pulled only at claim time.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Claim 0x54313918: require(... == 0x3b44c7d2cd4a7a646c7eb9276812f4e874b1cbd6, "Invalid signature")
- constant signAddress = 338364313229182539503344731296005076510787619798 (the signer address in decimal)
- Verified: 0x3b44c7d2... is an EOA (no code)
- The only setter is transferOwnership, which changes the owner. There is no upgrade path.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be rotated or that also accepts ERC-1271 signatures. Drop creators move their allowances to the new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
