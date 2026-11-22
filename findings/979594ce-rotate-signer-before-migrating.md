---
id: 979594ce-rotate-signer-before-migrating
title: "0x979594ce: signer key to rotate before its account takes code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x979594ce68c551f98e72a43adfb4b419b6fdd5d3"
  family: "122cbca81e55c3ea1b751dee44424e7f"
  copies: 14
  upgradeable: "no"
  rating: HIGH
  value_usd: 234232
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10
  last_active: 2026-11-13
  recoveries_14d: 2
fix:
  layer: new-deployment
  who_acts: "the signers move the funds out while enough keys are EOAs"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "A threshold multisig wallet whose registered signers can never be replaced and that has no upgrade: the co-owners' own funds leave only with their ECDSA signatures, so they lock once enough keys have code. Same rating as the other fixed-signer wallets: HIGH."
---

## Summary

Minimal-clone threshold multisig wallet from a factory/registry (0xc298327c…76da). Every withdrawal needs ECDSA signatures from registered signers meeting the threshold. Under EIP-8151 a signer whose account takes code no longer counts; if too few remain, the wallet's assets are stuck. This copy holds 0.00016 ETH.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: multisig wallets from a factory: ordered recoveries handed to another contract (getSigners, isSigner). Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Registry 0xc298…76da (code latest, block ~26452951, publicnode; not a proxy, no DELEGATECALL): its 5 SSTOREs and the decompile show signers and threshold written only inside createMultisigWallet for the new wallet. No function adds, removes or replaces signers or changes the threshold
- Dossier 122cbca8: the wallet code has no rotation function, and every withdrawal (ETH/ERC-20/721/1155) goes through the ECDSA-only verifier, with no ERC-1271 and no msg.sender vote
- This address at block: slot_0 = registry 0xc298…, balance 160224741904645 wei

## Impact and exposure

- Value held at block 26,438,999: $234,232 (ETH and 49 priced tokens, over 14 addresses).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-13.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Signers keep their keys code-free (an EIP-7702 delegation is fine) and move assets to a new wallet before any key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
