---
id: f4d4e4ae-fixed-signer
title: "0xf4d4e4ae: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf4d4e4ae7fd9cbafc24b9b0da2596260c8368314"
  family: "5d903bb793096f08350ac8884f9f0259"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The papr team would need a new deployment. The Reservoir oracle key holder must not put real (non-7702) code on the signer account."
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
  note: "The study note calls this a presale, but the code is the papr lending controller. The rating is HIGH because users' NFT collateral can only be withdrawn with the oracle signature. The signer address was matched by elimination among the EOAs found in the bytecode (immutable values) and is not shown in the source."
---

## Summary

The oracle signer is an immutable stored in bytecode and no function can replace it. The matched signer address is an EOA with no code today, and the contract has no ERC-1271 or code check. If the key gets real code, ecrecover fails and removeCollateral always reverts. Users' deposited NFTs then stay locked with no owner rescue and no upgrade path.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ReservoirOracleUnderwriter: `address public immutable oracleSigner;` is assigned only in the constructor
- underwritePriceForCollateral: `if (signerAddress != oracleSigner) revert IncorrectOracleSigner();` and there is no isValidSignature or code check
- removeCollateral always calls underwritePriceForCollateral(..., LOWER, oracleInfo, true) before _removeCollateral, even when debt is zero
- No other function in PaprController moves collateral NFTs out except the liquidation paths, which are also signature-gated

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

There is no on-chain fix. The signer key must stay an EOA or only ever use a 7702 delegation, never real code. Otherwise deploy a new controller with a replaceable signer or ERC-1271 support, and have users withdraw their NFTs before any change to the key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
