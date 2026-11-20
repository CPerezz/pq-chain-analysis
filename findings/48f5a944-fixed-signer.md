---
id: 48f5a944-fixed-signer
title: "0x48f5a944: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x48f5a944a42bc7bd98458768f612bb6eb6b2f681"
  family: "aeacff1b51ccde6fe8269dc12fd6d031"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/project, which would have to deploy a new contract to change the whitelist signer"
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
  note: "The ERC721A source was not provided, so the transfer functions are assumed to be standard and not signature-gated. The presale window is fixed at 24h after presaleStartTime. This does not lower the rating: the signer-gated part is only the minting of new NFTs."
---

## Summary

The whitelist signer is immutable, cannot be replaced, and is an EOA today, so the fixed-signer claim holds. If the signer key's account gets real code, only the signed allowlist mint of new NFTs stops working. No funds get locked: ETH is paid at mint and the owner can withdraw it, and NFTs already minted transfer freely.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable whitelistChecker` is assigned only in the constructor
- presaleMint: `.toEthSignedMessageHash().recover(signature) == whitelistChecker`
- No function writes whitelistChecker. The only setter is transferOwnership (owner only)
- Immutable value pushed in bytecode: 0x89bf0bf552f22b844033cf77b42290e16539d167, which has no code (EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy the contract with a signer that can be replaced, or verify signatures through ERC-1271/SignatureChecker. Otherwise, keep the signer key's account free of real code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
