---
id: bibtransfer-cb4196f9-fixed-signer
title: "BIBtransfer: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcb4196f9fe511f16d00235e4a958f6c2f1089945"
  family: "e125d55898a2e4457f9bd5586b8d416c"
  name: "BIBtransfer"
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
  note: "Same mechanism as RWtransferV2: purchase gate dies, funds owner-withdrawable -> MEDIUM."
---

## Summary

BIBtransfer whitelist NFT sale (identical logic to RWtransferV2, same WHITELIST_SIGNER constant, same owner): whitelistMintNFT needs isWhitelisted, no setter. Owner withdraw() moves collected ETH out directly without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- BIBtransfer.sol: WHITELIST_SIGNER constant 0x8430e0B7be3315735C303b82E4471D59AC152Aa5, isWhitelisted()/recoverSigner() (diff against RWtransferV2.sol shows only cosmetic renames)
- BIBtransfer.sol: withdraw() onlyOwner, no signature check
- owner()==0x623e8ee5FfE6Debfa1Be7C58210F00241A34290c at block 26438999 (cast call)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner redeploys a successor sale contract with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
