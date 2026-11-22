---
id: equolaunchfactory-44d016b2-rotate-signer-before-migrating
format: 2
title: 'EquoLaunchFactory: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2'
  name: EquoLaunchFactory
  code: verified
  code_url: https://etherscan.io/address/0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2#code
  copies: 2
  family: f5654fc27158f4a991dffdcddf379e5d
  upgradeable: 'no'
  admin: '0x5dddea56774f01fc9d207bbd7b7633596a2f4a0b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2'
  file: contracts/v4/equo2/EquoLaunchFactory.sol
  line: 355
  has: if (ECDSA.recover(digest(s), signature) != signer) revert BadSignature();
  says: _launch recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2'
  file: contracts/v4/equo2/EquoLaunchFactory.sol
  line: 229
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2'
  fn: signer()(address)
  is: '0x43ecb6ba1341edead6284d84de3ce061bce209b6'
  says: The signer it keeps in storage is 0x43ecb6ba1341edead6284d84de3ce061bce209b6 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x43ecb6ba1341edead6284d84de3ce061bce209b6'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x92c9e14c10435d9a080067a52decc164777cb775de6e2b2397321336c244cca9'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

EquoLaunchFactory checks an ECDSA signature in _launch and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_launch](https://etherscan.io/address/0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x44d016b20a0c8f0a3791b3ea10ff09af0ece1dc2#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x43ec…09b6](https://etherscan.io/address/0x43ecb6ba1341edead6284d84de3ce061bce209b6), an account without code.

## Reviewer notes

### Mechanism

_launch (contracts/v4/equo2/EquoLaunchFactory.sol, line 348) recovers a signer on line 355 and tests it on line 355 against the signer it keeps in storage (signer() returns 0x43ecb6ba1341edead6284d84de3ce061bce209b6). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/v4/equo2/EquoLaunchFactory.sol, line 229) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-14, recovering 0x43ec…09b6; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
