---
id: 1712cf80-fixed-signer
title: "0x1712cf80: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1712cf8044e51eceba81f22c0c03cdd7eb404b1e"
  family: "7d137272f904637a3eb5ccbb7af50544"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 173
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/operator (would have to redeploy for a new signer)"
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
  note: "The study note says 'deposit and claim', but this code is an NFT mint sale. The only signature-gated function is buyWhitelist."
---

## Summary

The signer is immutable and is an EOA today (0x4444…8d62). If that key's account gets real code, only signed whitelist mints of new NFTs stop working. Nothing gets locked: the owner can still withdraw and public buy() stays open.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- address public immutable signer; constructor: signer = signer_
- _validateSignature: ECDSA.recover(digest,v,r,s) == signer, with no ERC-1271 or code check
- signer() getter = 0x444444cc7fe267251797d8592c3f4d5ee6888d62, EOA at block 26438999
- No setter for signer; upgradeable: no

## Impact and exposure

- Value held at block 26,438,999: $173 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new TokenTrader with a new signer, or with ERC-1271/SignatureChecker support and a signer setter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
