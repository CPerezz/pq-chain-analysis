---
id: mixnetminer-0acaecff-rotate-signer-before-migrating
format: 2
title: 'MixnetMiner: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0acaecff55d4f5e40551e51c6c6e7c475b9db935'
  name: MixnetMiner
  code: verified
  code_url: https://etherscan.io/address/0x0acaecff55d4f5e40551e51c6c6e7c475b9db935#code
  copies: 2
  family: 5123d1605307f9843a722015a7ecac11
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setOracle before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0acaecff55d4f5e40551e51c6c6e7c475b9db935'
  file: src/MixnetMiner.sol
  line: 129
  has: address signer = ECDSA.recover(batchDigest(prev, rounds), signature);
  says: settle recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0acaecff55d4f5e40551e51c6c6e7c475b9db935'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0acaecff55d4f5e40551e51c6c6e7c475b9db935'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x0acaecff55d4f5e40551e51c6c6e7c475b9db935'
  file: src/MixnetMiner.sol
  line: 130
  has: if (signer != oracle) revert BadSignature(signer);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x0acaecff55d4f5e40551e51c6c6e7c475b9db935'
  file: src/MixnetMiner.sol
  line: 160
  has: function setOracle
  says: setOracle changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0acaecff55d4f5e40551e51c6c6e7c475b9db935'
  fn: oracle()(address)
  is: '0x8c1cf67859dc18a7aa77241fd0559a2100a5e166'
  says: The signer it keeps in storage is 0x8c1cf67859dc18a7aa77241fd0559a2100a5e166 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8c1cf67859dc18a7aa77241fd0559a2100a5e166'
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

MixnetMiner accepts a call to settle only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOracle changes the signer.

## Evidence

- [settle](https://etherscan.io/address/0x0acaecff55d4f5e40551e51c6c6e7c475b9db935#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOracle](https://etherscan.io/address/0x0acaecff55d4f5e40551e51c6c6e7c475b9db935#code) changes the signer.
- The signer at the block is [0x8c1c…e166](https://etherscan.io/address/0x8c1cf67859dc18a7aa77241fd0559a2100a5e166), an account without code.

## Reviewer notes

### Mechanism

settle (src/MixnetMiner.sol, line 122) recovers a signer on line 129 and tests it on line 130 against the signer it keeps in storage (oracle() returns 0x8c1cf67859dc18a7aa77241fd0559a2100a5e166). Neither isValidSignature selector is in the code, so that account is never asked. setOracle (src/MixnetMiner.sol, line 160) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
