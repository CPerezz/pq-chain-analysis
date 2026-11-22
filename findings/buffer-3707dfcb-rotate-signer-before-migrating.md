---
id: buffer-3707dfcb-rotate-signer-before-migrating
format: 2
title: 'Buffer: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3707dfcb39eac9878d6d8857e13d75463631d5c9'
  name: Buffer
  code: verified
  code_url: https://etherscan.io/address/0xe5776b43636d73accb21bb481deb99e2cf09d8ed#code
  proxy_of: '0xe5776b43636d73accb21bb481deb99e2cf09d8ed'
  copies: 3
  family: 780806f3dbac0df2104efaffd524b450
  upgradeable: 'no'
  admin: '0x2d9dbe61c44f5d0e49e8065cf671998882ff4afc'
value:
  usd: 2
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe5776b43636d73accb21bb481deb99e2cf09d8ed'
  file: src/backend/contracts/manyArtists/evolving/fixedPrices/splitter/Buffer.sol
  line: 346
  has: address recovered = hashed.toEthSignedMessageHash().recover(signature);
  says: validateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe5776b43636d73accb21bb481deb99e2cf09d8ed'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe5776b43636d73accb21bb481deb99e2cf09d8ed'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe5776b43636d73accb21bb481deb99e2cf09d8ed'
  file: src/backend/contracts/manyArtists/evolving/fixedPrices/splitter/Buffer.sol
  line: 347
  has: require(recovered == signer, "invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xe5776b43636d73accb21bb481deb99e2cf09d8ed'
  file: src/backend/contracts/manyArtists/evolving/fixedPrices/splitter/Buffer.sol
  line: 131
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3707dfcb39eac9878d6d8857e13d75463631d5c9'
  fn: signer()(address)
  is: '0xb15dfb31a96b94ec150a237bfc3d464affe774f7'
  says: The signer it keeps in storage is 0xb15dfb31a96b94ec150a237bfc3d464affe774f7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xb15dfb31a96b94ec150a237bfc3d464affe774f7'
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

Buffer checks an ECDSA signature in validateSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [validateSignature](https://etherscan.io/address/0xe5776b43636d73accb21bb481deb99e2cf09d8ed#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xe5776b43636d73accb21bb481deb99e2cf09d8ed#code) changes the signer; only the owner can call it.
- The signer at the block is [0xb15d…74f7](https://etherscan.io/address/0xb15dfb31a96b94ec150a237bfc3d464affe774f7), an account without code.

## Reviewer notes

### Mechanism

validateSignature (src/backend/contracts/manyArtists/evolving/fixedPrices/splitter/Buffer.sol, line 340) recovers a signer on line 346 and tests it on line 347 against the signer it keeps in storage (signer() returns 0xb15dfb31a96b94ec150a237bfc3d464affe774f7). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/backend/contracts/manyArtists/evolving/fixedPrices/splitter/Buffer.sol, line 131) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-06-10, recovering 0xb15d…74f7; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
