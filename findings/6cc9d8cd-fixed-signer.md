---
id: 6cc9d8cd-fixed-signer
title: "0x6cc9d8cd: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6cc9d8cd5faab62a3249efab3e2f2d7c3147da24"
  family: "3b381b31caea577dea87b591ffeccfd3"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "Owner (0x0000000009f17de301aa93489f80d6163ded5036)"
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
  note: "The study_note calls this a 'presale deposit/claim', but the code is an NFT presale mint with no deposits. In row facts, the second constant is 0x271d8570..., but the verified source has DEV_ADDRESS 0x73124518... and PRIMARY_ADDRESS 0xc64Beb85..., and neither of those is the signer. That mismatch suggests the deployed bytecode may be a variant of this source. Either way, the signer 0xb997...c729 matches in both."
---

## Summary

The presale allowlist mint checks signatures against a hardcoded constant, VERIFY_ADDRESS (0xb997...c729). Today that address has no code, and no function can replace it. If that account ever gets real code, presale minting stops. No funds get locked, because the payment happens at mint time and the owner can switch on the public mint as another way to mint.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The signer check is `verify()`: `recover(...) == VERIFY_ADDRESS`, and `VERIFY_ADDRESS` is declared `address constant` = 0xb997ADc54278348FDD86A5543c0250774F55c729.
- Row facts: constants[] shows 0xb997...c729 with code_bytes 0 and delegated false, so it is an EOA today.
- `recover()` uses plain `ecrecover`. There is no code-size check and no ERC-1271 path.
- `presaleMint` and `presaleMintMany` both require `verify(abi.encodePacked(msg.sender), signature)`.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner can call setPremintEnabled(false) and setMintEnabled(true) to sell through the public mint, or mint with mintOwnerMany and hand out tokens to allowlisted users. As an alternative, keep the VERIFY_ADDRESS key as a code-free EOA (or one with only a 7702 delegation).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
