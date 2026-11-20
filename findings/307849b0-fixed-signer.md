---
id: 307849b0-fixed-signer
title: "0x307849b0 (tagged deployed by MADZ Avatar: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x307849b04c1edde559ba9880a592fd3981cb3b10"
  family: "f3daa14c24200650e7a91e95eb5cf3ba"
  label: "deployed by MADZ Avatar: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-13
fix:
  layer: new-deployment
  who_acts: "The owner/project would have to redeploy a mint contract with a new signer. Minting stops until then"
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
  note: "The study note calls this a presale with deposit/claim, but the code is an NFT mint. I matched the signer to 0x895f… because it is the only address-shaped value in the bytecode (the same address is also the owner)."
---

## Summary

The signer is an immutable with no setter, and there is no code check or ERC-1271 path. The only address in the bytecode is 0x895f…, which is an EOA, so this is the signer. If that key's account gets real code, signed mints stop working. No funds are locked: users pay in the same transaction they mint, and the owner can withdraw the ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable signingAdrress;` is assigned only in the constructor
- _checksignature: `require(signer == signingAdrress, "Signer address mismatch.")`
- No function writes signingAdrress. The only listed setter is transferOwnership
- The only address in the runtime bytecode (which includes immutables) is 0x895fe75d025efe41d30e38703ec28fab68545f03, an EOA with no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-13.

## Remediation

Redeploy the mint with a signer that can be rotated, or accept ERC-1271 signatures. The signer key should stay a plain EOA or a 7702 delegation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
