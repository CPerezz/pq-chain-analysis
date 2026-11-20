---
id: eb984829-fixed-signer
title: "0xeb984829: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xeb98482971810109cebce54307b1745865f27d08"
  family: "64aec55b90fd8f0ed3361531b95de2f0"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (liveness only)"
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
  note: "No fund-moving function found in the decompiled contract; impact is liveness of voucher validation, not a fund lock."
---

## Summary

A voucher/emission-multiplier contract (`fly`/`pilot`/`signer` constants, `Unresolved_c60722f3` checks a 'voucher used' keccak+ECDSA signature) gated by a compile-time constant signer; EIP-8151 breaks voucher redemption once that address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile shows `uint256 public constant signer = 1147737677799113653774564405151370472984620494687;` (= 0xc90a5663326637d6c852258400ca9643ca4aef5f), same value as sibling 0x258c8552 but a different contract body (has an explicit ECDSA 's' value check in Unresolved_c60722f3)
- `cast code` on the signer address today -> 0x (EOA)
- facts.exits for this address = transferOwnership(address) only; the voucher function (Unresolved_c60722f3) only records usage/emissionMul, no ETH transfer visible

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix; redeploy with a replaceable signer before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
