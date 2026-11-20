---
id: nft-73b93f6b-fixed-signer
title: "NFT: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x73b93f6bd45a9e5df3ae1a2996ffebcaec2f852c"
  family: "bce8de826031a43ed61be098c9f35bd5"
  name: "NFT"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "contract owner"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path; mint gates die, ETH stays reachable via claimBalance → MEDIUM."
---

## Summary

awardItemWL, awardItemHolder and awardItemPB each require ecrecover to equal one of three minters fixed at declaration, with no setter. claimBalance and changeOwner are owner direct calls.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: NFT awardItemWL/Holder/PB: three minter addresses fixed at declaration with no setter; only these mint gates stop (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- NFT.sol: wlMinter 0x471b…137E, pbMinter 0x16e5…81E5, holderMinter 0x5431…21E8; no setters
- all three minters have code 0x today; owner 0x7DE7…60cb (changeOwner exists)
- totalMint 275, publicMintOpen true at 26438999; claimBalance(onlyOwner) moves ETH without a signature

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain for the gated mints; adminMint works only while totalMint ≤ 300.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
