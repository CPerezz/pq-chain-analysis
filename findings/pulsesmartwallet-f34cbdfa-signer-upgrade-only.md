---
id: pulsesmartwallet-f34cbdfa-signer-upgrade-only
title: "PulseSmartWallet: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xf34cbdfa5c05efa341c916a66114f195533e5e49"
  family: "3add81478116adfd9e5d9eac1074c16c"
  name: "PulseSmartWallet"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted: the ERC-1271 fallback in SignatureCheckerLib covers owners with code, as long as the owner's new code implements isValidSignature. The row is also a locked implementation. Main reviewer: the dossier proxy 0xb7510f3f stores an empty owner at index 0, which looks unusable regardless of EIP-8151 (not caused by EIP-8151)."
---

## Summary

PulseSmartWallet (a Coinbase Smart Wallet copy) checks an address owner with Solady SignatureCheckerLib.isValidSignatureNow. When ecrecover returns nothing, that function falls through to an ERC-1271 isValidSignature call on the owner, so an owner with code is asked through ERC-1271. The row address is the implementation, locked with owner address(0).

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Coinbase Smart Wallet: the owner at the given index is an address checked with Solady SignatureCheckerLib (ecrecover, then the owner's ERC-1271), or a passkey. Read (function text).
- Update path, read at block 26,438,999: upgradeToAndCall(address,bytes), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- source lib/solady/src/utils/SignatureCheckerLib.sol isValidSignatureNow: if the ecrecover staticcall returns no data or a different address, it falls through to staticcall(signer, isValidSignature(bytes32,bytes)) and accepts the magic value 0x1626ba7e
- src/PulseSmartWallet.sol _isValidSignature: a 32-byte owner goes to SignatureCheckerLib.isValidSignatureNow(owner, hash, sig); a 64-byte owner goes to WebAuthn (P-256, does not use ecrecover)
- at 26438999 the implementation 0xf34cbdfa has nextOwnerIndex()=1 and ownerAtIndex(0)=abi.encode(address(0)), so it is locked; the dossier proxy 0xb7510f3f (implementation slot = row, 0.0105 ETH) has nextOwnerIndex=1 but ownerAtIndex(0)=empty bytes
- execute/executeBatch also accept a direct call from an owner address (onlyEntryPointOrOwner), and _authorizeUpgrade is onlyOwner (an owner or the wallet itself)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for EIP-8151: an owner whose account takes code is asked through its own isValidSignature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
