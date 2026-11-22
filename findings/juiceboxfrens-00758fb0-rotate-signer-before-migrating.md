---
id: juiceboxfrens-00758fb0-rotate-signer-before-migrating
format: 2
title: 'JuiceboxFrens: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570'
  name: JuiceboxFrens
  code: verified
  code_url: https://etherscan.io/address/0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570#code
  copies: 1
  upgradeable: 'no'
  admin: '0xcb96594aba4627e6064731b0098dc97547b397be'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 143
impact: liveness
action: Replace the signer with setWhiteListSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570'
  file: contracts/JuiceboxFrens.sol
  line: 142
  has: address signer = digest.recover(signature);
  says: buyPresale recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570'
  file: contracts/JuiceboxFrens.sol
  line: 145
  has: signer != address(0) && signer == whitelistSigner,
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570'
  file: contracts/JuiceboxFrens.sol
  line: 90
  has: function setWhiteListSigner
  says: setWhiteListSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570'
  fn: whitelistSigner()(address)
  is: '0xb6e4ff5065da9f17a9e53c66f17d1c534a27cdb9'
  says: The signer it keeps in storage is 0xb6e4ff5065da9f17a9e53c66f17d1c534a27cdb9 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xb6e4ff5065da9f17a9e53c66f17d1c534a27cdb9'
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

JuiceboxFrens accepts a call to buyPresale only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setWhiteListSigner changes the signer.

## Evidence

- [buyPresale](https://etherscan.io/address/0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setWhiteListSigner](https://etherscan.io/address/0x00758fb0c83a68b6ce4fcf1d2665600f3f0e4570#code) changes the signer; only the owner can call it.
- The signer at the block is [0xb6e4…cdb9](https://etherscan.io/address/0xb6e4ff5065da9f17a9e53c66f17d1c534a27cdb9), an account without code.

## Reviewer notes

### Mechanism

buyPresale (contracts/JuiceboxFrens.sol, line 117) recovers a signer on line 142 and tests it on line 145 against the signer it keeps in storage (whitelistSigner() returns 0xb6e4ff5065da9f17a9e53c66f17d1c534a27cdb9). Neither isValidSignature selector is in the code, so that account is never asked. setWhiteListSigner (contracts/JuiceboxFrens.sol, line 90) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-04-24, recovering 0xb6e4…cdb9; 143 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
