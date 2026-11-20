---
id: 9940bb66-fixed-signer
title: "0x9940bb66 (tagged Elysium Code:  Elysium Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9940bb667f64fca06fc4127861855696def7c69d"
  family: "dfba7dbddd9b06fbda0f7d9e824efec7"
  label: "Elysium Code:  Elysium Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 58
  last_active: 2026-11-14
fix:
  layer: new-deployment
  who_acts: "The project owner/operator"
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
  note: "The signer is either 0x001e00787038467e6febb6511e1b3bf437abe3e4 or 0xf75c90d6d5d34d6906d61cfd5e759cfc7ab4eea5. The source does not show which immutable slot holds which address, and the owner may have changed since deployment. Both addresses are EOAs, so the verdict is the same either way."
---

## Summary

The signer is an immutable set to the deployer and nothing can replace it. There is no ERC-1271 path and no check for code. Both signer candidates are EOAs today. If the signer key's account gets code, only the signed mints stop working. No funds get stuck: the owner can still withdraw ETH, and minted tokens can still be transferred or migrated without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The signer is declared `address private immutable _signer;` and set in the constructor with `_signer = owner();`.
- preSaleMint and publicSaleMint both revert with InvalidSignature when `ECDSA.recover(hash, signature) != _signer`.
- No function writes _signer. transferOwnership only changes the owner.
- withdraw(address,uint256) is onlyOwner and needs no signature, so ETH stays recoverable.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 58 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

Keep the signer key's account free of non-delegation code. If a signer is needed again, deploy a new sale contract with a signer that can be changed or that supports ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
