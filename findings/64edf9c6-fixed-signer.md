---
id: 64edf9c6-fixed-signer
title: "0x64edf9c6: signer fixed in code"
status: confirmed
severity: CRITICAL
patterns: [PQ-17]
impact: funds-loss
contracts:
- address: "0x64edf9c69a046e84382f6df2a2a092bbe8c95988"
  family: "0df6abbc403be148276dee7fd7874b00"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "payer/owner and recipient must redeploy the channel"
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
  rating: CRITICAL
  note: "Rated CRITICAL even though money doesn't get stuck: the payer can still pull everything back with claimTimeout. The loss falls on the recipient, whose signed vouchers stop working."
---

## Summary

Signed vouchers are checked against the hardcoded payer EOA 0x1704…, and nothing can change that address. If the payer account gets real code, the recipient can no longer redeem vouchers it already holds. Meanwhile the payer can still start closure and take the whole balance back through claimTimeout. The recipient relied on the signatures and loses money it was owed.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- withdraw 0x030ba25d: require(var_s == 0x1704823eb2918d81c32fea00eff760d6499e24ff, "Invalid signature...")
- constant payer = 131407336641778645874974403986981604073492325631, which is 0x1704…; there is no storage slot for the signer
- transferOwnership changes only slot 0 (owner); the signer comparison uses the literal address
- claimTimeout sends the token balance to 0x1704…; 0x5548924e is gated by msg.sender == payer, so it does not use ecrecover

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Close the channel and redeploy with a verifier that accepts ERC-1271 or 7702 signatures, or that allows a replaceable signer. The recipient should redeem outstanding vouchers before the payer's account gets code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
