---
id: ethescrowv2-3a362a19-signed-shortcut-lost
title: "ETHEscrowV2: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x3a362a1966ff5aab35298e1565bda2c9fb124e41"
  family: "8343030030f4553952f8408c98f9bb4f"
  name: "ETHEscrowV2"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 46197
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25230
  last_active: 2026-11-18
  recoveries_14d: 5121
fix:
  layer: new-deployment
  who_acts: "the owner releases stuck escrows with claimStuck after 180 days"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "A buyer or seller whose account has code can no longer ask for arbitration, and nothing else replaces that act; the owner's claimStuck still moves a stuck escrow after 180 days, so nothing is locked: MEDIUM, as for the other ETHEscrowV2 deployment."
---

## Summary

ETH trade escrow: seller release and buyer cancel can be relayed by signature, and arbitration needs a party's ECDSA signature; under EIP-8151 a party with code loses the relayed routes and cannot ask for arbitration.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: trade escrow in ETH (function map, resolveDispute and claimStuck read): seller and buyer settle by their own call (release, buyerCancel) or by a relayed signature; a dispute can be resolved by the…. Read by hand. Executed: a real transaction reverts with code at the signer.
- relay(): recovered signer must equal buyer (cancel) or seller (release) (ETHEscrowV2.sol:212-245); release() and buyerCancel() do the same acts by msg.sender (188-210)
- resolveDispute needs a buyer or seller ECDSA signature (285-327); claimStuck lets the owner move a stuck escrow to withdrawTo after stuckDelaySeconds (336-355)
- owner() at block 26438999 = 0x8E466Cdd9508103C12731E9243E2926A829033c9, EOA, nonce 22647; stuckDelaySeconds = 15552000 (180 days)
- createEscrow relayer signers are replaceable by the owner (setRelayerSigners, onlyOwner)

## Impact and exposure

- Value held at block 26,438,999: $46,197 (ETH and 49 priced tokens).
- Activity: 25,230 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5,121 signature recoveries in the study's two-week trace window.

## Remediation

Parties call release/buyerCancel directly; a disputed escrow with a code-holding party falls to the owner's claimStuck.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
