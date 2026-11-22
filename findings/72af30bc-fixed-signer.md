---
id: 72af30bc-fixed-signer
title: "0x72af30bc (tagged MC Pet Carriers: CARRIER Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x72af30bc8bce46a3f38879a08fbcecd1326b107f"
  family: "d83c551e4cb2599994d880172424f098"
  label: "MC Pet Carriers: CARRIER Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-27
fix:
  layer: new-deployment
  who_acts: "Project owner/operator: mint with adminClaimCarrier, or deploy a new contract; the vault sends cats manually"
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
  note: "The study note calls this a 'presale deposit', but the code shows an NFT claim and redeem contract with no user deposits."
---

## Summary

The signer is a hard-coded constant EOA with no code today, so the claim is confirmed. If that key gets code, signed claims and redeems stop working. Users keep their carriers, which stay transferable. The owner can still mint with adminClaimCarrier, and the vault EOA can send cats directly. Only a function stops; nothing users hold gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- SIGNER is declared as `address public constant SIGNER = 0x918de5F6...2912`. Its code_bytes is 0 and it is not delegated.
- checkClaimSignature and checkRedeemSignature both return `recoverSigner(...) == SIGNER`, using plain ecrecover. There is no isContract or ERC-1271 check.
- The only setter is transferOwnership, and it only changes the owner. upgradeable: no.
- claimCarrier mints new tokens. adminClaimCarrier (onlyOwner) can mint to anyone without a signature.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-27.

## Remediation

Deploy a new contract whose signer can be replaced or that accepts ERC-1271. Until then, the owner can mint with adminClaimCarrier and the vault can send cats directly in exchange for carriers being burned or transferred.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
