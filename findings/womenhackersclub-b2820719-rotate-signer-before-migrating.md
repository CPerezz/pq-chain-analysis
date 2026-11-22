---
id: womenhackersclub-b2820719-rotate-signer-before-migrating
format: 2
title: 'WomenHackersClub: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9'
  name: WomenHackersClub
  code: verified
  code_url: https://etherscan.io/address/0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9#code
  copies: 2
  family: 1ab2a84125471aff70e093b9ec87046a
  upgradeable: 'no'
  admin: '0x9fc65849b04b21d11c92adb07329c163933c15e4'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigningAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9'
  file: contracts/WomenHackersClub_v6.sol
  line: 165
  has: address signer = ecrecover(hash, v, r, s);
  says: verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9'
  file: contracts/WomenHackersClub_v6.sol
  line: 166
  has: require(signer != address(0), "invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9'
  file: contracts/WomenHackersClub_v6.sol
  line: 139
  has: function setSigningAddress
  says: setSigningAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9'
  fn: signingAddress()(address)
  is: '0x1048ded3a542e064c82161ab8840152393e0477e'
  says: The signer it keeps in storage is 0x1048ded3a542e064c82161ab8840152393e0477e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x1048ded3a542e064c82161ab8840152393e0477e'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
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

WomenHackersClub checks an ECDSA signature in verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigningAddress changes the signer.

## Evidence

- [verifySignature](https://etherscan.io/address/0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigningAddress](https://etherscan.io/address/0xb282071972ee5f9d0b438e9468a62a17bc4e5ad9#code) changes the signer; only the owner can call it.
- The signer at the block is [0x1048…477e](https://etherscan.io/address/0x1048ded3a542e064c82161ab8840152393e0477e), an account without code.

## Reviewer notes

### Mechanism

verifySignature (contracts/WomenHackersClub_v6.sol, line 162) recovers a signer on line 165 and tests it on line 166 against the signer it keeps in storage (signingAddress() returns 0x1048ded3a542e064c82161ab8840152393e0477e). Neither isValidSignature selector is in the code, so that account is never asked. setSigningAddress (contracts/WomenHackersClub_v6.sol, line 139) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-06-21, recovering 0x1048…477e; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
