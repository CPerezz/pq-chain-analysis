---
id: dbce32eb-fixed-signer
title: "0xdbce32eb: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdbce32eb91fdf3c63163799826b5f087d61b4456"
  family: "bb71b7f803c8b7425a3714469c8c964e"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project owner/operator"
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
  note: "The study note calls this a presale with deposit/claim, but the code is a signed NFT mint. Only minting of new NFTs would stop."
---

## Summary

The mint signer is a hardcoded constant that no function can change. Today it is an account with a 7702 delegation, so its signatures still recover. If that account gets real code, signed mints stop working. No funds get locked: withdraw() is owner-only and does not need the signature, and NFTs that already exist can still be transferred.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- safeMint: address signer = ecrecover(hash,v,r,s); require(signer == 0x005199627E4aea0Ba8c85c2D182fE8852bcFEdEF)
- No function writes the signer; transferOwnership/renounceOwnership only change _owner
- Signer code at block 26438999: 0xef0100afab751f0257cff58785c4fb3d819ec4a8da9410 (7702 delegation)
- withdraw() onlyOwner transfers address(this).balance without needing a signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new mint contract with a signer that can be changed or that accepts ERC-1271, or keep the signer key as an EOA or a 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
