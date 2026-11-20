---
id: giraffles-eab0992b-fixed-signer
title: "Giraffles: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xeab0992b3d82b136e0eb3df5bb0d80b62a300cb2"
  family: "f0539256019c9d08022a0a2557435e90"
  name: "Giraffles"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
  last_active: 2026-09-25
fix:
  layer: new-deployment
  who_acts: "operator (owner 0x1c90081c…, live EOA)"
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
  note: "Signed NFT mint dying with nothing locked: MEDIUM, as the TheEveryones precedent. Near LOW since the public branch sells the same NFT."
---

## Summary

Giraffles (TheEveryones idiom): mintNFT(whitelist=true) needs a signature from the constant WHITELIST_SIGNER for the discounted price (0.02 ETH); if that key takes real code, the discounted whitelist mint dies. The regular mint (whitelist=false, 0.025 ETH) and the owner withdraw need no signature, and the contract holds 0 ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source Giraffles.sol: isWhitelisted only on the whitelist branch of mintNFT; the else-branch mints at `price` with no signature
- whitelistMinted 882 of 1200, salePaused false, totalSupply 1519 of 5000, price 0.025 ETH, whitelistPrice 0.02 ETH at block 26438999
- WHITELIST_SIGNER 0x8430e0b7… no code; owner 0x1c90081c… EOA nonce 155; balance 0, withdraw is onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

Owner can lower `price` to the whitelist price (setPrice) for everyone, or redeploy; the whitelist allowance itself cannot be restored.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
