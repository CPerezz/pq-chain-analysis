---
id: ethescrowv2-3a362a19-own-signature-only-exit
title: "ETHEscrowV2: funds released only by the party's own signature"
status: confirmed
severity: MEDIUM
patterns: [PQ-16]
impact: liveness
contracts:
- address: "0x3a362a1966ff5aab35298e1565bda2c9fb124e41"
  family: "8343030030f4553952f8408c98f9bb4f"
  name: "ETHEscrowV2"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 46205
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25230
  last_active: 2026-11-18
  recoveries_14d: 5121
fix:
  layer: offchain
  who_acts: "the owner sweeps stuck trades with claimStuck after the delay and settles them off chain"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "as ERC20EscrowV2"
---

## Summary

`ETHEscrowV2` at `0x3a362a1966ff5aab35298e1565bda2c9fb124e41`. A dispute is resolved only with an ECDSA signature of the buyer or the seller, so a party whose address has code cannot have it resolved; the trade's ETH then leaves only through the owner's delayed sweep.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: trade escrow in ETH (function map, resolveDispute and claimStuck read): seller and buyer settle by their own call (release, buyerCancel) or by a relayed signature; a dispute can be resolved by the…. Read by hand. Executed: a real transaction reverts with code at the signer. Executed by hand: see Evidence.
- ETHEscrowV2 `0x3a362a1966ff5aab35298e1565bda2c9fb124e41` and ERC20EscrowV2 `0xccb2718d633ed28bdf0639134380e2f5b05162b5`: `resolveDispute` requires `signer == buyer || signer == seller`. Executed: resolutions `0x34e6fa77b3850be07f6a71491781750c6a792c81c1ef5a51e29e02a91aa1b117` (ETH) and `0x47b43aced505820e8d2224d965b3bdf2c6c8b079b64f7ff0ef7228f210482ea0` (USDT) revert with code at the signing party; the escrow then waits 180 days for the operator's sweep.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand: release and buyerCancel are direct; resolveDispute needs a party's signature.
- claimStuck (owner, after stuckDelaySeconds) moves a stuck trade's ETH without a party's signature.
- Executed: dispute resolutions 0x34e6fa77… (ETH) and 0x47b43ace… (USDT) revert with code at the signing party. 25,230 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $46,205 (ETH and 49 priced tokens).
- Activity: 25,230 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5,121 signature recoveries in the study's two-week trace window.

## Remediation

The owner sweeps and settles stuck disputes; a new version accepting ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
