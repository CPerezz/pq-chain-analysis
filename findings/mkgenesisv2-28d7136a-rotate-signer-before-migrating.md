---
id: mkgenesisv2-28d7136a-rotate-signer-before-migrating
format: 2
title: 'MKGenesisV2: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x28d7136aaa5d6c4c0d69c1a3bb3b64b23f696d4e'
  name: MKGenesisV2
  code: verified
  code_url: https://etherscan.io/address/0x7b440943898ce0bae6b646a8525d9ae4cc053506#code
  proxy_of: '0x7b440943898ce0bae6b646a8525d9ae4cc053506'
  copies: 2
  family: 6d74c5d055ab3b744efde76ff200cc28
  upgradeable: 'yes'
  admin: '0x1733340c743b67ac5c7f2dded89d96e5dff73217'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with setAuthSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7b440943898ce0bae6b646a8525d9ae4cc053506'
  file: contracts/MKGenesisV1.sol
  line: 92
  has: address recoveredSigner = recoverSigner(keccak256(b), sig);
  says: migrate recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7b440943898ce0bae6b646a8525d9ae4cc053506'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7b440943898ce0bae6b646a8525d9ae4cc053506'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x7b440943898ce0bae6b646a8525d9ae4cc053506'
  file: contracts/MKGenesisV1.sol
  line: 93
  has: require(recoveredSigner == authSigner, "Invalid sig");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x7b440943898ce0bae6b646a8525d9ae4cc053506'
  file: contracts/MKGenesisV1.sol
  line: 80
  has: function setAuthSigner
  says: setAuthSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x28d7136aaa5d6c4c0d69c1a3bb3b64b23f696d4e'
  fn: authSigner()(address)
  is: '0x5dccb8e93fc26a4c03e07eb165ef2ce5049eda4e'
  says: The signer it keeps in storage is 0x5dccb8e93fc26a4c03e07eb165ef2ce5049eda4e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x5dccb8e93fc26a4c03e07eb165ef2ce5049eda4e'
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

MKGenesisV2 accepts a call to migrate only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthSigner changes the signer.

## Evidence

- [migrate](https://etherscan.io/address/0x7b440943898ce0bae6b646a8525d9ae4cc053506#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthSigner](https://etherscan.io/address/0x7b440943898ce0bae6b646a8525d9ae4cc053506#code) changes the signer; only the owner can call it.
- The signer at the block is [0x5dcc…da4e](https://etherscan.io/address/0x5dccb8e93fc26a4c03e07eb165ef2ce5049eda4e), an account without code.

## Reviewer notes

### Mechanism

migrate (contracts/MKGenesisV1.sol, line 86) recovers a signer on line 92 and tests it on line 93 against the signer it keeps in storage (authSigner() returns 0x5dccb8e93fc26a4c03e07eb165ef2ce5049eda4e). Neither isValidSignature selector is in the code, so that account is never asked. setAuthSigner (contracts/MKGenesisV1.sol, line 80) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-06-20, recovering 0x5dcc…da4e; 3 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
