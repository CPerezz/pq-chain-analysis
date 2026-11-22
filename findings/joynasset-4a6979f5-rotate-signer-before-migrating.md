---
id: joynasset-4a6979f5-rotate-signer-before-migrating
format: 2
title: 'JoynAsset: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4a6979f530677d2e5b10fe1cd85b532fa548a606'
  name: JoynAsset
  code: verified
  code_url: https://etherscan.io/address/0x95bf23f21b75cb2241c495a45aff66db457e7df6#code
  proxy_of: '0x95bf23f21b75cb2241c495a45aff66db457e7df6'
  copies: 4
  family: c5a4cdcaa4f24d849f9bb9665f26e2e0
  upgradeable: 'yes'
  admin: '0x5c0dc45cd41eb46e1e8b2aeac3cfc55e4925eb83'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setJOYNSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x95bf23f21b75cb2241c495a45aff66db457e7df6'
  file: contracts/JoynAsset.sol
  line: 261
  has: address signer = ecrecover(hash, v, r, s);
  says: _getSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x95bf23f21b75cb2241c495a45aff66db457e7df6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x95bf23f21b75cb2241c495a45aff66db457e7df6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x95bf23f21b75cb2241c495a45aff66db457e7df6'
  file: contracts/JoynAsset.sol
  line: 262
  has: 'require(signer == joynSigner, "JoynAsset: invalid signature");'
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x95bf23f21b75cb2241c495a45aff66db457e7df6'
  file: contracts/JoynAsset.sol
  line: 223
  has: function setJOYNSigner
  says: setJOYNSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x263c993863204130dadfaf0d8926ff32ea52dae2'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

JoynAsset checks an ECDSA signature in _getSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setJOYNSigner changes the signer.

## Evidence

- [_getSigner](https://etherscan.io/address/0x95bf23f21b75cb2241c495a45aff66db457e7df6#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setJOYNSigner](https://etherscan.io/address/0x95bf23f21b75cb2241c495a45aff66db457e7df6#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x263c…dae2](https://etherscan.io/address/0x263c993863204130dadfaf0d8926ff32ea52dae2), an account without code.

## Reviewer notes

### Mechanism

_getSigner (contracts/JoynAsset.sol, line 227) recovers a signer on line 261 and tests it on line 262 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setJOYNSigner (contracts/JoynAsset.sol, line 223) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-05-25, recovering 0x263c…dae2; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
