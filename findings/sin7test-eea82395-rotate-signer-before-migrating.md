---
id: sin7test-eea82395-rotate-signer-before-migrating
format: 2
title: 'Sin7Test: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xeea8239525c1a2527e05343c5f236c8201bc9d9a'
  name: Sin7Test
  code: verified
  code_url: https://etherscan.io/address/0xeea8239525c1a2527e05343c5f236c8201bc9d9a#code
  copies: 2
  family: 9e34bd351b48649bd2281a42cec14475
  admin: '0xbe65debf3506ce82462ac40a692a0e8f1dda9f3a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xeea8239525c1a2527e05343c5f236c8201bc9d9a'
  file: contracts/Sin7.sol
  line: 108
  has: ).toEthSignedMessageHash().recover(_sig);
  says: allowlistMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xeea8239525c1a2527e05343c5f236c8201bc9d9a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xeea8239525c1a2527e05343c5f236c8201bc9d9a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xeea8239525c1a2527e05343c5f236c8201bc9d9a'
  file: contracts/Sin7.sol
  line: 110
  has: if (sig_recover != signer) revert InvalidSignatureError();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xeea8239525c1a2527e05343c5f236c8201bc9d9a'
  file: contracts/Sin7.sol
  line: 144
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xeea8239525c1a2527e05343c5f236c8201bc9d9a'
  fn: signer()(address)
  is: '0xbe65debf3506ce82462ac40a692a0e8f1dda9f3a'
  says: The signer it keeps in storage is 0xbe65debf3506ce82462ac40a692a0e8f1dda9f3a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xbe65debf3506ce82462ac40a692a0e8f1dda9f3a'
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

Sin7Test accepts a call to allowlistMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [allowlistMint](https://etherscan.io/address/0xeea8239525c1a2527e05343c5f236c8201bc9d9a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xeea8239525c1a2527e05343c5f236c8201bc9d9a#code) changes the signer; only the owner can call it.
- The signer at the block is [0xbe65…9f3a](https://etherscan.io/address/0xbe65debf3506ce82462ac40a692a0e8f1dda9f3a), an account without code.

## Reviewer notes

### Mechanism

allowlistMint (contracts/Sin7.sol, line 96) recovers a signer on line 108 and tests it on line 110 against the signer it keeps in storage (signer() returns 0xbe65debf3506ce82462ac40a692a0e8f1dda9f3a). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/Sin7.sol, line 144) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-04-16, recovering 0xbe65…9f3a; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
