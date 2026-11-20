---
id: ninjasquadtoken-70bef3bb-rotate-signer-before-migrating
title: "NinjaSquadToken: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x70bef3bb2f001da2fddb207dae696cd9faff3f5d"
  family: "46871ddb4472e2d6f53cdf1448f4d610"
  name: "NinjaSquadToken"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1963
  last_active: 2026-11-17
fix:
  layer: new-deployment
  who_acts: "nobody on-chain (owner renounced)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "LOW does not hold: the setter is onlyOwner and the owner is 0. Only signed minting dies and nothing held is locked → MEDIUM."
---

## Summary

NinjaSquadToken ERC-20: mintWithSignature(...) needs a signature from the stored signer. If that signer takes code, signed minting stops, and nobody can replace the signer because ownership is renounced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- Decompiled setSigner (0x6c19e783) requires msg.sender == owner ('Ownable: caller is not the owner') (latest, block ~26452925, publicnode; code only).
- owner()=0x0 at block 26438999 (cast call on reth.dappnode, read before the node stalled), so setSigner can never be called again; the contract has no proxy or upgrade selector.
- mintWithSignature requires arg0 == msg.sender ('Not allowed'). Transfers, approve and claimLockedTokens do not use the signer, so no balance is locked behind it.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,963 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

None on-chain. Keep the signer key as a plain EOA, or redeploy the mint flow.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
