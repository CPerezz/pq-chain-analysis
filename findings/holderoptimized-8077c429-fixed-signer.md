---
id: holderoptimized-8077c429-fixed-signer
title: "HolderOptimized: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8077c429401a25d6aa1029ee502ac0d0af3ff0f7"
  family: "9b30fdf59cb964c9c38ec7135ba24ff7"
  name: "HolderOptimized"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0x2035d330… (EOA)"
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
  note: "No update path; only rotation dies, and the owner's own funds still leave by direct onlyOwner calls. Arguably LOW, since the owner keeps every power."
---

## Summary

HolderOptimized time-lock wallet: the owner can be handed over only through setNewOwner, which needs the current owner's ECDSA signature (plus a password). If the owner address takes code, the handover dies, but the owner can still withdraw or rescue everything by direct call.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: HolderOptimized: the only way to hand the holder over is setNewOwner, which needs a signature of the current owner: a rotation that needs the retiring key. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- HolderOptimized.sol: setNewOwner recovers and requires signer == owner(); OwnableLimited has no public transferOwnership
- owner() at 26438999 = 0x2035d330eec1ccfa06337bbaac43df084165b89b, cast code 0x
- withdrawETH/withdrawERC20/withdrawNFT (after holdTime) and rescueETH/ERC20/NFT (password) are onlyOwner direct calls

## Impact and exposure

- Value held at block 26,438,999: $5,414 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner withdraws directly and moves the assets to a new holder.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
