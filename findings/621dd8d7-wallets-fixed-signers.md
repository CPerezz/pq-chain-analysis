---
id: 621dd8d7-wallets-fixed-signers
title: "0x621dd8d7: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x621dd8d71526d7df51fa1aa8d098f5eaec81c573"
  family: "bc7707498252227d8af27c5d08e1cd87"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted: signer is whoever authorizes (per-call account, like permit), not a key fixed in the contract; rules are role-configurable. Initializer state at 26438999 not read (RPC timeouts) but does not change the verdict. Batch row: value_usd null, txs_90d 0, last_active null."
---

## Summary

Unverified 'ApprovalFlow' contract (contractName constant), OZ-upgradeable style with AccessControl: signed authorizations (EIP-3009-like authorizationStates, nonce per account, validAfter/validBefore) are checked against the per-call account arg, and approval rules are configured by a role holder. No fixed signer; holds no funds.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompile: 0x0c040708(address from,…,validAfter,validBefore,nonce,sig) marks authorizationStates[from][nonce] and recovers against `from` (caller-supplied)
- Rules mapping written by 0xa159d7da gated by role 0x503cf060…; DEFAULT_ADMIN_ROLE/hasRole present; initializer 0x4163dee3 (OZ Initializable namespace)
- Balance $0 per etherscan cache; no ETH-holding logic besides forwarding

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
