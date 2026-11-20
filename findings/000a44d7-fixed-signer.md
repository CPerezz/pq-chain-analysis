---
id: 000a44d7-fixed-signer
title: "0x000a44d7 (tagged deployed by Elixir: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x000a44d75fb43f9f51d2b01e5318d2d14281a3ec"
  family: "c863ba7800d32ce0a92d4e1e6bb3b5cf"
  copies: 3
  label: "deployed by Elixir: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner (0x85f45b3ab65132b38b71e19ff9cf33106217a644) withdraws the funds and pays users some other way or redeploys"
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
  note: "The decompiled code does not show the signed deposit/claim functions themselves. The claim that they check the signature comes from the study note and the eip712Domain function. Rated MEDIUM because the owner can rescue funds."
---

## Summary

The signer is a hardcoded constant and is an EOA today. Nothing can replace it and there is no ERC-1271 path. If the key's account gets real code, signed deposit and claim stop working. The owner can still pull the funds out with emergencyWithdraw, so claims stop but nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant signer = 1231971171473759152554789838206052847791055910565 == 0xd7cb7f791bb97a1a8b5afc3aec5fbd0bec4536a5
- Verified facts: 0xd7cb...36a5 is an EOA with no code
- The only setters are transferOwnership/renounceOwnership, which write the owner slot
- emergencyWithdraw requires msg.sender == owner and does a SafeERC20 transfer to arg0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be rotated, or an ERC-1271 path. Until then the owner uses emergencyWithdraw to distribute funds by hand.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
