---
id: memecoinfiresalev1-b9879cd0-rotate-signer-before-migrating
format: 2
title: 'MemecoinFiresaleV1: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb9879cd06c904c2fdbc75d03534929b5e842f3a0'
  name: MemecoinFiresaleV1
  code: verified
  code_url: https://etherscan.io/address/0x8726e455769d5c58c4ad8453c0c4b7ae116f3113#code
  proxy_of: '0x8726e455769d5c58c4ad8453c0c4b7ae116f3113'
  copies: 2
  family: 9570ae10544b2ac6f5ab73552996e2a3
  upgradeable: 'yes'
  admin: '0x21e14f503b03f43ebc4b779261d787183a54ec4b'
value:
  usd: 1999
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x8726e455769d5c58c4ad8453c0c4b7ae116f3113'
  file: contracts/firesale/MemecoinFiresaleV1.sol
  line: 147
  has: return signedHash.recover(_signature) == signer;
  says: _checkValidity recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8726e455769d5c58c4ad8453c0c4b7ae116f3113'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8726e455769d5c58c4ad8453c0c4b7ae116f3113'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x8726e455769d5c58c4ad8453c0c4b7ae116f3113'
  file: contracts/firesale/MemecoinFiresaleV1.sol
  line: 180
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xb9879cd06c904c2fdbc75d03534929b5e842f3a0'
  fn: signer()(address)
  is: '0xe582e9da118f5752ad5971c12989702d5470ebef'
  says: The signer it keeps in storage is 0xe582e9da118f5752ad5971c12989702d5470ebef at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe582e9da118f5752ad5971c12989702d5470ebef'
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

MemecoinFiresaleV1 checks an ECDSA signature in _checkValidity and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_checkValidity](https://etherscan.io/address/0x8726e455769d5c58c4ad8453c0c4b7ae116f3113#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x8726e455769d5c58c4ad8453c0c4b7ae116f3113#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe582…ebef](https://etherscan.io/address/0xe582e9da118f5752ad5971c12989702d5470ebef), an account without code.

## Reviewer notes

### Mechanism

_checkValidity (contracts/firesale/MemecoinFiresaleV1.sol, line 139) recovers a signer on line 147 and tests it on line 147 against the signer it keeps in storage (signer() returns 0xe582e9da118f5752ad5971c12989702d5470ebef). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/firesale/MemecoinFiresaleV1.sol, line 180) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-01-17, recovering 0xe582…ebef; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
