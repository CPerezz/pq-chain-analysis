---
id: blackisbeautiful-9b0674fe-fixed-signer
title: "BlackIsBeautiful: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9b0674fe9c91414378a5dfafb3376775a65cdeba"
  family: "46809be95a0ef237cf3ed22fd83dcfa7"
  name: "BlackIsBeautiful"
  upgradeable: "no"
  rating: LOW
  txs_90d: 20
  last_active: 2026-11-12
fix:
  layer: onchain-config
  who_acts: "owner"
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
  rating: LOW
  note: "A setting (Merkle mode) replaces the signed allowlist, and an owner airdrop covers ambassadors."
---

## Summary

BlackIsBeautiful: isAllowlisted compares ecrecover to the constant ALLOWLIST_SIGNER. It gates allowlistMintNFT only when signatureMode is on, and it always gates ambassadorMintNFT. The owner can switch the allowlist to its Merkle root (setSignatureMode/setMerkleRoot) and airdrop to ambassadors (airdropToAmbassador), so the same acts stay open.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- BlackIsBeautiful.sol:58: ALLOWLIST_SIGNER constant 0x8430e0B7…2Aa5, which has no code (cast code).
- allowlistMintNFT uses a Merkle proof when signatureMode is false; signatureMode()=false today; setSignatureMode/setMerkleRoot are onlyOwner (source).
- Balance 0 ETH; withdraw() is onlyOwner with no signature; owner 0xb2C7c59f… is an EOA.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 20 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

The owner keeps Merkle mode (already on) and uses airdropToAmbassador for ambassadors.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
