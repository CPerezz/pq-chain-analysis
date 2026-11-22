---
id: signedoracle-68ddd0c9-rotate-signer-before-migrating
format: 2
title: 'SignedOracle: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc'
  name: SignedOracle
  code: verified
  code_url: https://etherscan.io/address/0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc#code
  copies: 3
  family: 3203c822f721841a40093df3469295b9
  upgradeable: 'no'
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
  source: '0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc'
  file: src/SignedOracle.sol
  line: 130
  has: (address recovered, ECDSA.RecoverError error,) = ECDSA.tryRecover(digest, v, r, s);
  says: read recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc'
  file: src/SignedOracle.sol
  line: 131
  has: if (error != ECDSA.RecoverError.NoError || recovered != signer) revert BadSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc'
  file: src/SignedOracle.sol
  line: 70
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc'
  fn: signer()(address)
  is: '0x813e746a0b774714fb8b1f937708a8da576d6a0f'
  says: The signer it keeps in storage is 0x813e746a0b774714fb8b1f937708a8da576d6a0f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x813e746a0b774714fb8b1f937708a8da576d6a0f'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x2a74ba9dd99a8b3af5359ed7d9d93806f8aaafa04026d9a0935a39c95e0a94c1'
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

SignedOracle checks an ECDSA signature in read and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [read](https://etherscan.io/address/0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x68ddd0c90c77c9061dd0b2577f1ce79b57878fdc#code) changes the signer.
- The signer at the block is [0x813e…6a0f](https://etherscan.io/address/0x813e746a0b774714fb8b1f937708a8da576d6a0f), an account without code.

## Reviewer notes

### Mechanism

read (src/SignedOracle.sol, line 103) recovers a signer on line 130 and tests it on line 131 against the signer it keeps in storage (signer() returns 0x813e746a0b774714fb8b1f937708a8da576d6a0f). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/SignedOracle.sol, line 70) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-13, recovering 0x813e…6a0f; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
