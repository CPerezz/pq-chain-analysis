---
id: d46550dc-fixed-signer
title: "0xd46550dc (tagged Cool Monkes: CMBSTS Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd46550dc5cb0ff6e4d904926917fe31a73bb336f"
  family: "5f006d7be690db4eb79a353e64b7ea85"
  label: "Cool Monkes: CMBSTS Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 9
  last_active: 2026-11-02
fix:
  layer: new-deployment
  who_acts: "The project team would need to deploy a new mint contract with a signer that can be changed."
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
  note: "The study note's presale \"deposit and claim\" description does not match the code. The code is a signed NFT mint with no deposits."
---

## Summary

The signer is a hardcoded constant and has no code today (an ordinary account). If that account ever gets real code, signed mints of new boost NFTs stop. Nothing already held is locked, because NFTs already minted stay freely transferable.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public constant enforcerAddress = 0xD8A7...99CE` in BoostPasses.sol
- mint() requires verify(enforcerAddress, ...) == true
- recoverSigner uses a raw ecrecover, with no code check and no ERC-1271 path
- Row facts: constant 0xd8a7...99ce has code_bytes 0 and delegated false

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

Redeploy the minter with a signer the owner can rotate, or with ERC-1271 support. The existing contract cannot be fixed in place.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
