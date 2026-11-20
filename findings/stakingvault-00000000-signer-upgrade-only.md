---
id: stakingvault-00000000-signer-upgrade-only
title: "StakingVault: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x00000000c35c0997aa04622e8c3c9221309ebea3"
  family: "beb2ebc5088da05639c9fc3cadd24774"
  copies: 2
  name: "StakingVault"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Refuted: the check accepts ERC-1271 from the signer, and the signer is the holder of a transferable NFT."
---

## Summary

Solady ERC6551/ERC1271 account: the signer is owner() (whoever holds the NFT), and SignatureCheckerLib falls back to the signer's ERC-1271 isValidSignature when ecrecover fails, so a signer that takes code keeps working.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Solady ERC1271 account: SignatureCheckerLib on the account's signer / Solady ERC1271 nested EIP-712 (variant): SignatureCheckerLib on the account's signer / Solady ERC1271…. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address. 1 with an upgrade function whose caller was not read.
- SignatureCheckerLib.isValidSignatureNowCalldata: when ecrecover fails, it staticcalls isValidSignature (0x1626ba7e) on the signer (dossier source lib/solady/src/utils/SignatureCheckerLib.sol)
- ERC6551._erc1271Signer() returns owner() = ownerOf(tokenId) of the bound NFT, which changes with NFT transfers (ERC6551.sol:104-125, 299)
- owner() at 26438999: 0x0 (this is the implementation; owner() is the token holder for each account) (chain1 = my reads at block 26438999 on reth.dappnode (code, EIP-1967 slots, owner(), OZ5 Initializable slot, slot 0))

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
