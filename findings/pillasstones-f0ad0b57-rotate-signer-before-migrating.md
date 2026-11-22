---
id: pillasstones-f0ad0b57-rotate-signer-before-migrating
format: 2
title: 'PillasStones: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a'
  name: PillasStones
  code: verified
  code_url: https://etherscan.io/address/0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a#code
  copies: 1
  admin: '0xc555b97413b53dacf142a93399268f2a62d793f0'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a'
  file: src/PillasStones.sol
  line: 140
  has: if (ECDSA.recover(digest, sig) != signer) revert BadSignature();
  says: burnToMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a'
  file: src/PillasStones.sol
  line: 286
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a'
  fn: signer()(address)
  is: '0xe779de6a510ea4b0aa94d73d9d4247e08e34cdf9'
  says: The signer it keeps in storage is 0xe779de6a510ea4b0aa94d73d9d4247e08e34cdf9 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe779de6a510ea4b0aa94d73d9d4247e08e34cdf9'
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

PillasStones accepts a call to burnToMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [burnToMint](https://etherscan.io/address/0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xf0ad0b574f95b9d1d81a9dae5207baf4fd4f8b4a#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe779…cdf9](https://etherscan.io/address/0xe779de6a510ea4b0aa94d73d9d4247e08e34cdf9), an account without code.

## Reviewer notes

### Mechanism

burnToMint (src/PillasStones.sol, line 125) recovers a signer on line 140 and tests it on line 140 against the signer it keeps in storage (signer() returns 0xe779de6a510ea4b0aa94d73d9d4247e08e34cdf9). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/PillasStones.sol, line 286) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
