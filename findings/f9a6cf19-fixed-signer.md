---
id: f9a6cf19-fixed-signer
title: "0xf9a6cf19: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf9a6cf1943fc9320bcda0bb09055b37f464f0b2f"
  family: "58bdeed6c07c17900f817469ef949249"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The campaign owner/creator (redeploys with a new operator and withdraws the funds)"
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
  note: "The study note says presale, but the source is a ReferralCampaign with no user deposits. The row facts do not give the operator's code size. The operator signs with a private key, so its account can only hold a 7702 delegation, not regular code (barring a practically impossible address collision); treated as an EOA."
---

## Summary

The signer is an immutable operator with no setter, no code check and no upgrade path. If the operator key gets real code, claims stop, but the owner can withdraw all reward tokens, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable operator;` assigned in the constructor
- _verifyAndConsumeNonce: `address signer = ECDSA.recover(hash, signature); if (signer != operator) revert ERC2612InvalidSigner`
- operator() getter = 0x28a24e5c432d5b828259ef2b1cc1bcd326996252
- withdraw(address) onlyOwner transfers the full balance of any token or ETH to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new campaign with a new operator key (or one that accepts ERC-1271 signatures), using withdraw() to move the remaining rewards. Until then, keep the operator key free of non-delegation code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
