---
id: testpay-local-unlimit-b1b2c3fd-fixed-signer
title: "testpay_local_unlimit: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb1b2c3fda82979fa5639a334f695f5ff9f46395f"
  family: "5584044d703428a56c53cc993085e435"
  name: "testpay_local_unlimit"
  upgradeable: "no"
  rating: HIGH
  value_usd: 3125
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "holder of 0xc5D8…7A83 (do not give it code)"
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
  note: "HIGH: no update path, and depositors' ETH has no exit except the fixed key's signature. If that address takes real code, nothing gets the funds out."
---

## Summary

testpay_local_unlimit: attend() takes user deposits; the only way ETH leaves is unattend(), which needs a signature from the constant 0xc5D8f043b6a4983C8C2EE6A1eD5ca6bd35007A83. There is no owner, no setter and no upgrade.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: testpay: deposits (attend) leave only through unattend, which needs a signature of the constant address 0xc5D8f043b6a4983C8C2EE6A1eD5ca6bd35007A83; if that account takes code nothing can leave. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- CM712.sol: unattend requires decode(c1, …) == 0xc5D8…7A83 before who.transfer(amount); this is the only transfer in the contract
- No other function moves ETH; attend() is payable and requires !isc(msg.sender)
- 0xc5D8…7A83 has no code at 26438999 or today; balance 1.7317 ETH; source.json address = row address

## Impact and exposure

- Value held at block 26,438,999: $3,125 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep 0xc5D8… without real code (an EIP-7702 delegation still recovers), and drain the deposits through unattend before any migration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
