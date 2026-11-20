---
id: 1b031b4a-fixed-signer
title: "0x1b031b4a: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1b031b4a2606dd9ac39519d5b50ec64b1ce36d09"
  family: "386cabdde50165654a2dff6c6b8c5604"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner (0x3252925029cb25bdc753311a140029fe985b4b8a) withdraws the funds and redeploys with a new signer."
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
  note: "The decompiled signature path is partly garbled. The signer was identified as the only address constant that sits next to the signature check. Users' deposits are not locked because the owner can withdraw all of them."
---

## Summary

The signer is a hard-coded constant EOA and no function can replace it. If that key's account gets real code, signed deposits and claims stop. The owner can still pull all ETH and tokens through the withdraw functions, so only a function stops and nothing is locked. The withdrawn ETH goes to the fixed address 0x518acaf4…9d.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The constant 0xd410910e6cdec5975fa8d46e575af3c3ebb0ca3d appears in Unresolved_8ff0018f next to the 'invalid signature' and 'deadline expired' reverts. Its code_bytes is 0 (EOA, not delegated).
- The only setter is transferOwnership(address), which writes the owner slot (0x33), not the signer.
- No proxy and no upgrade function (upgradeable: no).
- withdrawEther(): onlyOwner, sends address(this).balance to 0x518acaf4658ec61abe35b5566cff18c6f19cab9d.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new version with a signer that can be rotated, or that accepts ERC-1271 / 7702-aware verification. Until then, the owner should withdraw the funds through withdrawEther/withdrawToken.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
