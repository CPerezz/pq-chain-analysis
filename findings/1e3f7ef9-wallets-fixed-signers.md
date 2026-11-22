---
id: 1e3f7ef9-wallets-fixed-signers
title: "0x1e3f7ef9: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1e3f7ef938d6ffb72af25f9312d09812c9e3fcf4"
  family: "3936a33e79ab2443dab93bdb6e103a16"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 90
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's owners (1 of 2 EOAs) together with the fixed executor EOA"
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
  verdict: confirmed
  rating: HIGH
  note: "Fixed owners, no other exit: HIGH. Same owners and executor as 0x4b8e… and 0x4dc0… (one operator's set of wallets)."
---

## Summary

The same executor-gated SimpleMultiSig v1 variant as 0x5a40…, as a separate bytecode. msg.sender must be the fixed executor, plus 1 signature from the 2 fixed owners. There is no setter, so the 0.05 ETH is locked once both owner keys take code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: only non-view function 0xf12d394f; executor/'no-permission', 'number-of-sig', ecrecover owner check; 'Ethereum Signed Message' prefix in bytecode; no setter, no proxy slots
- at block 26438999: threshold=1, nonce=0, owners [0x0ae5c01e5ef595906416038089471066667fde2b, 0x4e94ea3e321a1191bcb3da144bfed9469a1fb852], executor 0xe70df3d93410c662014bda80706f48fe714b76b4, balance 0.05 ETH
- cast code latest: owners EOA (nonce 0); executor EOA (nonce 584)
- batch row: value_usd 90, txs_90d 0, last_active null, copies 2

## Impact and exposure

- Value held at block 26,438,999: $90 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Executor submits a final execute signed by one owner that moves the funds out, before both owner keys take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
