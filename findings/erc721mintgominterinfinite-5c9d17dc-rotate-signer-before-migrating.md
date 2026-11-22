---
id: erc721mintgominterinfinite-5c9d17dc-rotate-signer-before-migrating
format: 2
title: 'This contract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0'
  name: ERC721MintGoMinterInfinite
  code: verified
  code_url: https://etherscan.io/address/0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0#code
  copies: 1
  upgradeable: 'no'
  admin: '0xaf368a9f36752b9b2c4d34a08ebcc19dba42dc85'
value:
  usd: 16
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setAuthorizedSigningAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0'
  file: mainnet/0x521dd9162786CDB4DfE66E137958f194dC6770db/contracts/v3/ERC721MintGoMinterInfinite.sol
  line: 111
  has: address signer = ecrecover(hash, v, r, s);
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0'
  file: mainnet/0x521dd9162786CDB4DfE66E137958f194dC6770db/contracts/v3/ERC721MintGoMinterInfinite.sol
  line: 112
  has: require(signer == authorizedSigningAddress, "invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0'
  file: mainnet/0x521dd9162786CDB4DfE66E137958f194dC6770db/contracts/v3/ERC721MintGoMinterInfinite.sol
  line: 59
  has: function setAuthorizedSigningAddress
  says: setAuthorizedSigningAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0'
  fn: authorizedSigningAddress()(address)
  is: '0x900b3fd2275126f0cc0721e7df6be61768533d0a'
  says: The signer it keeps in storage is 0x900b3fd2275126f0cc0721e7df6be61768533d0a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x900b3fd2275126f0cc0721e7df6be61768533d0a'
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

This contract accepts a call to mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthorizedSigningAddress changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthorizedSigningAddress](https://etherscan.io/address/0x5c9d17dc0a38c1b67554193f43ca6a6c30342ed0#code) changes the signer; only the owner can call it.
- The signer at the block is [0x900b…3d0a](https://etherscan.io/address/0x900b3fd2275126f0cc0721e7df6be61768533d0a), an account without code.

## Reviewer notes

### Mechanism

mint (mainnet/0x521dd9162786CDB4DfE66E137958f194dC6770db/contracts/v3/ERC721MintGoMinterInfinite.sol, line 91) recovers a signer on line 111 and tests it on line 112 against the signer it keeps in storage (authorizedSigningAddress() returns 0x900b3fd2275126f0cc0721e7df6be61768533d0a). Neither isValidSignature selector is in the code, so that account is never asked. setAuthorizedSigningAddress (mainnet/0x521dd9162786CDB4DfE66E137958f194dC6770db/contracts/v3/ERC721MintGoMinterInfinite.sol, line 59) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-08-04, recovering 0x900b…3d0a; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
