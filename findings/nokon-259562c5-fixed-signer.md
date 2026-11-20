---
id: nokon-259562c5-fixed-signer
title: "Nokon: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x259562c54c07aca61e12ee12c62016eaf3fd7852"
  family: "c74599a0b59fe13ec951255223527fd5"
  name: "Nokon"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 762
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Nokon operator"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path; locked ETH is the operator's own sale proceeds → MEDIUM. Side note: there is no replay protection (any old signature can be replayed by anyone), but ETH only goes to authAddress."
---

## Summary

transferEth, open/closePresell and getEthBalance require recover(hash,sig) to be in authorizedAddress, which only the constructor sets (deployer and 0x44F6…71dB). transferEth is the only ETH exit and pays authAddress.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Nokon presale: transferEth, open/closePresell need a signature of an authorised address set only in the constructor; the ETH is the operator's sale proceeds (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Nokon.sol l.49-56: authorizedAddress written only in the constructor; no setter
- l.232-240: transferEth recovers a signature over a caller-supplied hash and sends ETH to authAddress
- authorizedAddress(0x44F6827a…71dB) = true; its code is 0x today (deployer address not read)

## Impact and exposure

- Value held at block 26,438,999: $762 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator drains proceeds via transferEth while a key is an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
