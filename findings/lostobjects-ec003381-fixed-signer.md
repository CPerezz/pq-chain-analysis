---
id: lostobjects-ec003381-fixed-signer
title: "LostObjects: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xec003381a709becf146037c0999ab5ffcfee1369"
  family: "8e62298f3756beb058100016a33baba6"
  name: "LostObjects"
  upgradeable: "no"
  rating: NONE
  txs_90d: 6
  last_active: 2026-10-23
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
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Every path that reaches the check is closed for good by state (sold out, no burn), so refuted. txs_90d 6 are transfers, which need no signature."
---

## Summary

LostObjects (Helmets2117 idiom): claimMint and saleMint need a signature from the constant _signerAddress 0x3cAba710…, but the collection is minted out (totalSupply 1000 = COLLECTION_SIZE) and there is no external burn, so both signed paths revert on supply before they reach the check.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Helmets2117: signed by SIGNER_ADDRESS, fixed in the code. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source LostObjects.sol: _signerAddress constant; claimMint/saleMint both require totalSupply()+quantity <= COLLECTION_SIZE (1000) and are the only ecrecover users
- totalSupply() = 1000 at block 26438999 (cast call)
- no burn function exposed in LostObjects.sol (ERC721A _burn is internal only), so supply can never drop
- signer 0x3caba710… has no code, nonce 0; contract holds 0 ETH; withdrawMoney is onlyOwner, no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-10-23.

## Remediation

None needed: the signed mint can never run again.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
