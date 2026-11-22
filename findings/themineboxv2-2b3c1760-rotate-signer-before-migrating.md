---
id: themineboxv2-2b3c1760-rotate-signer-before-migrating
format: 2
title: 'TheMineBoxV2: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2b3c1760a126275002cf7ea003fa4d513cc89f0d'
  name: TheMineBoxV2
  code: verified
  code_url: https://etherscan.io/address/0xa765f7d5676039301b13146cca9b996864d1d088#code
  proxy_of: '0xa765f7d5676039301b13146cca9b996864d1d088'
  copies: 2
  family: 0ccf723b32ec1f634ae25a525dad535d
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 18674
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xa765f7d5676039301b13146cca9b996864d1d088'
  file: contracts/TheMineBoxV2.sol
  line: 73
  has: address signer = recoverSigner(ethSignedMessageHash, signature);
  says: safeMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa765f7d5676039301b13146cca9b996864d1d088'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa765f7d5676039301b13146cca9b996864d1d088'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0xa765f7d5676039301b13146cca9b996864d1d088'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x65562bab6128dd563f412e308741563266597b14'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe063b929c8b22d4de42c475362ae81dea703065429dd010e9747040e8cc68fdb'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

TheMineBoxV2 accepts a call to safeMint only with an ECDSA signature of a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [safeMint](https://etherscan.io/address/0xa765f7d5676039301b13146cca9b996864d1d088#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xa765f7d5676039301b13146cca9b996864d1d088#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0xe063b929c8b22d4de42c475362ae81dea703065429dd010e9747040e8cc68fdb) on record recovered [0x6556…7b14](https://etherscan.io/address/0x65562bab6128dd563f412e308741563266597b14), an account without code.

## Reviewer notes

### Mechanism

safeMint (contracts/TheMineBoxV2.sol, line 51) recovers a signer on line 73 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0x6556…7b14; 18,674 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
