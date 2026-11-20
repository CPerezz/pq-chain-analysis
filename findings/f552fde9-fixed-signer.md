---
id: f552fde9-fixed-signer
title: "0xf552fde9: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf552fde932b17fa11b6b33d93175fe3e495b4a58"
  family: "7cb08f12c4363a22c4cce0441c4ab60d"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-25
fix:
  layer: new-deployment
  who_acts: "The project owner would have to deploy a new mint contract, or mint for users through mintReserve, which is limited by reserve."
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
  rating: MEDIUM
  note: "The study note calls this a presale with deposit/claim, but the code is a free NFT mint. Only minting of new tokens depends on the signature."
---

## Summary

The signer address is a hardcoded literal with no setter, and today it is an EOA with 0 bytes of code. If that key's account ever gets real code, ecrecover stops matching and signed minting of new tokens stops. Nothing is locked: existing NFTs stay transferable and the owner can still withdraw ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- validateEligibilityKey returns ecrecover(...) == 0x20Ff11c0383C3E84D2D251Ab77eBBaD667c2964C, a literal constant
- constants[0].code_bytes = 0 and delegated = false, so the signer is an EOA today
- No function changes the signer; the setters listed are setOwnersExplicit and transferOwnership only
- mint() requires isValidMintKey; there is no price and no user deposit

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

The signer cannot be changed, so a broken key needs a new mint contract or owner mints through mintReserve. Keep the signer key a plain EOA (or 7702-delegated only).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
