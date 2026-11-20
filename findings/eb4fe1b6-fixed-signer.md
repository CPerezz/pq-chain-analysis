---
id: eb4fe1b6-fixed-signer
title: "0xeb4fe1b6 (tagged deployed by wooonen: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xeb4fe1b6149cc53362f2012e1c215731fe3fcdc4"
  family: "08cb26b30fd0da3f5bdd120ba8686c7a"
  label: "deployed by wooonen: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-11-03
fix:
  layer: new-deployment
  who_acts: "Owner (can move whitelisted users to setWhitelist/appointMint, or redeploy)"
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
  note: "The row facts do not give the signer's code size, because immutables are not listed in constants[]. I treated the signer as an EOA because a signing key's address would normally have no code apart from a 7702 delegation, but this was not measured. The study note calls this a 'presale deposit/claim', but the code is an NFT whitelist mint."
---

## Summary

The signer is an immutable address hard-coded in the constructor. Nothing can change it, and there is no code check or ERC-1271 fallback. If that key's account gets real code, only the free whitelist mint stops. Nothing is locked: the owner can still withdraw funds, and the other mint paths keep working.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner;` and the constructor sets `cSigner = 0x97591D4C59b35b7A3842735c5C3E3D131aB32251`
- whiteMint: `require(ecrecover(digest, v, r, s) == cSigner, "Invalid signer")`
- No function writes cSigner. The only setters are owner-related (transferOwnership).
- woooMint and appointMint mint without any signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-03.

## Remediation

The owner can grant the affected allowlist users mints through setWhitelist so they use appointMint. Otherwise, redeploy with a signer that can be replaced or that accepts ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
