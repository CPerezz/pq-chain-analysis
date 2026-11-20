---
id: 70b7c919-fixed-signer
title: "0x70b7c919: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x70b7c91980cc44e2e3a7a3be28f8603815cc3b8e"
  family: "4d9580b703f3183b08a1b8db5c153511"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project owner: redeploy, or run public sale / owner mint instead"
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
  note: "Only the mint of new NFTs stops. Nothing already held is locked."
---

## Summary

The coupon signer is a hardcoded constant EOA with no setter. If it gets code, presale and coupon mints stop working. No funds get locked: ETH is paid at mint time, withdraw() lets the owner take the balance, and public mint (phase 2) and owner mint still work.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- mintPresale 0xcd923b84: require(address(var_s) == 0xfb4c5a218552f77793aa49d482b8fba529eca278, "Invalid coupon")
- 0x7ef673f2: same constant check
- The verified facts list 0xfb4c5a21... as an EOA (no code)
- Only setter is transferOwnership, which touches the owner (store_a), not the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key free of non-7702 code, or deploy a new contract with a settable signer. Existing contract: use the public sale phase or the owner mint instead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
