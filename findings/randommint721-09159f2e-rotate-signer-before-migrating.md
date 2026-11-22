---
id: randommint721-09159f2e-rotate-signer-before-migrating
format: 2
title: 'RandomMint721: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x09159f2ea7ee66c8da346c0891eb81eb9068d2bf'
  name: RandomMint721
  code: verified
  code_url: https://etherscan.io/address/0xcc08b622e77f0549e9ec4e80f0eb575d6d125ebc#code
  proxy_of: '0xcc08b622e77f0549e9ec4e80f0eb575d6d125ebc'
  copies: 15
  family: 32a23913bcf83a866d244fceb135cd0b
  upgradeable: 'no'
  admin: '0x5375d5b568e0c9e78466b340991c2f6acd121103'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcc08b622e77f0549e9ec4e80f0eb575d6d125ebc'
  file: contracts/libraries/SignatureProtected.sol
  line: 28
  has: ECDSA.recover(generateHash(packedParams), signature) ==
  says: validateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcc08b622e77f0549e9ec4e80f0eb575d6d125ebc'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcc08b622e77f0549e9ec4e80f0eb575d6d125ebc'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xcc08b622e77f0549e9ec4e80f0eb575d6d125ebc'
  file: contracts/libraries/SignatureProtected.sol
  line: 19
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x09159f2ea7ee66c8da346c0891eb81eb9068d2bf'
  fn: signerAddress()(address)
  is: '0xe16c1623c1aa7d919cd2241d8b36d9e79c1be2a2'
  says: The signer it keeps in storage is 0xe16c1623c1aa7d919cd2241d8b36d9e79c1be2a2 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xe16c1623c1aa7d919cd2241d8b36d9e79c1be2a2'
  is: delegation
  target: '0x8a67b5020ee254ef48e3b6a04927f39baf7e408a'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
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

RandomMint721 checks an ECDSA signature in validateSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [validateSignature](https://etherscan.io/address/0xcc08b622e77f0549e9ec4e80f0eb575d6d125ebc#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xcc08b622e77f0549e9ec4e80f0eb575d6d125ebc#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe16c…e2a2](https://etherscan.io/address/0xe16c1623c1aa7d919cd2241d8b36d9e79c1be2a2), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

validateSignature (contracts/libraries/SignatureProtected.sol, line 23) recovers a signer on line 28 and tests it on line 28 against the signer it keeps in storage (signerAddress() returns 0xe16c1623c1aa7d919cd2241d8b36d9e79c1be2a2). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/libraries/SignatureProtected.sol, line 19) writes it. The signer's account holds an EIP-7702 delegation to 0x8a67b5020ee254ef48e3b6a04927f39baf7e408a. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 15 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
