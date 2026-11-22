---
id: simplemultisig-38699d04-wallets-fixed-signers
title: "SimpleMultiSig: wallet with signers fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x38699d04656ff537ef8671b6b595402ebdbdf6f4"
  family: "f9810ce48fc335d2331639d97fe22a64"
  copies: 21
  name: "SimpleMultiSig"
  label: "PAXOS: PAXG Fees"
  upgradeable: "no"
  rating: LOW
  value_usd: 4920
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "the owners replace the owner set by a signed call while their keys are EOAs"
evidence:
  level: source-read
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
  verdict: confirmed
  rating: LOW
  note: "setOwners is called by the wallet itself with the owners' signatures, so the owners can replace themselves while their keys are still EOAs, as with a key rotation: LOW (same as 0xc8d9b805)."
---

## Summary

SimpleMultiSig (EIP-712 version): execute() needs `threshold` ecrecovered owners in ascending order. setOwners is self-call only (needs those same signatures) and can install only keys that ecrecover can recover.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig (original): `threshold` owners in ascending order by ECDSA; no function changes the owners. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source SimpleMultiSig.sol; runtime identical to the dossier code.hex. setOwners(uint256,address[]) exists but requires msg.sender == address(this) (CALLER ADDRESS EQ in the bytecode), so it is reachable only through execute() with `threshold` ecrecovered owner signatures and can only install other ECDSA keys
- SSTOREs: nonce (slot 0) in execute, plus setOwners_ writes; no other way to move funds, no proxy
- At 26438999: threshold 3, nonce 46, 20 owners (ownersArr 0..19), all EOAs with nonce 0

## Impact and exposure

- Value held at block 26,438,999: $4,920 (ETH and 49 priced tokens, over 21 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
