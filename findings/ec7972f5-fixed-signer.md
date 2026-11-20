---
id: ec7972f5-fixed-signer
title: "0xec7972f5 (tagged wooonen: wooonen Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xec7972f53d96a6a2260f8460768f49b8721b6106"
  family: "13df0fb3c49f0f997f2ac83765b0d675"
  label: "wooonen: wooonen Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 20
  last_active: 2026-11-16
fix:
  layer: new-deployment
  who_acts: "The owner, who can switch to setWhitelist plus the allowlist mint or deploy a new contract"
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
  note: "The study note calls this a presale with deposit and claim, but the code is an ERC721A NFT mint. The signed function is the public mint of new tokens."
---

## Summary

The signer is a hard-coded constant with no way to replace it, and that address is an EOA today. If it ever gets real code, only the signed publicMint stops working. Nothing is locked: ETH can be withdrawn by the owner, and the owner can keep minting going through setWhitelist and the allowlist mint.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The decompiled code declares `uint256 public constant cSigner = 864044924954053468802333880089502749047810892369`, which is 0x97591d4c59b35b7a3842735c5c3e3d131ab32251.
- The verified facts show 0x97591d4c59b35b7a3842735c5c3e3d131ab32251 is an EOA (no code) at block 26438999.
- publicMint(uint256,uint8,bytes32,bytes32) takes v,r,s and checks the supply cap (0x251c) and the 'Claimed' flag.
- The only setters are transferOwnership and renounceOwnership, and both write owner; nothing writes the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 20 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Keep the signer key as a plain EOA, or at most a 7702 delegation, and never give it real code. If it is lost, use setWhitelist and the allowlist mint, or redeploy with a signer that can be replaced or that supports ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
