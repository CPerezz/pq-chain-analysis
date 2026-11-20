---
id: a5ba9d68-wallets-fixed-signers
title: "0xa5ba9d68: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa5ba9d68890d0ba1c7d5c6d1ae9b2836a5c4f4f1"
  family: "a18900c9f985235c429b80aee0972d32"
  upgradeable: "no"
  rating: NONE
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "the wallet's owners (2 of 3) via a signed execute to the wallet itself"
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
  note: "The scanner's facts already listed the setter; the batch note's 'no function changes the owners' is wrong. Settable signer → refuted."
---

## Summary

A SimpleMultiSig variant with setOwners(uint256,address[]) (0xf3182e85), gated by require(msg.sender==address(this),'Sender must be this contract'). The owners can replace the signer set and threshold through a 2-of-3 execute call to the wallet itself, so the signers are settable.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- sels.txt: threshold, execute 0xa0ab9653, ownersArr, owners, nonce, setOwners; heimdall: setOwners requires msg.sender==this and emits OwnersSet; execute performs dest.call, so it can target the wallet itself
- at block 26438999: threshold=2, nonce=74, owners [0x175dcb0001bdc23d0da15dcbb6baf79da650d563, 0x3486ba63e1de3628ffa38b3497d55655de57195f, 0x8431d31b37f812819fc6e07e6ac9b88f6b45ac52], ETH balance 87961061 wei; 1967 slots 0
- cast code latest: all owners EOA (nonces 0/77/0)
- batch row: value_usd 2, txs_90d 0, last_active null, copies null

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before migrating owner keys to code, the owners use a signed execute to call setOwners with keys that will stay EOAs (or move the funds out).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
