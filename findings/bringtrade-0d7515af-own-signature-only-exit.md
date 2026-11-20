---
id: bringtrade-0d7515af-own-signature-only-exit
title: "BringTrade: funds released only by the party's own signature"
status: confirmed
severity: MEDIUM
patterns: [PQ-16]
impact: liveness
contracts:
- address: "0x0d7515af7a3f97f0678b0ac41a4408bbede25782"
  family: "d3e9357bd60bfdce33a50a998e3915ff"
  name: "BringTrade"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 699
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "admin Safe 0x1D39..d408 (guard role)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "User withdrawal dies for good (no update path); the operator can still pay out via rescueFunds (Safe admin + guard role) -> MEDIUM."
---

## Summary

Exchange payout contract: a user's withdrawal needs the user's own EIP-712 signature (withdrawRequest, then re-checked in withdraw) plus an APPROVE_ROLE signature. Deposits go straight to the vault, so this contract holds only the operator's payout liquidity. The user's on-chain withdrawal stops, but the operator can still pay that user another way.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: BringTrade withdraw: the user's own EIP-712 signature and an APPROVE_ROLE signature; withdrawRequest also needs the user's signature; no direct or ERC-1271 path. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- src/BringTrade.sol withdrawRequest L173-197: signer must equal msg.sender; withdraw L92-122 re-checks the user's signature, recover(...) == user
- deposit L158-169 forwards funds to vault 0x6519..c008; the balance here is 0.097 ETH of operator liquidity (row value $699)
- rescueFunds (GUARD_ROLE) can send any non-supported asset to any account; the admin can removeAsset first, so the operator can pay without the user's signature
- owner()/admin = 0x1D39..d408, a contract (Safe getThreshold=2) that also holds GUARD_ROLE (hasRole true) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $699 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator pays the affected user through rescueFunds (after removeAsset) or from the vault.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
