---
id: rwtransfer-137e2a21-fixed-signer
title: "RWtransfer: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x137e2a21b41f73e112321c0a13671f39569cf326"
  family: "8aa444f1c564f789e227a5bb8dab3073"
  name: "RWtransfer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (owner/vault 0xb2c7c59f…, live EOA)"
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
  note: "Only the operator's own stock (NFTs in its vault) is involved and nothing is locked: MEDIUM. Currently paused by the owner, but the owner can unpause, so not closed for good."
---

## Summary

RWtransfer (TheEveryones idiom, a sale contract, not a mint): whitelistMintNFT sells NFTs out of the operator's vault 0xb2c7c59f… via safeTransferFrom, only with a signature from the constant WHITELIST_SIGNER. If that key takes real code, the sale dies; the NFTs stay in the vault and the contract holds 0 ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source RWtransfer.sol: whitelistMintNFT is the only sale path and the only ecrecover user; WHITELIST_SIGNER constant; withdraw onlyOwner
- at block 26438999: salePaused true, currentId 2717 of maxAvailableId 2832, owner = vaultAddress = 0xb2c7c59f… (EOA, nonce 872), ETH balance 0
- WHITELIST_SIGNER 0x8430e0b7… has no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The vault owner can sell or hand out the NFTs directly, or deploy a new sale contract with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
