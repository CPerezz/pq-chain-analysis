---
id: verifyingpaymaster-6a6b7f60-fixed-signer
title: "VerifyingPaymaster: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739"
  family: "16c5cbb60cfd99923c2c0d9d94630478"
  copies: 9
  name: "VerifyingPaymaster"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 16
  last_active: 2026-11-10
  recoveries_14d: 22
fix:
  layer: new-deployment
  who_acts: "paymaster owner"
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
  note: "No update path; only the operator's own deposit is at stake, and the owner moves it directly: MEDIUM."
---

## Summary

eth-infinitism VerifyingPaymaster (EntryPoint v0.7): `immutable verifyingSigner` 0xff294746…, which is also the owner. If that key takes code, sponsorship dies. The owner still withdraws its 0.024 ETH deposit and stake with withdrawTo/withdrawStake by direct call.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: VerifyingPaymaster: the signer must be verifyingSigner, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- VerifyingPaymaster.sol:25,83: verifyingSigner immutable, compared to ECDSA.recover; no setter.
- verifyingSigner()=owner()=0xff29474634b6…, an EOA (cast).
- getDeposit()=2.416e16 wei; withdrawTo/withdrawStake are onlyOwner with no signature (BasePaymaster.sol).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 16 transactions called it in the 90 days before that block; last on 2026-11-10.
- 22 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new paymaster and withdraw the deposit.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
