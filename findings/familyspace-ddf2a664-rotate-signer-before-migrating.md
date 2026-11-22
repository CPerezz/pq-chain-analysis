---
id: familyspace-ddf2a664-rotate-signer-before-migrating
format: 2
title: 'FamilySpace: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xddf2a6644c1750e63eea74619c3b76535cbf5e0c'
  name: FamilySpace
  code: verified
  code_url: https://etherscan.io/address/0x10c66f60adf0e747fa7c043e1a26f5cb32964314#code
  proxy_of: '0x10c66f60adf0e747fa7c043e1a26f5cb32964314'
  copies: 24
  family: ded38fe61e409e489784d2a197bd073a
  upgradeable: 'no'
  admin: '0x7a9e340ef549cfd3ae401e59c8a746d8abb936bb'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with executeGuardianRemoval before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x10c66f60adf0e747fa7c043e1a26f5cb32964314'
  file: src/FamilySpace.sol
  line: 210
  has: (address creatorSigner, , ) = ECDSA.tryRecover(digest, auth.creatorSig.r, auth.creatorSig.vs);
  says: initialize recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x10c66f60adf0e747fa7c043e1a26f5cb32964314'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x10c66f60adf0e747fa7c043e1a26f5cb32964314'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x10c66f60adf0e747fa7c043e1a26f5cb32964314'
  file: src/FamilySpace.sol
  line: 211
  has: if (creatorSigner != auth.creator) revert BadCreatorSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x10c66f60adf0e747fa7c043e1a26f5cb32964314'
  file: src/FamilySpace.sol
  line: 268
  has: function executeGuardianRemoval
  says: executeGuardianRemoval changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xddf2a6644c1750e63eea74619c3b76535cbf5e0c'
  fn: guardian()(address)
  is: '0xacfe9f5b2c59c60dde4a58f3dd535dc21a7a8ef0'
  says: The signer it keeps in storage is 0xacfe9f5b2c59c60dde4a58f3dd535dc21a7a8ef0 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xacfe9f5b2c59c60dde4a58f3dd535dc21a7a8ef0'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x3d2e51f5ded819a493570f666034d9aa07ad538a6d6115e769c421d3b99aac31'
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

FamilySpace accepts a call to initialize only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. executeGuardianRemoval changes the signer.

## Evidence

- [initialize](https://etherscan.io/address/0x10c66f60adf0e747fa7c043e1a26f5cb32964314#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [executeGuardianRemoval](https://etherscan.io/address/0x10c66f60adf0e747fa7c043e1a26f5cb32964314#code) changes the signer.
- The signer at the block is [0xacfe…8ef0](https://etherscan.io/address/0xacfe9f5b2c59c60dde4a58f3dd535dc21a7a8ef0), an account without code.

## Reviewer notes

### Mechanism

initialize (src/FamilySpace.sol, line 200) recovers a signer on line 210 and tests it on line 211 against the signer it keeps in storage (guardian() returns 0xacfe9f5b2c59c60dde4a58f3dd535dc21a7a8ef0). Neither isValidSignature selector is in the code, so that account is never asked. executeGuardianRemoval (src/FamilySpace.sol, line 268) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 24 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-30, recovering 0x97fe…0b02; 5 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
