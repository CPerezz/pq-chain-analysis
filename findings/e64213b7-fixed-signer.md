---
id: e64213b7-fixed-signer
title: "0xe64213b7: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe64213b7bfbcb14c2f9cdfdd55eabd5aef17f6aa"
  family: "1034f1617d4a70a6d542d285ca63d1aa"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-09-25
fix:
  layer: onchain-config
  who_acts: "The owner calls setMintState(PUBLIC) to switch to mint(), which needs no signature."
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
  note: "The signer address is inferred from the bytecode list because the immutable has no getter. It is the only push value that matches no source constant and is not a string fragment."
---

## Summary

The presale signer is an immutable that nothing can replace. The address that appears to hold it, 0x57a1…83ac, is an EOA today. If that account gets real code, presale mints stop working. No funds get locked: withdraw() and the public mint need no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source declares `address private immutable _ticketSigningAddress`, and the constructor assigns it
- preSaleMint: require(recoveredAddress == _ticketSigningAddress) uses OZ ECDSA.recover; there is no code check and no ERC-1271 path
- No function writes _ticketSigningAddress, and there is no upgrade path (upgradeable: no)
- Bytecode address 0x57a1c35204d9fd4142b679e79ffe54e2b97e83ac is not among the source constants (reserve addresses or string fragments), so it is very likely the immutable signer. It is an EOA with no code.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

Keep the signer key as a plain EOA. If it ever gets code, the owner can switch to setMintState(PUBLIC) or deploy a new contract with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
