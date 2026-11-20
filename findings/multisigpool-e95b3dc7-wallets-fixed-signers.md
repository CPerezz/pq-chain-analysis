---
id: multisigpool-e95b3dc7-wallets-fixed-signers
title: "MultiSigPool: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe95b3dc78c0881dea17a69bafc6cfeb8d891e9de"
  family: "3185e14b0d003603b75578a63e7448f6"
  name: "MultiSigPool"
  label: "Apex: USDC Perpetual"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4269
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "pool operator (the three signers)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path, and only the operator's own liquidity is held (users' deposits pass through to StarkEx, and users keep the normal StarkEx withdrawal): MEDIUM. Value $4269, txs_90d 0; value does not lower the rating."
---

## Summary

MultiSigPool (StarkEx/ApeX-style fast-withdraw pool): withdrawETH, withdrawErc20 and factTransferErc20 need ≥2 ecrecovered signatures from 3 signers fixed in the constructor. The pool holds the operator's liquidity; on mainnet, user deposits are forwarded straight to StarkEx.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: MultiSigPool withdrawETH: each signature from the allowed signer it names; no function changes the signers / MultiSigPool withdrawErc20: as withdrawETH / MultiSigPool factTransferErc20: as withdrawETH. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source contracts/core/MultiSigPool.sol: signers written only in the constructor (exactly 3); every outflow uses ECDSA.recover against allSigners/isAllowedSigner; no owner, no setter, no proxy (runtime identical to the dossier)
- deposit(): on chainid 1 the USDC is approved and deposited into StarkEx 0xA1D5443F… in the same call, so user deposits are not held; the pool's balance is the fast-withdraw liquidity the operator puts there
- signers(0..2) (latest, block ~26452937; storage with no setter): 0x015155D9… EOA n0, 0x321072F3… EOA n0, 0xfA85BEA9… EOA n10

## Impact and exposure

- Value held at block 26,438,999: $4,269 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator withdraws the liquidity with the current signers before any signer key gets code, and deploys a new pool.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
