---
id: cc12532e-fixed-signer
title: "0xcc12532e: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcc12532e95c2a6a4c53af153b9b739a3cc9218a7"
  family: "bad887a91ec06fa7c7789d8588172097"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 228
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Clipper operator: redeploy with a new signer. LPs leave through burnToWithdraw."
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The study note calls this a presale, but the code is the Clipper exchange. I matched the signer by elimination from the bytecode address list: WETH is WRAPPER_CONTRACT and the 0x0000696e… value is string data. The source itself does not show which immutable holds which address, so reading the DESIGNATED_SIGNER() getter would confirm 0x0893…f1f8 directly."
---

## Summary

The only signer is the immutable DESIGNATED_SIGNER. Nothing can replace it, and there is no code check or ERC-1271 fallback. The only plausible address for it in the bytecode is 0x0893…f1f8, which has no code today. If that key's account ever gets real code, signed swaps, deposits and single-asset withdrawals stop. LPs can still get their proportional share out without a signature through burnToWithdraw and unlockDeposit, so nobody's money is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verifyDigestSignature: require(signingAddress==DESIGNATED_SIGNER)
- `address immutable public DESIGNATED_SIGNER`, set only in the constructor; no setter
- The bytecode pushes 0x08938a61…f1f8 (no code) and 0xc02aaa39… (WETH, the wrapper). 0x0000696e74… is ASCII text from a string ('int256 good_until)'), not an address.
- burnToWithdraw burns LP tokens and pays out a proportional share of every asset through _proportionalWithdrawal, with no signature

## Impact and exposure

- Value held at block 26,438,999: $228 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new pool whose signer can be rotated or that accepts ERC-1271 signatures. LPs exit the old pool through burnToWithdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
