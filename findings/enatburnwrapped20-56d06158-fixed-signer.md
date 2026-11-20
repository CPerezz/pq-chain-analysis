---
id: enatburnwrapped20-56d06158-fixed-signer
title: "eNATBurnWrapped20: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x56d06158bb8d2e42a6c5994a9a12a5c6d642f064"
  family: "13d7e4517f0b5a29474839b0599831b7"
  name: "eNATBurnWrapped20"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 26340
  last_active: 2026-11-18
  recoveries_14d: 101278
fix:
  layer: new-deployment
  who_acts: "operator"
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
  note: "No update path. Nothing is locked: holders can still withdraw and transfer, and the contract holds no backing, so only the mint function dies. Receipts that were signed but not yet redeemed are the operator's to make good off-chain."
---

## Summary

Deposit-minting needs an EIP-712 receipt from the immutable _protocolOperator 0x342b…0a21, and there is no setter or upgrade. If that key gets code, minting stops for good. Withdraw and transfer need no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: eNAT wrapper deposit: the receipt must be signed by _protocolOperator, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source eNATBurnWrapped20.sol:47 `address private immutable _protocolOperator`; _mint is reached only from _deposit after ECDSA.recover (lines 240-245)
- withdraw/batchWithdraw burn msg.sender's tokens with no signature
- cast code 0x342b…0a21 = 0x; ETH balance of the contract = 0; no EIP-1967 slots

## Impact and exposure

- Value held at block 26,438,999: $3 (ETH and 49 priced tokens).
- Activity: 26,340 transactions called it in the 90 days before that block; last on 2026-11-18.
- 101,278 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new wrapper with a rotatable or ERC-1271 signer, or keep the operator key as an EOA or 7702 delegation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
