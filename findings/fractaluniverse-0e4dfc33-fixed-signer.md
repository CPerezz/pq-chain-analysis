---
id: fractaluniverse-0e4dfc33-fixed-signer
title: "FractalUniverse: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0e4dfc3328f10e3c6e3016b90a68f09fb0f72293"
  family: "d54afcae85c538f4174c7a7e1090a120"
  name: "FractalUniverse"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-11-01
fix:
  layer: new-deployment
  who_acts: "owner"
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
  note: "A signed NFT mint with no update path. Nothing is held for claimers, and owner paths still move the ETH, so only the function dies."
---

## Summary

FractalUniverse claimMint accepts only signatures that recover to the private constant _signerAddress 0x0d80…9f3f. If that key gets code, free claims die for good, but the owner can still mint by airdrop and withdraw the ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Helmets2117 mint: signed by SIGNER_ADDRESS, fixed in the code; nothing is held for minters, so only the mint stops (MEDIUM). Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- FractalUniverse.sol:40 `address constant private _signerAddress`; line 105 `_signerAddress == ECDSA.recover(hash, signature)`
- airdropMint and withdrawMoney are onlyOwner (lines 73-76, 109); owner 0xab8d…33c1 has no code
- isHoldersClaimOn() = true, totalSupply 438 of 999; contract balance 0.0009 ETH; cast code 0x0d80… = 0x

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-11-01.

## Remediation

The owner mints the remaining claims by airdropMint.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
