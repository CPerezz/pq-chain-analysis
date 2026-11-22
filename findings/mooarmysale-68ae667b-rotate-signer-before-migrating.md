---
id: mooarmysale-68ae667b-rotate-signer-before-migrating
format: 2
title: 'MooArmySale: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x68ae667b79d9fb2cd11e585452c1e1a1c8007220'
  name: MooArmySale
  code: verified
  code_url: https://etherscan.io/address/0x68ae667b79d9fb2cd11e585452c1e1a1c8007220#code
  copies: 2
  family: 76235149ef79ca5521a1f2d78bc4ec89
  upgradeable: 'no'
  admin: '0xcf75121a39c586bc0a67cffe40aff055e2e5756f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setOracleSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x68ae667b79d9fb2cd11e585452c1e1a1c8007220'
  file: src/MooArmySale.sol
  line: 188
  has: address recoveredSigner = _recoverSigner(digest, signature);
  says: buyWithSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x68ae667b79d9fb2cd11e585452c1e1a1c8007220'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x68ae667b79d9fb2cd11e585452c1e1a1c8007220'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x68ae667b79d9fb2cd11e585452c1e1a1c8007220'
  file: src/MooArmySale.sol
  line: 189
  has: if (recoveredSigner != oracleSigner) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x68ae667b79d9fb2cd11e585452c1e1a1c8007220'
  file: src/MooArmySale.sol
  line: 419
  has: function setOracleSigner
  says: setOracleSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x68ae667b79d9fb2cd11e585452c1e1a1c8007220'
  fn: oracleSigner()(address)
  is: '0x4b20f740b1b8faf73ae97ec7cb744e9f6048eed2'
  says: The signer it keeps in storage is 0x4b20f740b1b8faf73ae97ec7cb744e9f6048eed2 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4b20f740b1b8faf73ae97ec7cb744e9f6048eed2'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x995178f67c80df4add30eb2a79c5d6340fe90576b045ec6802c146b71f5f4447'
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

MooArmySale accepts a call to buyWithSignature only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOracleSigner changes the signer.

## Evidence

- [buyWithSignature](https://etherscan.io/address/0x68ae667b79d9fb2cd11e585452c1e1a1c8007220#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOracleSigner](https://etherscan.io/address/0x68ae667b79d9fb2cd11e585452c1e1a1c8007220#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4b20…eed2](https://etherscan.io/address/0x4b20f740b1b8faf73ae97ec7cb744e9f6048eed2), an account without code.

## Reviewer notes

### Mechanism

buyWithSignature (src/MooArmySale.sol, line 171) recovers a signer on line 188 and tests it on line 189 against the signer it keeps in storage (oracleSigner() returns 0x4b20f740b1b8faf73ae97ec7cb744e9f6048eed2). Neither isValidSignature selector is in the code, so that account is never asked. setOracleSigner (src/MooArmySale.sol, line 419) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-02, recovering 0x4b20…eed2; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
