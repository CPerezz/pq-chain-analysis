---
id: 91d4e807-signed-shortcut-lost
title: "0x91d4e807: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x91d4e807d75b451b9ac3195877d83311fd57f919"
  family: "53afb9787acf3ca69f7e24a9d0838357"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "holders transfer directly"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Not a recheck: BixToken's pre-signed transfers move only the signer's own tokens in one call, and the same transfer stays open by a direct call: LOW under the signed-shortcut root issue."
---

## Summary

Not a Connext ledger channel: BixToken (BIX, 1e24 supply), a standard ERC-20 plus pre-signed transfer functions (0x29252fc2, 0x8c4c02ba). These move only the signer's own balance under a per-signer nonce, with no fee to the relayer. Nobody relies on the signature before the transfer, and direct transfer/approve stay open to the holder.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- name()=BixToken, symbol()=BIX, totalSupply()=1e24 at 26438999; 0 selectors in common with template 5c6fba46
- 0x29252fc2/0x8c4c02ba: require(from == ecrecover(hash)); require(nonce[from]==n); nonce++; balance[from]-=v; balance[to]+=v; no fee, no code check
- transfer(0xa9059cbb)/transferFrom/approve take msg.sender directly; EIP-1967 slots 0; txs_90d=0, last_active=null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Holder uses transfer/approve directly instead of the pre-signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-signed-shortcut-lost` applies, not `eip-8151-signature-rechecked`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
