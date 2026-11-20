---
id: 3b29c19f-fixed-signer
title: "0x3b29c19f: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3b29c19ff2fcea0ff98d0ef5b184354d74ea74b0"
  family: "223e5165ee09e5064e702b2f2e723778"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The protocol team would have to deploy a new controller. Users can't get their NFTs out of this one."
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
  rating: HIGH
  note: "I can't name the signer address: no getter value for oracleSigner was provided. As a Solidity immutable it is stored in the runtime bytecode, so it should be one of the constants listed in the row facts. Every one of those has code size 0 except the Uniswap factory, so the signer is very likely an EOA today. The study note's 'presale' description does not match the code."
---

## Summary

Every oracle-priced action checks against an immutable `oracleSigner`, and nothing can replace it. `removeCollateral` always calls `underwritePriceForCollateral`, even when the vault has no debt. If the signer key's account gets real code under EIP-8151, deposited NFTs can't be withdrawn, and there is no owner rescue and no upgrade path.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ReservoirOracleUnderwriter: `address public immutable oracleSigner;` is set only in the constructor.
- underwritePriceForCollateral: `if (signerAddress != oracleSigner) revert IncorrectOracleSigner();` with no code-size or ERC-1271 check.
- removeCollateral calls underwritePriceForCollateral(..., LOWER, oracleInfo, true) for i==0, without checking whether the vault has debt.
- No function writes oracleSigner. Setters in the row facts: only transferOwnership.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new controller whose oracle signer can be rotated (or which accepts ERC-1271 signatures), and add a way to withdraw collateral with zero debt that doesn't need the oracle. The current contract can't be fixed in place.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
