---
id: cupcatcatgirls-1aaddcf6-rotate-signer-before-migrating
format: 2
title: 'CupcatCatGirls: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1aaddcf6749e6a56b1c704cd30221df00a08659c'
  name: CupcatCatGirls
  code: verified
  code_url: https://etherscan.io/address/0x1aaddcf6749e6a56b1c704cd30221df00a08659c#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe0e37805369b2f67087f117f9153edf34db2e570'
value:
  usd: 90
  basis: held
activity:
  txs_90d: 23
impact: liveness
action: Replace the signer with setCupcatSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1aaddcf6749e6a56b1c704cd30221df00a08659c'
  file: contracts/cgv4.sol
  line: 51
  has: require(verifySig(wlSpot, signature) == authorizedSigner, "Signer address mismatch");
  says: whiteListMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1aaddcf6749e6a56b1c704cd30221df00a08659c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1aaddcf6749e6a56b1c704cd30221df00a08659c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x1aaddcf6749e6a56b1c704cd30221df00a08659c'
  file: contracts/cgv4.sol
  line: 121
  has: function setCupcatSigner
  says: setCupcatSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1aaddcf6749e6a56b1c704cd30221df00a08659c'
  fn: authorizedSigner()(address)
  is: '0x486662389b41b3921491547a9ad0507cd3c8dd5d'
  says: The signer it keeps in storage is 0x486662389b41b3921491547a9ad0507cd3c8dd5d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x486662389b41b3921491547a9ad0507cd3c8dd5d'
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

CupcatCatGirls accepts a call to whiteListMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setCupcatSigner changes the signer.

## Evidence

- [whiteListMint](https://etherscan.io/address/0x1aaddcf6749e6a56b1c704cd30221df00a08659c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setCupcatSigner](https://etherscan.io/address/0x1aaddcf6749e6a56b1c704cd30221df00a08659c#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4866…dd5d](https://etherscan.io/address/0x486662389b41b3921491547a9ad0507cd3c8dd5d), an account without code.

## Reviewer notes

### Mechanism

whiteListMint (contracts/cgv4.sol, line 46) recovers a signer on line 51 and tests it on line 51 against the signer it keeps in storage (authorizedSigner() returns 0x486662389b41b3921491547a9ad0507cd3c8dd5d). Neither isValidSignature selector is in the code, so that account is never asked. setCupcatSigner (contracts/cgv4.sol, line 121) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-13, recovering 0x4866…dd5d; 23 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
