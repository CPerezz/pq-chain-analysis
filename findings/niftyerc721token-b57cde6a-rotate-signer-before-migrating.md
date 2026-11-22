---
id: niftyerc721token-b57cde6a-rotate-signer-before-migrating
title: "NiftyERC721Token: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0xb57cde6af4d777f5f111ecd9953f44fe64a3cd7c"
  family: "be579c176805d47978fb09855d453387"
  copies: 5098
  name: "NiftyERC721Token"
  label: "deployed by Nifty Gateway: Deployer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 3128
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "signer 0x2CE48F39 (EOA, nonce 1569); setSigner caller = NiftyRegistry 0x6e53130d valid senders (admin is zero)"
evidence:
  level: source-read
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
  rating: LOW
  note: "No funds or functions depend on the attestation (impact none), and the signer is a live EOA that can sign now. Who may call setSigner was not verified."
---

## Summary

NiftyERC721Token (Nifty Gateway). Its only recovery is in sign(), a one-time attestation in which the stored signer signs a salted hash. Under EIP-8151 a signer with code could not complete it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- Signable.sol: sign() needs msg.sender==signer and ECDSA.recover==signer; isVerified gates nothing else in the source
- signatureStatus at 26438999: isSalted=true, isVerified=false, signer=0x2CE48F39 (also owner(), EOA nonce 1569)
- setSigner is gated by _requireOnlyValidSender: admin()=0, so permissionsRegistry 0x6e53130d isValidNiftySender decides; isValidNiftySender(owner)=false; valid senders not enumerated

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5,098 addresses).
- Activity: 3,128 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The signer calls sign() while it is still an EOA, or a Nifty valid sender calls setSigner with a new key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
