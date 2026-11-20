---
id: erc20bridge-2a5a5358-fixed-signer
title: "ERC20Bridge: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2a5a53582b2e70f3157120eb6ec556dd3fe50c8d"
  family: "4e86c9ebe9d82c10a77a7bd6abd54991"
  copies: 2
  name: "ERC20Bridge"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 50
  last_active: 2026-11-11
  recoveries_14d: 35
fix:
  layer: new-deployment
  who_acts: "bridge deployer"
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
  note: "No update path, and users' deposits are released only by a signed call (HIGH)."
---

## Summary

ERC20Bridge: withdraw() releases deposited UNP only when the message is signed by validator 0x4740…7e1, which is set in the constructor and has no setter. If that key gets code, every deposit is locked: there is no other exit.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ERC20Bridge: a withdrawal must be signed by `validator`, set in the constructor, with no setter. If that key's account takes code, nobody can withdraw. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source ERC20Bridge.sol: validator is set only in the constructor; the only token exit is withdraw(), which requires recoverSigner == validator
- validator() = 0x474085D0…B7E1, no code at block 26438999
- token UNP 0x23d7…; the bridge's balance is 0 today (value never lowers the rating)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 50 transactions called it in the 90 days before that block; last on 2026-11-11.
- 35 signature recoveries in the study's two-week trace window.

## Remediation

Redeploy with a rotatable validator before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
