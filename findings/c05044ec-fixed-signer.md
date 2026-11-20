---
id: c05044ec-fixed-signer
title: "0xc05044ec: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc05044ec201cf745ad5fab394114c352a2b0e794"
  family: "59ca66d11449000e66fb6a62d5775c60"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner (0x5b57...3942, who is also the signer) withdraws the funds and redeploys."
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
  note: "The decompiled settle path is cut off, so the payout recipient is not visible. Before settlement the owner can withdraw everything, so no other party holds a guaranteed claim."
---

## Summary

The signer is a hardcoded constant EOA and nothing can replace it. If that key's account gets code, settlement stops working. The USDC belongs to the owner, who can still pull it out with emergencyWithdraw because the contract is not yet settled. So only the settle function stops and no money is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_39c2ebb9 requires ecrecover == 0x5b57d00ae520112d315e676821a6e405bcd73942, a literal in the code
- No function writes the signer. transferOwnership writes only the owner field of slot 0
- 0x5b57...3942 is an EOA at block 26438999 and is also owner()
- emergencyWithdraw: onlyOwner, require(!settled), transfers the USDC balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer the owner can rotate, or one that accepts ERC-1271 signatures. The owner uses emergencyWithdraw to move the funds there.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
