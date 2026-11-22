---
id: droidinvaders-a9c454ab-rotate-signer-before-migrating
format: 2
title: 'DroidInvaders: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa9c454abac6fd0d177af04c92bfd0445c2a99eed'
  name: DroidInvaders
  code: verified
  code_url: https://etherscan.io/address/0xa9c454abac6fd0d177af04c92bfd0445c2a99eed#code
  copies: 1
  upgradeable: 'no'
  admin: '0x61c814de445cb3b0bca43808138a6e11f3ea1929'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setVerifier before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa9c454abac6fd0d177af04c92bfd0445c2a99eed'
  file: contracts/DroidInvaders.sol
  line: 112
  has: address signer = _recoverWallet(_msgSender(), _count, _signature);
  says: mintWithClaimableStardust recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa9c454abac6fd0d177af04c92bfd0445c2a99eed'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa9c454abac6fd0d177af04c92bfd0445c2a99eed'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xa9c454abac6fd0d177af04c92bfd0445c2a99eed'
  file: contracts/DroidInvaders.sol
  line: 114
  has: require(signer == verifier, "Unverified transaction");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xa9c454abac6fd0d177af04c92bfd0445c2a99eed'
  file: contracts/DroidInvaders.sol
  line: 60
  has: function setVerifier
  says: setVerifier changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xa9c454abac6fd0d177af04c92bfd0445c2a99eed'
  fn: verifier()(address)
  is: '0xf3dbb99573b645419a9cf18f839249d0a246118f'
  says: The signer it keeps in storage is 0xf3dbb99573b645419a9cf18f839249d0a246118f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf3dbb99573b645419a9cf18f839249d0a246118f'
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

DroidInvaders accepts a call to mintWithClaimableStardust only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifier changes the signer.

## Evidence

- [mintWithClaimableStardust](https://etherscan.io/address/0xa9c454abac6fd0d177af04c92bfd0445c2a99eed#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVerifier](https://etherscan.io/address/0xa9c454abac6fd0d177af04c92bfd0445c2a99eed#code) changes the signer; only the owner can call it.
- The signer at the block is [0xf3db…118f](https://etherscan.io/address/0xf3dbb99573b645419a9cf18f839249d0a246118f), an account without code.

## Reviewer notes

### Mechanism

mintWithClaimableStardust (contracts/DroidInvaders.sol, line 109) recovers a signer on line 112 and tests it on line 114 against the signer it keeps in storage (verifier() returns 0xf3dbb99573b645419a9cf18f839249d0a246118f). Neither isValidSignature selector is in the code, so that account is never asked. setVerifier (contracts/DroidInvaders.sol, line 60) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-08-11, recovering 0xf3db…118f; 5 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
