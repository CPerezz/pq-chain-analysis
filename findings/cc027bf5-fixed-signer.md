---
id: cc027bf5-fixed-signer
title: "0xcc027bf5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcc027bf599f5b22688b4474d9f77fed6a012778b"
  family: "5502e05d452aade8beb68a22bd0e21e9"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (DEFAULT_ADMIN_ROLE / wallet owner)"
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
  note: "No update path, but the contract holds no money by design (it pulls from the operator's wallet), so the dead function locks nothing."
---

## Summary

Signed token-claim helper (trustedSigner, pids, alreadyWithdraw, token, wallet): a claim signed by the immutable trustedSigner pulls tokens from the operator's wallet with transferFrom. If trustedSigner takes code, claims stop; the contract holds no tokens.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: EthBridge bridgeIn: the voucher must be signed by CANISTER, an address fixed in the code. Same code idiom as template 496eb5b1, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Not the EthBridge code: selectors are trustedSigner, setToken, wallet/setWallet, pause, AccessControl roles, signed withdraw; no EIP-1967 slot
- trustedSigner 0xa80749450a6134fcdd9a2657460916b78be855c5 appears as an immutable in the runtime code, is in no storage slot 0-39, and has no setter; cast code 0x (EOA)
- Contract balance of token (MOCKSUPER 0x0Df6e300…) is 0; the wallet (0xb2D216D4…) holds the tokens and approved this contract. The only transfer in the code is transferFrom (no transfer selector)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator revokes the allowance and deploys a new claim contract with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
