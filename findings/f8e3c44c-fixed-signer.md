---
id: f8e3c44c-fixed-signer
title: "0xf8e3c44c (tagged Landz: LDZ Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf8e3c44cac70fc926fdf57c71645adf49036dc0e"
  family: "6e73a1cc5abee3b1f89d596cc660e4bc"
  label: "Landz: LDZ Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 5
  last_active: 2026-10-23
fix:
  layer: new-deployment
  who_acts: "Project team (would need to redeploy for further mints)"
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
  note: "The study note calls this a presale with deposit/claim, but the code is an NFT mint. Only new mints are affected."
---

## Summary

The coupon signer is a library constant with code_bytes 0 today, so it is an EOA. Nothing can replace it. If that address gets code, mint and freeMint stop working. No ETH or NFTs get locked, because withdraw and transfers do not need a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- DataLibrary: address public constant _adminSigner = 0x8345...8D70
- isVerifiedCoupon: return signer == DataLibrary._adminSigner, with no ERC-1271 or code check
- Row facts: the code_bytes of 0x8345b7c4... is 0, and it is not delegated
- withdraw() needs only msg.sender == landzAddress or advisorA, not a signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-10-23.

## Remediation

Deploy a new contract whose signer can be updated or that accepts ERC-1271, or keep the signer key code-free.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
