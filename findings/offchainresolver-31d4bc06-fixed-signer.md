---
id: offchainresolver-31d4bc06-fixed-signer
title: "OffchainResolver: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x31d4bc0685844232aae3507180b729620a98cb25"
  family: "4279b86c2b7557ff80226f08abfcc250"
  copies: 22
  name: "OffchainResolver"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "name owners can repoint their resolver"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path, but this resolves names only (no funds) and name owners can switch resolvers directly -> MEDIUM."
---

## Summary

ENS OffchainResolver.resolveWithProof requires SignatureVerifier.verify to recover a signer present in the `signers` mapping, written only by the constructor (no setter). It resolves no funds -- only CCIP-read name resolution for this one gateway -- and ENS name owners can always point their name to a different resolver contract if this one's signers break.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ENS OffchainResolver resolveWithProof: the gateway signer must be in a set written only by the constructor; resolution stops, no funds are held, name owners can point to a new resolver (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- OffchainResolver.sol:9,14-18,33-38: signers mapping set only in constructor, resolveWithProof requires signers[signer] (dossier source)
- SignatureVerifier.sol:29: ECDSA.recover(makeSignatureHash(...), sig) feeds the signer checked above
- no setter for `signers`; resolution is off-chain gateway data, no funds held

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 22 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Name owners set a new resolver (e.g. a fresh OffchainResolver) on their ENS record.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
