---
id: 88888888-fixed-signer
title: "0x88888888: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x88888888c37d1affbc08008d31446f176d999c13"
  family: "2204e404f83d664b27777c2a475eb2a9"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "The owner (0xf9768ddf67125cf3eba2c8c73f59ed8f141f96d0) calls advanceSalePhase to move to the public sale."
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
  note: "The study note describes this as a presale with 'deposit and claim', but the verified source is an NFT signed mint. The row's constants list shows 0x111a5b99d89bdd1cce8810985908185b5bdd5b9d, while the signer in the source is 0x35c4…c8e2. Both addresses are EOAs today."
---

## Summary

The presale signer is an immutable EOA with no setter and no code check or ERC-1271 fallback. If that key's account gets real code, presale minting of new NFTs stops. Nothing already held gets locked: minting goes on through publicMint, and the owner can withdraw the ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- SIGNER is declared immutable and set to 0x35C40ec37Ab0206965581d36d73cBC2098DbC8e2; no function assigns it
- The bytecode facts show 0x35c40ec37ab0206965581d36d73cbc2098dbc8e2 is an EOA with no code
- presaleMint requires ecrecover(...) == SIGNER and makes no extcodesize or ERC-1271 check
- publicMint mints without a signature once salePhase == PUBLIC

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls advanceSalePhase to open the public sale. If the presale has to continue, deploy a new contract with a signer that can be replaced or that accepts ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
