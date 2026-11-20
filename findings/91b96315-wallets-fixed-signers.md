---
id: 91b96315-wallets-fixed-signers
title: "0x91b96315: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x91b9631508f0cc0c0c90d74038c6a669e8db08a0"
  family: "33cf8aeeb374ca53b6ece9e73b378673"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "the owners (quorum)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Signer settable via ownerCut → refuted per scale."
---

## Summary

Not SimpleMultiSig: verified DominiumOwner (enactProposition/ownerCut/verifyHash). Owners are replaceable by ownerCut (add/remove/replace, quorum-signed), so the signer set is not fixed.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Verified ABI: ownerCut((uint8 action,address account,address prevAccount,uint256 endsAt),bytes[]) with OwnerCutExecuted event, DuplicateOwner/MinimumOwners errors (etherscan cache)
- At 26438999 (reth): ownersLength 3 (0xc9a9…b4dc, 0x3236…b188, 0x641b…64f6, all EOAs today), quorumGovernanceThreshold 2; ETH 0; signer code-today checks (latest, block ~26452900, publicnode)
- ValueTransferUnsupported error / maxAllowedTransfer pure: contract does not hold ETH by design
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners rotate to new keys/ERC-1271-capable signers via ownerCut before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
