---
id: tapethhtlc-c6df985b-fixed-signer
title: "TapEthHTLC: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc6df985b9a20bc7e645c1abc847f732e53d6e815"
  family: "fcdbcc1e765e12df460afa15532b09a4"
  name: "TapEthHTLC"
  upgradeable: "no"
  rating: NONE
  value_usd: 102
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 52
  last_active: 2026-11-10
  recoveries_14d: 2
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "Code is checked first and ERC-1271 is accepted, so refuted. The reverting test tx used code without ERC-1271. TapPerpEscrow deployments, if any, need their own rows."
---

## Summary

The deployed contract is TapEthHTLC. Its only signature check, _isValidSignature, uses ecrecover only when signer.code.length == 0 and otherwise calls ERC-1271. The 'stored operator' certificate check belongs to TapPerpEscrow, a separate contract in the same compilation that this address does not run.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: swaps created by signature of the maker named: code first, then ERC-1271 (read); certificates of its escrow must be signed by a stored operator with no setter name. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify compilation target is TapEthHTLC.sol:TapEthHTLC.
- TapEthHTLC.sol 793-801: `if (signer.code.length == 0) return _recover(...) == signer;` else staticcall isValidSignature; _recover is called only there.
- TapPerpEscrow.sol (operator immutable, `_recover(digest, cert.signature) != operator`) is not this address's code.

## Impact and exposure

- Value held at block 26,438,999: $102 (ETH and 49 priced tokens).
- Activity: 52 transactions called it in the 90 days before that block; last on 2026-11-10.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
