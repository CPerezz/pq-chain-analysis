---
id: 0dba77b0-signature-rechecked
title: "0x0dba77b0: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x0dba77b066816a8528dea8659a9896e2fdd798dc"
  family: "803f5b90cff2cc289dba353364cd0e0c"
  upgradeable: "no"
  rating: NONE
  txs_90d: 106
  last_active: 2026-11-06
  recoveries_14d: 31
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: executed
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
  note: "Refuted: the recovered value is the address of a computed point that no one can deploy code to, so only gas changes, and there is enough spare gas."
---

## Summary

No account signs here. 0x384381a6 checks a proof with curve arithmetic: it uses sha256 (0x02), MULMOD/ADDMOD over the secp256k1 field, and one call to ecrecover with r fixed to the contract's constant point 0x45fb126a… (fd6d21c9). The recovered address belongs to a computed curve point, not to an account. It is recorded in isProven(chainId,addr,addr,hash), which caller 0xcb1ccc31… (via impl 0x42bd3887…) and settler 0xe8e46518… check through ae0dd770 before paying out tokens. That address only stops matching if it has non-7702 code. It is the hash of a point, so that would take a keccak collision with a deployed contract (~2^80 work). The study's replay that reverted had code planted at that point address artificially. EIP-8151 only adds +3,100 gas cold, and the smallest spare gas seen in any frame is 32,729.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: a proof checker (31 recoveries) that accepts statements signed by recovered parties; who they must be is not established. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- trace 0x5d114860…8142: STATICCALL 0x01 input r = 0x45fb126a0d8abb18749bce3ac1c21457047c4aeaecf3afd2b0a4c0bbc7705725 (= constant fd6d21c9), v=0x1c, output 0x0f3cf927…, preceded by 3 sha256 calls
- scanner.json/facts.json: 6 MULMOD with the field prime, 'a key verified through the precompile without its own address being recovered'; gas kinds 'all'; min spare 32,729
- caller chain in the trace: 0xcb1ccc31 calls isProven then 0x384381a6, then 0xe8e46518 calls ae0dd770 (reverts NotProven if absent) and then ERC20.transfer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 106 transactions called it in the 90 days before that block; last on 2026-11-06.
- 31 signature recoveries in the study's two-week trace window.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
