---
id: singularityairdrop-076c54b8-rotate-signer-before-migrating
format: 2
title: 'SingularityAirdrop: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x076c54b8726ad8b9a24ab10d75b2c1494d34890a'
  name: SingularityAirdrop
  code: verified
  code_url: https://etherscan.io/address/0x076c54b8726ad8b9a24ab10d75b2c1494d34890a#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa7a31d206042b8a3e81aa4cf8c68c1b76856ee48'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with updateAuthorizer before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x076c54b8726ad8b9a24ab10d75b2c1494d34890a'
  file: contracts/SingularityAirdrop.sol
  line: 102
  has: address signAddress = ecrecover(message, v, r, s);
  says: _validateClaim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x076c54b8726ad8b9a24ab10d75b2c1494d34890a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x076c54b8726ad8b9a24ab10d75b2c1494d34890a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x076c54b8726ad8b9a24ab10d75b2c1494d34890a'
  file: contracts/SingularityAirdrop.sol
  line: 103
  has: require(signAddress == authorizer, "Invalid request or signature for claim");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x076c54b8726ad8b9a24ab10d75b2c1494d34890a'
  file: contracts/SingularityAirdrop.sol
  line: 44
  has: function updateAuthorizer
  says: updateAuthorizer changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x076c54b8726ad8b9a24ab10d75b2c1494d34890a'
  fn: authorizer()(address)
  is: '0x74f591f22ae7b282a4695e49f7ed1c5f53eec5cb'
  says: The signer it keeps in storage is 0x74f591f22ae7b282a4695e49f7ed1c5f53eec5cb at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x74f591f22ae7b282a4695e49f7ed1c5f53eec5cb'
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

SingularityAirdrop checks an ECDSA signature in _validateClaim and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateAuthorizer changes the signer.

## Evidence

- [_validateClaim](https://etherscan.io/address/0x076c54b8726ad8b9a24ab10d75b2c1494d34890a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateAuthorizer](https://etherscan.io/address/0x076c54b8726ad8b9a24ab10d75b2c1494d34890a#code) changes the signer; only the owner can call it.
- The signer at the block is [0x74f5…c5cb](https://etherscan.io/address/0x74f591f22ae7b282a4695e49f7ed1c5f53eec5cb), an account without code.

## Reviewer notes

### Mechanism

_validateClaim (contracts/SingularityAirdrop.sol, line 88) recovers a signer on line 102 and tests it on line 103 against the signer it keeps in storage (authorizer() returns 0x74f591f22ae7b282a4695e49f7ed1c5f53eec5cb). Neither isValidSignature selector is in the code, so that account is never asked. updateAuthorizer (contracts/SingularityAirdrop.sol, line 44) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-12-09, recovering 0x74f5…c5cb; 1 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
