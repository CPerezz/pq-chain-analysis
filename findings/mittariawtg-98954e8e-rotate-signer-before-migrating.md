---
id: mittariawtg-98954e8e-rotate-signer-before-migrating
format: 2
title: 'MittariaWtg: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x98954e8e24772ecea85710f0987eb50d223cba95'
  name: MittariaWtg
  code: verified
  code_url: https://etherscan.io/address/0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9#code
  proxy_of: '0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9'
  copies: 2
  family: 7580c63f3ec4f49b67b58844a3967832
  upgradeable: 'yes'
  admin: '0x5ce936dc75dd2ce0739cce4feb848615c7312444'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 207
impact: liveness
action: Replace the signer with setVerifier before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9'
  file: contracts/custom-wtg/WTG.sol
  line: 146
  has: address signer = messageHash.toEthSignedMessageHash().recover(_signature);
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9'
  file: contracts/custom-wtg/WTG.sol
  line: 147
  has: require(verifier == signer, "Invalid proof");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9'
  file: contracts/custom-wtg/WTG.sol
  line: 197
  has: function setVerifier
  says: setVerifier changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x98954e8e24772ecea85710f0987eb50d223cba95'
  fn: verifier()(address)
  is: '0x92a6f5e7ed1f96984f778e1f45f542f1e7e42e4d'
  says: The signer it keeps in storage is 0x92a6f5e7ed1f96984f778e1f45f542f1e7e42e4d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x92a6f5e7ed1f96984f778e1f45f542f1e7e42e4d'
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

MittariaWtg checks an ECDSA signature in _verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifier changes the signer.

## Evidence

- [_verifySignature](https://etherscan.io/address/0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVerifier](https://etherscan.io/address/0xe9bbcd277e2c029c8b5f3c744dad93c290ad01a9#code) changes the signer.
- The signer at the block is [0x92a6…2e4d](https://etherscan.io/address/0x92a6f5e7ed1f96984f778e1f45f542f1e7e42e4d), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (contracts/custom-wtg/WTG.sol, line 142) recovers a signer on line 146 and tests it on line 147 against the signer it keeps in storage (verifier() returns 0x92a6f5e7ed1f96984f778e1f45f542f1e7e42e4d). Neither isValidSignature selector is in the code, so that account is never asked. setVerifier (contracts/custom-wtg/WTG.sol, line 197) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-03-21, recovering 0x92a6…2e4d; 207 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
