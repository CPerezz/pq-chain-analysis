---
id: 13dc5ee3-fixed-signer
title: "0x13dc5ee3: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x13dc5ee3bf5623e5c17171b7f9119002028068db"
  family: "d3466c14b2125da864ffe898aec8876c"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator/owner: redeploy with a new signer, or withdraw the stock and distribute it another way"
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
  note: "The study note says deposit and claim need the signature. That is wrong for this source: only addBeneficiary (registration) is gated, and claimTokens is not. I am assuming the signer is 0x5ec0…606e, because the other pushed value (0xccc0…0033) is a fragment of the CBOR metadata. Deposits are not user funds."
---

## Summary

The signer is an immutable cSigner, and the only address-shaped immutable in the bytecode (0x5ec0…606e) is an EOA today. If the signer key's account gets code, only addBeneficiary registration stops. Beneficiaries already registered still claim through claimTokens() with no signature. The tokens are operator-funded, and the owner can recover them with withdraw(), so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner;` assigned in the constructor; no setter exists
- addBeneficiary: require(ecrecover(digest, v, r, s) == cSigner)
- claimTokens() uses only the onlyBeneficiaries modifier and has no signature check
- withdraw(IERC20) onlyOwner transfers the full token balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new vesting contract with a new signer, or have the owner withdraw the stock and register or pay beneficiaries off-chain or by another mechanism.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
