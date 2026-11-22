---
id: infinitykeysachievement-54b743d6-rotate-signer-before-migrating
format: 2
title: 'InfinityKeysAchievement: replace the signer before it takes real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x54b743d6055e3bbbf13eb2c748a3783516156e5b'
  name: InfinityKeysAchievement
  code: verified
  code_url: https://etherscan.io/address/0x54b743d6055e3bbbf13eb2c748a3783516156e5b#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe2e06703d00790d6af7cc9198cdba8aaa41a30ff'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x54b743d6055e3bbbf13eb2c748a3783516156e5b'
  file: contracts/IK/VerifySigner.sol
  line: 26
  has: address signerCheck = getAddressSigner( _tokenID.toString(), _signature );
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x54b743d6055e3bbbf13eb2c748a3783516156e5b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x54b743d6055e3bbbf13eb2c748a3783516156e5b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x54b743d6055e3bbbf13eb2c748a3783516156e5b'
  file: contracts/IK/VerifySigner.sol
  line: 27
  has: return signerCheck == signer;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x54b743d6055e3bbbf13eb2c748a3783516156e5b'
  file: contracts/IK/VerifySigner.sol
  line: 55
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x247fefef45134228093ac6ce41ee615d327b957e'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

InfinityKeysAchievement checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0x54b743d6055e3bbbf13eb2c748a3783516156e5b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x54b743d6055e3bbbf13eb2c748a3783516156e5b#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x247f…957e](https://etherscan.io/address/0x247fefef45134228093ac6ce41ee615d327b957e), an account without code.

## Reviewer notes

### Mechanism

verify (contracts/IK/VerifySigner.sol, line 25) recovers a signer on line 26 and tests it on line 27 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/IK/VerifySigner.sol, line 55) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-10-13, recovering 0x247f…957e; 13 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
