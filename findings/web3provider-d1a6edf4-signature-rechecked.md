---
id: web3provider-d1a6edf4-signature-rechecked
title: "Web3Provider: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xd1a6edf462875cd94a996885f71db41ffcef3dba"
  family: "33dfd4b734073d8d767ea65f4f5274b1"
  copies: 2
  name: "Web3Provider"
  upgradeable: "no"
  rating: NONE
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "No signature will ever be checked again at this address (already charged, timelock passed)."
---

## Summary

Web3Provider (2018): the provider redeems the client's signed request count with chargeService, but here charged == true and the timelock ended in December 2018, so chargeService can never run again.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Web3Provider chargeService: the client's signed request count is redeemed later by the provider. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Web3Provider.sol chargeService: require(charged == false); require(now <= timelock); recover == clientAddress
- at 26438999: charged true, timelock 1544786427 (2018-12-14), clientAddress 0x692d…e694
- the remaining 0.0009999 ETH goes back through withdrawDeposit() by clientAddress (msg.sender, no signature)

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
