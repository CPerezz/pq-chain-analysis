---
id: chosenones-4f17e8e9-fixed-signer
title: "ChosenOnes: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4f17e8e976b809408d4aa3485bff9326df8ab505"
  family: "a805b06e7b42fe7387ea315fc52bcd0e"
  name: "ChosenOnes"
  upgradeable: "no"
  rating: LOW
  value_usd: 2978
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (toggleSale)"
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
  rating: LOW
  note: "LOW: a setting (toggleSale) by the live owner keeps the same mint open to allowlisted buyers. Presale terms are lost, and nothing is locked. If presale-only terms count as a separate act, MEDIUM."
---

## Summary

ChosenOnes NFT: presaleMint needs a signature from the constant SIGNER 0x78dF…964d. The public mint() stays available once the owner turns on the sale, and proceeds leave through owner withdraw() to the VAULT.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ChosenOnes presale: signed by SIGNER, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ChosenOnes.sol:29 address public constant SIGNER = 0x78dF3aC8…964d; :74 SIGNER == hash.recover(signature)
- toggleSale(bool,bool) onlyOwner; mint(uint256) needs no signature; withdraw() onlyOwner pays VAULT 0xDDA1…32a7
- SIGNER has no code today; owner 0x646C…6412; balance 1.65 ETH

## Impact and exposure

- Value held at block 26,438,999: $2,978 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner opens the public sale (toggleSale) if the presale signer takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
