---
id: 4c990630-fixed-signer
title: "0x4c990630 (tagged deployed by Sidus Heroes: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4c99063015b02275aff16ed40965ee4eacd61d66"
  family: "18722cae33dc5dc3ea4fe479ef4e70f4"
  copies: 2
  label: "deployed by Sidus Heroes: Deployer"
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
- trustedSigner 0x10613f1b1d3e221cfa136655d07838ba5fa2e1e8 appears as an immutable in the runtime code, is in no storage slot 0-39, and has no setter; cast code 0x (EOA)
- Contract balance of token (SIDUS 0x549020a9…) is 0; the wallet (0x887D79A1…) holds the tokens and approved this contract. The only transfer in the code is transferFrom (no transfer selector)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator revokes the allowance and deploys a new claim contract with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
