---
id: e306eccd-fixed-signer
title: "0xe306eccd (tagged deployed by PhotoChromic: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe306eccdc0fbdaabdd95742d44ac55c4f527dabd"
  family: "1850eb4a5baaab554775d7dd9fdfc5ff"
  label: "deployed by PhotoChromic: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project/admin"
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
  note: "Assumption: the EOA constant 0x1d1b… is the signer, and 0x324e… is the IPFSTool library rather than a signer. There are three immutable addresses (whitelist signer, backend signer, treasury) but only two address constants were found, so some of them probably share the same value. This mapping is inferred, not proven."
---

## Summary

Both signers are immutable and nothing can replace them. If the backend signer key gets code, minting stops for good. Already-minted NFTs stay transferable, and the admin can still withdraw the ETH with transferBalance, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable _whitelistSignerAddress; address private immutable _backendSignerAddress;` are set only in the constructor
- mint(): `require(signer == _backendSignerAddress, "signature does not match")` uses raw ecrecover with no code check and no ERC-1271 path
- setAdmin only writes _adminAddress; setWhitelistTime only writes _whitelistTime
- transferBalance (onlyAdmin) sends address(this).balance to _treasuryAddress

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be rotated or that accepts ERC-1271 signatures, or keep the signer keys as plain EOAs.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
