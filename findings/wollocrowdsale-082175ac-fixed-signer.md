---
id: wollocrowdsale-082175ac-fixed-signer
title: "WolloCrowdsale: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x082175acd3f19561c4fa616075e0dcfaa5b2d47f"
  family: "bfd21ba020f5b74d50261a36ac2d3a28"
  copies: 14
  name: "WolloCrowdsale"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "no funds held between transactions"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Purchase gate only, no funds held between calls -> MEDIUM."
---

## Summary

Eidoo KYCBase crowdsale: buyTokens/buyTokensFor require a KYC-signer signature (isKycSigner mapping set only in the constructor, no setter). Each successful purchase forwards wei straight to `wallet` in the same call (releaseTokensTo -> wallet.transfer), so no funds sit in this contract between purchases; if the signer's address gets code, only new purchases stop.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Eidoo KYCBase buyImplementation: purchases need a KYC signer set in the constructor; a crowdsale purchase gate only (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- WolloCrowdsale.sol/KYCBase.sol: isKycSigner[kycSigners[i]]=true set only in constructor; buyImplementation requires isKycSigner[ecrecover(...)] (dossier source)
- WolloCrowdsale.sol:releaseTokensTo: require(token.transferFrom(wallet,buyer,tokens)); wallet.transfer(weiAmount) -- immediate forward, not escrow
- no setter for isKycSigner anywhere in KYCBase.sol

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 14 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator deploys a new crowdsale contract with a fresh KYC signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
