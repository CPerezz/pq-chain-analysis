---
id: 15d64a67-fixed-signer
title: "0x15d64a67 (tagged FloppyNftErc1155:  Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x15d64a67b6836fc99f6934655338e98d454e7403"
  family: "85e17d836065215f28243bec79c13b1c"
  label: "FloppyNftErc1155:  Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 8
  last_active: 2026-10-30
fix:
  layer: new-deployment
  who_acts: "project owner (redeploys a new collection contract)"
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
  note: "The other constant, 0x2932...32b9, is not an address in use: it is the byte pattern of the SIG_WORD string, decoded as an address."
---

## Summary

The mint signer is a hard-coded constant EOA (it has 0 code bytes today), and nothing can replace it. If that account ever gets real code, signed mints stop working. No funds are locked, and existing NFTs can still be transferred.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- SIGNER declared as private constant 0x3f22e08C...1062
- matchAddresSigner returns SIGNER == hash.recover(signature), with no ERC-1271 or code check
- mint reverts with directMintDisallowed if the signature does not match
- Row facts: the signer constant has code_bytes 0 and delegated false

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-10-30.

## Remediation

Deploy a new contract with a replaceable signer or ERC-1271 support. Alternatively, keep the signer key's account an EOA (or only use 7702 delegation on it).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
