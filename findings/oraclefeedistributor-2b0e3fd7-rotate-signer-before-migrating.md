---
id: oraclefeedistributor-2b0e3fd7-rotate-signer-before-migrating
title: "OracleFeeDistributor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2b0e3fd77e061769904b71dce0ee336bf3eb1543"
  family: "b6d60def0c789fbda4f9ef01a9978793"
  copies: 377
  name: "OracleFeeDistributor"
  upgradeable: "no"
  rating: LOW
  value_usd: 10466
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0x588ede4403df0082c5ab245b35f0f79eb2d8033a"
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
  note: "The operator key is replaceable by a live EOA owner: LOW."
---

## Summary

The P2P OracleFeeDistributor clone acts as an ERC-4337 account whose user-op signer must be operator() or client(). A signer with code fails validation.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- Erc4337Account.sol:77-80 recover == operator()
- client(); OwnableWithOperator.sol:79 changeOperator onlyOwner
- owner()=0x588e…033a: EOA, nonce 4703; operator()=0x0; client()=0xA989…3034 (EOA) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $10,466 (ETH and 49 priced tokens, over 377 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner sets an EOA operator via changeOperator; the 4337 path is a convenience only.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
