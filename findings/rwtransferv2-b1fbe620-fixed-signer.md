---
id: rwtransferv2-b1fbe620-fixed-signer
title: "RWtransferV2: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb1fbe62078f1824ece46637ce26b78075988008e"
  family: "dc1a929be2e3b139efb3b2aa3b702977"
  name: "RWtransferV2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x623e8ee5FfE6Debfa1Be7C58210F00241A34290c"
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
  note: "Purchase gate dies for good but collected ETH is owner-withdrawable directly -> MEDIUM."
---

## Summary

RWtransferV2 whitelist NFT sale: whitelistMintNFT requires isWhitelisted (ecrecover vs constant WHITELIST_SIGNER), no setter. Collected ETH sits in the contract until owner calls withdraw() directly (no signature needed), so funds are not locked; only the whitelist-purchase path stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- RWtransferV2.sol: WHITELIST_SIGNER constant, isWhitelisted()/recoverSigner() (dossier source)
- RWtransferV2.sol: withdraw() public payable onlyOwner, no signature check
- owner()==0x623e8ee5FfE6Debfa1Be7C58210F00241A34290c at block 26438999 (cast call)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner redeploys a successor sale contract with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
