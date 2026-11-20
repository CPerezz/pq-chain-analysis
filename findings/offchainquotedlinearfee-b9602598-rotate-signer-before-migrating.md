---
id: offchainquotedlinearfee-b9602598-rotate-signer-before-migrating
title: "OffchainQuotedLinearFee: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb96025987c0c10c751517fd2ccf5767245b027bc"
  family: "c94bac45ba991530c522bbcc6f8cfac3"
  copies: 130
  name: "OffchainQuotedLinearFee"
  label: "deployed by KiiChain: Deployer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 14519
  last_active: 2026-11-18
  recoveries_14d: 2047
fix:
  layer: onchain-config
  who_acts: "owner 0x1cfd…6e1e (EOA with 7702 delegation)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "setter callable by a live EOA."
---

## Summary

OffchainQuotedLinearFee: fee quotes signed by a stored quote-signer set.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- OffchainQuotedLinearFee.sol:144 addQuoteSigner / :148 removeQuoteSigner onlyOwner; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x1cfd6a81… EOA (7702-delegated), nonce 1918

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 130 addresses).
- Activity: 14,519 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,047 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key with the setter before the signer's account takes non-delegation code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
