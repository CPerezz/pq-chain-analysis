---
id: remotedomaindepositor-36a8e347-rotate-signer-before-migrating
title: "RemoteDomainDepositor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x36a8e347006e151f4a0e9559fea239439611777a"
  family: "f68e5698229f43049ee66b5d9ab29081"
  copies: 6
  name: "RemoteDomainDepositor"
  upgradeable: "yes"
  admin: "0x8888888199b2Df864bf678259607d6D5EBb4e3Ce (owner() = EOA 0x1117Ba72…)"
  rating: LOW
  txs_90d: 2949
  last_active: 2026-11-18
  recoveries_14d: 630
fix:
  layer: onchain-config
  who_acts: "domainManager 0x1D6DDdDae56E9C6AB44ACa83ba2A16B295B362ce, or owner proxy 0x8888888199b2Df864bf678259607d6D5EBb4e3Ce (owner() = EOA 0x1117Ba72A62fCC6aE5a9bb31A54A7879F4f1Dbd2)"
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
  note: "LOW: setters exist with live parties. The domain manager EOA has never sent a tx (nonce 0), but the owner path through 0x8888…/0x1117 (EOA nonce 9) can replace it. The internals of 0x8888's implementation 0x7d817ce4… were not read; its owner() was read."
---

## Summary

RemoteDomainDepositor (UUPS proxy, implementation 0x0093a77b…): a quorum of enabled attesters must sign. Under EIP-8151 attesters with real code stop counting toward the threshold.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (validator, attester, author, oracle), distinct or ordered; a quorum or weight is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- source Attestable.sol:220,229,258 enableAttester/disableAttester/setSignatureThreshold are onlyDomainManager; DomainManageable.sol:80 updateDomainManager onlyOwner; RemoteDomainDepositor.sol:56 _authorizeUpgrade onlyOwner
- At block: proxy implementation slot = 0x0093a77b…; owner() = 0x88888881… (an ERC1967 proxy whose owner() = 0x1117Ba72…, EOA nonce 9)
- domainManager() = 0x1D6DDdDa… (EOA, nonce 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 2,949 transactions called it in the 90 days before that block; last on 2026-11-18.
- 630 signature recoveries in the study's two-week trace window.

## Remediation

The domain manager enables new attesters and disables old ones before an attester account takes code; the owner can replace the manager or upgrade.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
