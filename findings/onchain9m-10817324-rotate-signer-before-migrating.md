---
id: onchain9m-10817324-rotate-signer-before-migrating
title: "Onchain9m: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x10817324d6236ea91ef68ae919fc80ef36f44549"
  family: "4331118f9180126b3b8fdd3be4a302de"
  name: "Onchain9m"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4604
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner EOA"
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
  rating: LOW
  note: "Owner-only setter exists and the owner is a live EOA; the setter is locked once claim minting is finalized (not the case at the block)."
---

## Summary

Onchain9m NFT with an owner-set claimSigner for signed claims; under EIP-8151 a claimSigner holding non-7702 code would make signed claims fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setClaimSigner, setMinter). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile: setClaimSigner(address) 0xfed80d43 requires msg.sender==owner and that claim minting is not finalized; claimMintingFinalized()=false at block
- eth_call at block 26438999: setClaimSigner from owner 0x8b3F…4693 succeeds, from 0xdead reverts 0x118cdaa7 (OwnableUnauthorizedAccount)
- owner 0x8b3F6F5c62Ff1D8b66Dc04bA3CC309E260Bc4693 is an EOA, nonce 322 (probe); claimSigner()=0x0 at block (signed claims currently unset)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4,604 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner points claimSigner at a plain key before the current signer takes code; they must do it before finalizeClaimMinting, which locks the setter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
