---
id: etherdice-b7fc894f-rotate-signer-before-migrating
format: 2
title: 'EtherDice: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb7fc894f2b6764e114362d303e491709a85c01c2'
  name: EtherDice
  code: verified
  code_url: https://etherscan.io/address/0xb7fc894f2b6764e114362d303e491709a85c01c2#code
  copies: 2
  family: d7eee58f04d746eea4becd6125fa543a
  upgradeable: 'no'
  admin: '0xb477aceb6262b12a3c7b2445027a072f95c75bd3'
value:
  usd: 1077
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSecretSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb7fc894f2b6764e114362d303e491709a85c01c2'
  file: EtherDice.sol
  line: 232
  has: require (secretSigner == ecrecover(keccak256(abi.encodePacked(uint40(commitLastBlock), commit)), v, r, s),
    "EC
  says: placeBet recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb7fc894f2b6764e114362d303e491709a85c01c2'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb7fc894f2b6764e114362d303e491709a85c01c2'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb7fc894f2b6764e114362d303e491709a85c01c2'
  file: EtherDice.sol
  line: 148
  has: function setSecretSigner
  says: setSecretSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xb7fc894f2b6764e114362d303e491709a85c01c2'
  fn: secretSigner()(address)
  is: '0x6211683ecc4e8f653a9232b4c9f2770dd2a03be1'
  says: The signer it keeps in storage is 0x6211683ecc4e8f653a9232b4c9f2770dd2a03be1 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x6211683ecc4e8f653a9232b4c9f2770dd2a03be1'
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

EtherDice accepts a call to placeBet only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSecretSigner changes the signer.

## Evidence

- [placeBet](https://etherscan.io/address/0xb7fc894f2b6764e114362d303e491709a85c01c2#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSecretSigner](https://etherscan.io/address/0xb7fc894f2b6764e114362d303e491709a85c01c2#code) changes the signer; only the owner can call it.
- The signer at the block is [0x6211…3be1](https://etherscan.io/address/0x6211683ecc4e8f653a9232b4c9f2770dd2a03be1), an account without code.

## Reviewer notes

### Mechanism

placeBet (EtherDice.sol, line 220) recovers a signer on line 232 and tests it on line 232 against the signer it keeps in storage (secretSigner() returns 0x6211683ecc4e8f653a9232b4c9f2770dd2a03be1). Neither isValidSignature selector is in the code, so that account is never asked. setSecretSigner (EtherDice.sol, line 148) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2019-09-04, recovering 0x6211…3be1; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
