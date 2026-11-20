---
id: 9440e5e5-fixed-signer
title: "0x9440e5e5: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9440e5e537b730d138a6d6392eb29d0245150e8f"
  family: "b29e6318cbee881a77447687dba3fd71"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "contract owner 0x250092bd5e3278a5c71d3949b0efa92544154ca4"
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
  rating: LOW
  note: "LOW: minting stays open via public mint/teamMint; nothing locked. Flag: no price setter, so whitelisted buyers would pay the public price unless owner teamMints."
---

## Summary

DogZone-derived ERC721Psi sale: whitelistMint(n,hash,sig) accepts only signatures from the hard-coded signer 0xa51681c6…68d6; if that key gets code the whitelist mint stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Same code idiom as template d4de1d4c, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled.sol: whitelistMint compares recoverSigner result to constant 0xa51681c6e1c1f672529926712c3058cef52968d6 ("Whitelist not allowed for your address"); no setter, setters list = transferOwnership only
- signer 0xa516…68d6: cast code = 0x (EOA) at block 26438999
- same act open by other paths: public mint(uint256) in the next phase (owner enterNextPhase) and onlyOwner teamMint; no price setter found
- ETH out via onlyOwner disbursePayments; balance at block 26438999: 0; txs_90d=0, last_active=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner serves whitelisted buyers via teamMint or the public phase.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
