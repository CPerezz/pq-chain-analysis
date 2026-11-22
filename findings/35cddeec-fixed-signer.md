---
id: 35cddeec-fixed-signer
title: "0x35cddeec (tagged Notorious Kings: NKG Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x35cddeec0410c17bcbdb89e47efc94d862a1fe6e"
  family: "24fc2dd3813fdf0966ae639a3976bc15"
  label: "Notorious Kings: NKG Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 19
  last_active: 2026-10-11
fix:
  layer: new-deployment
  who_acts: "Owner or project team"
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
  note: "The signature-checking functions are mostly unresolved in the decompilation, so which functions are signature-gated is inferred from their argument shapes. That does not change the rating: the gated paths only mint new NFTs, and the ETH can still be withdrawn by the owner."
---

## Summary

The signer is a hardcoded constant (0x5104…2fd7) with no setter, and that address is an EOA today. If it gets code, the signed whitelist and private mints stop working. Nothing is locked: the owner can still withdraw the ETH and the public mint still works.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The decompilation declares `uint256 public constant signer`, and the signer() getter returns 0x5104b2a2ade2e3b8ba26c410f9bf0588398f2fd7.
- The constants list gives code_bytes 0 for that address and the verified facts list it as an EOA, so it has no code and no 7702 delegation.
- The only setters are transferOwnership and renounceOwnership, and both write only the owner slot (store_k).
- withdraw() (0x3ccfd60b) is onlyOwner and transfers address(this).balance to the owner.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 19 transactions called it in the 90 days before that block; last on 2026-10-11.

## Remediation

Keep the signer key an EOA, or limit it to a 7702 delegation. If it must change, deploy a new contract and use the public mint or an owner-side mint in the meantime.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
