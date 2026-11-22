---
id: 56f6c7b7-fixed-signer
title: "0x56f6c7b7 (tagged ArtvatarsOne: ARTVO Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x56f6c7b757848333be411a911784facea7a75607"
  family: "d2397ff8a33661f133423ce9b229b2e1"
  label: "ArtvatarsOne: ARTVO Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 14
  last_active: 2026-11-14
fix:
  layer: new-deployment
  who_acts: "future minters blocked; existing token holders unaffected"
evidence:
  level: bytecode
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
  note: "No update path for the hardcoded signer, but the contract was never holding money — this matches the MEDIUM example 'a signed NFT mint' dying for good with nothing locked."
---

## Summary

ERC721 (SERVER_ROLE/DEPOSITOR_ROLE, Polygon-bridge style). A raw ecrecover (no OZ wrapper strings) gates one internal call path, comparing the recovered address to a hardcoded PUSH20 constant (0xd3fb1747...) with no setter. This looks like a signed-voucher mint/claim path; it does not custody ETH/ERC20 — payment, if any, is forwarded at mint time, nothing is held in escrow.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode at 0x108f: STATICCALL to address 1 (via shared subroutine, same calling convention confirmed on other rows), return EQ'd against PUSH20 0xd3fb1747ed59135a827974af416fb31e0518b063.
- cast code on 0xd3fb1747... at the pinned block is empty — no code, signature still obtainable today but breaks once given any non-7702 code.
- Selector list is a standard ERC721 (name/approve/transferFrom/tokenByIndex/SERVER_ROLE/DEPOSITOR_ROLE); no payable escrow/deposit function exists.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 14 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

redeploy with a replaceable minter/signer role

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
