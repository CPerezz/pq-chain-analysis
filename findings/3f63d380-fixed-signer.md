---
id: 3f63d380-fixed-signer
title: "0x3f63d380: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3f63d380987f5d7c65b31a2a9d99bc2c446f920b"
  family: "4a64ed9b7f9a35aa1e769cbbd398c809"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Deployer/owner would need to redeploy; users cannot claim"
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
  note: "The study note calls this a presale, but the code shows a signed token airdrop claim (claim()) and no deposit path. owner() currently returns 0, so ownership has been renounced: burnUnclaimed can no longer be called, and unclaimed stock would simply stay in the contract. This is still operator-minted stock, not user money, so the rating stays MEDIUM."
---

## Summary

claim() only accepts signatures from the hardcoded constant signer 0xfB07…26df. That address has no code today, and the contract has no setter and no upgrade path, so the signer can never be changed. If that key's account ever gets real code, claims stop working. Only operator-minted airdrop stock is affected, and the owner can still deal with it through burnUnclaimed. User funds are not locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- claim(): require(ECDSA.recover(message, signature) == address(0xfB07a2Dc7C34E1d723f14a5Bb2f116064DcD26df))
- row facts: constant 0xfb07...26df has code_bytes 0 and is not delegated
- No signer setter exists; the only setter, transferOwnership, changes the owner, not the signer. upgradeable: no
- Constructor mints CLAIM_SUPPLY to address(this), so the claim stock is operator-minted; burnUnclaimed is onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be updated, or accept ERC-1271 signatures; the old claim stock would be distributed off-chain or through a new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
