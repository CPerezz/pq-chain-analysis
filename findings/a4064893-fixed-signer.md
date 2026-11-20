---
id: a4064893-fixed-signer
title: "0xa4064893 (tagged The Surreals: SRLS Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa406489360a47af2c74fc1004316a64e469646a5"
  family: "8fbadc27a3015f9cab86bd6a439b30df"
  label: "The Surreals: SRLS Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 208
  last_active: 2026-11-14
fix:
  layer: onchain-config
  who_acts: "Owner (0xe20a4f1e92dc89c17388886d37b2ed58f07e2f29)"
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
  note: "The study note calls this a presale with signed deposit and claim. The code is actually an NFT mint, and only mint() needs the signature."
---

## Summary

The public mint checks signatures against a constant signer that is an EOA today (code_bytes 0) and cannot be replaced. If that account gets code, signed public mints of new NFTs stop. Already-minted NFTs and the ETH held are not affected: the owner can still withdraw. Only a function stops and nothing is locked, so the rating is MEDIUM.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address internal constant _signer = 0x0190501d...89a7`: no function writes to it
- mint(): `require(hash.recover(signature) == _signer, "INVALID_SIGNATURE")`
- constants[]: 0x0190501d... has code_bytes 0 and is not delegated
- withdrawETH() onlyOwner has no signature check

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 208 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

The owner can set saleStartTimestamp to 0, set a whitelist timestamp and add buyers with addToWhitelist so they can use mintWhitelist. This route is capped at 3 per address and 2772 in total. The owner can also call mintOwner. A new deployment would be needed to bring back signed public sales.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
