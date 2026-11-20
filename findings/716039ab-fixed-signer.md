---
id: 716039ab-fixed-signer
title: "0x716039ab (tagged Cool Monkes: CMNKS Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x716039ab9ce2780e35450b86dc6420f22460c380"
  family: "8dbae8d119a0516e8aa5f24fa3800497"
  label: "Cool Monkes: CMNKS Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 112
  last_active: 2026-11-11
fix:
  layer: new-deployment
  who_acts: "The owner. They can turn on the public mint with flipPublicsale, or deploy a new contract if a signed allowlist mint is still needed."
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
  note: "The study note describes this as a presale with deposit and claim, but the code is an NFT allowlist mint. The decompilation does not show the full ecrecover call, so I matched the signer from the constant enforcerAddress, which is the only EOA among the address constants."
---

## Summary

The presale mint accepts only signatures from the hardcoded enforcerAddress 0xd8a7…99ce. That address has no code today, so it is an EOA. No function can replace it, and the contract has no upgrade path. If that key's account ever gets real code, presale minting stops. Nothing is locked: the owner can withdraw the ETH at any time, and the public mint() needs no signature. So this is MEDIUM: one function stops, but no funds are lost or locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant enforcerAddress = 1236888278701744207364883682673270431992499050958, which is 0xd8a7fd1887cf690119ffed888924056af7f299ce; the facts show it is an EOA with code_bytes 0
- presaleMint(uint256,uint256,uint256,bytes) takes a bytes signature and requires 'Presale is not enabled yet!'; nounceTracker(address) holds per-user nonces
- No function writes the signer. The only owner setters are transferOwnership (0xf2fde38b), renounceOwnership, setBaseURI and flipPublicsale
- withdraw() (0x3ccfd60b) is owner only and sends address(this).balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 112 transactions called it in the 90 days before that block; last on 2026-11-11.

## Remediation

Keep the enforcer key as a plain EOA or a 7702-delegated account. If the presale has to keep working after that account gets code, deploy a new contract with a signer that can be changed, or with an ERC-1271 fallback. In the meantime, the owner can use the public sale.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
