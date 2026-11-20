---
id: zklink-35d173cd-signed-shortcut-lost
title: "ZkLink: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x35d173cdfe4d484bc5985fda55fabad5892c7b82"
  family: "2fd072fc11ed656fb34030a87dc54c22"
  copies: 2
  name: "ZkLink"
  label: "zkLink Nova: Proxy"
  upgradeable: "yes"
  rating: LOW
  value_usd: 7606942
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5963
  last_active: 2026-11-18
fix:
  layer: account-migration
  who_acts: "the L2 account owner"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Same act (authorise ChangePubKey) open by the owner's own call → LOW. Periphery body read by selector only."
---

## Summary

zkLink Nova main contract: ChangePubKey authorisations by L1 signature are checked at block commit; an owner with code fails the signature check.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: zkLink ChangePubKey by signature: the L1 owner must have signed; the same change can be authorised by the owner's own L1 call (auth facts) / zkLink _executeWithdraw: no signature here (matched on a…. Read from source.
- ZkLink.sol:233-239: an empty ethWitness falls back to stored authFacts[owner][nonce]
- setAuthPubkeyHash(bytes,uint32) (0x595a5ebc) is present in the periphery 0x070fc04f…284f code at block 26438999 (cast code); in zkSync v1 it writes authFacts for msg.sender
- proxy is upgradeable (row)

## Impact and exposure

- Value held at block 26,438,999: $7.6M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 5,963 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The owner sets authFacts by its own L1 call; the validator rebuilds the block without the failing op.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
