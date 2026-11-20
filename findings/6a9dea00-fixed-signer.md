---
id: 6a9dea00-fixed-signer
title: "0x6a9dea00: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6a9dea00465e875ce9fcea70a67432a1d274973e"
  family: "e0d779e6726e8712208da0f18041c02c"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Harpie (deployer of a new vault)"
evidence:
  level: bytecode
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
  note: "No update path; only recipient rotation dies, and funds still leave through the recipient's direct withdraw, so nothing is locked."
---

## Summary

older Harpie Vault variant (no WithoutFees functions): changeRecipientAddress needs a signature from the immutable serverSigner. If that key takes code, users cannot rotate their recipient; withdrawals by the registered recipient still work.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: EthBridge bridgeIn: the voucher must be signed by CANISTER, an address fixed in the code. Same code idiom as template 496eb5b1, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors: changeRecipientAddress, setupRecipientAddress, withdrawERC20/721, logIncoming*, withdrawPayments; no EIP-1967 slot
- serverSigner is immutable (Vault.sol: recover(...) == serverSigner, no setter); value in runtime code 0xd06470c8358bc33d4fad5e2657170880b2ad0938, cast code 0x (EOA)
- Way out without the signature: withdrawERC20/withdrawERC721 by the user's registered recipient (direct call); setupRecipientAddress (one-time) needs no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new vault whose server key can be rotated; existing deposits leave through the registered recipient.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
