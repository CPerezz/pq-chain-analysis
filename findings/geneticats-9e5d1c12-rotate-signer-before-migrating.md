---
id: geneticats-9e5d1c12-rotate-signer-before-migrating
format: 2
title: 'Geneticats: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9e5d1c128294237da2ec39e237783a33db48c78b'
  name: Geneticats
  code: verified
  code_url: https://etherscan.io/address/0x9e5d1c128294237da2ec39e237783a33db48c78b#code
  copies: 1
  upgradeable: 'no'
  admin: '0xd53c79ff8c473bbfe4e40e5525d4d24fd4b8534c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with changePresigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x9e5d1c128294237da2ec39e237783a33db48c78b'
  file: contracts/Geneticats.sol
  line: 307
  has: address recovered = ECDSA.recover(_hash, _signature);
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9e5d1c128294237da2ec39e237783a33db48c78b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9e5d1c128294237da2ec39e237783a33db48c78b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x9e5d1c128294237da2ec39e237783a33db48c78b'
  file: contracts/Geneticats.sol
  line: 308
  has: return (presigner == recovered);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x9e5d1c128294237da2ec39e237783a33db48c78b'
  file: contracts/Geneticats.sol
  line: 112
  has: function changePresigner
  says: changePresigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x9e5d1c128294237da2ec39e237783a33db48c78b'
  fn: presigner()(address)
  is: '0x669f499e7ba51836bb76f7dd2bc3c1a37a5342d7'
  says: The signer it keeps in storage is 0x669f499e7ba51836bb76f7dd2bc3c1a37a5342d7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x669f499e7ba51836bb76f7dd2bc3c1a37a5342d7'
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

Geneticats checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changePresigner changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0x9e5d1c128294237da2ec39e237783a33db48c78b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changePresigner](https://etherscan.io/address/0x9e5d1c128294237da2ec39e237783a33db48c78b#code) changes the signer.
- The signer at the block is [0x669f…42d7](https://etherscan.io/address/0x669f499e7ba51836bb76f7dd2bc3c1a37a5342d7), an account without code.

## Reviewer notes

### Mechanism

verify (contracts/Geneticats.sol, line 298) recovers a signer on line 307 and tests it on line 308 against the signer it keeps in storage (presigner() returns 0x669f499e7ba51836bb76f7dd2bc3c1a37a5342d7). Neither isValidSignature selector is in the code, so that account is never asked. changePresigner (contracts/Geneticats.sol, line 112) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-04-06, recovering 0x669f…42d7; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
