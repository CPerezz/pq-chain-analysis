---
id: listedevmrouterlogic-81a27ff2-rotate-signer-before-migrating
format: 2
title: 'ListedEvmRouterLogic: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x81a27ff244caea0d2ce37706b2f136597e879253'
  name: ListedEvmRouterLogic
  code: verified
  code_url: https://etherscan.io/address/0xf2b9563fb4b5154539e22a4240ba735361d28fd1#code
  proxy_of: '0xf2b9563fb4b5154539e22a4240ba735361d28fd1'
  copies: 2
  family: 76520f9560c73bcd0b81cfb2ffe5aa9a
value:
  usd: 0
  basis: held
activity:
  txs_90d: 8
impact: liveness
action: Replace the signer with setSplitSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xf2b9563fb4b5154539e22a4240ba735361d28fd1'
  file: ListedEvmRouterLogic.sol
  line: 553
  has: if (ecrecover(digest, v, r, vs) != splitSigner) return s;
  says: _parseSplit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf2b9563fb4b5154539e22a4240ba735361d28fd1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf2b9563fb4b5154539e22a4240ba735361d28fd1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf2b9563fb4b5154539e22a4240ba735361d28fd1'
  file: ListedEvmRouterLogic.sol
  line: 559
  has: function setSplitSigner
  says: setSplitSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x81a27ff244caea0d2ce37706b2f136597e879253'
  fn: splitSigner()(address)
  is: '0xfbb4bb92d78fc66be38797378573d33fea355973'
  says: The signer it keeps in storage is 0xfbb4bb92d78fc66be38797378573d33fea355973 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfbb4bb92d78fc66be38797378573d33fea355973'
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

ListedEvmRouterLogic checks an ECDSA signature in _parseSplit and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSplitSigner changes the signer.

## Evidence

- [_parseSplit](https://etherscan.io/address/0xf2b9563fb4b5154539e22a4240ba735361d28fd1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSplitSigner](https://etherscan.io/address/0xf2b9563fb4b5154539e22a4240ba735361d28fd1#code) changes the signer; only the owner can call it.
- The signer at the block is [0xfbb4…5973](https://etherscan.io/address/0xfbb4bb92d78fc66be38797378573d33fea355973), an account without code.

## Reviewer notes

### Mechanism

_parseSplit (ListedEvmRouterLogic.sol, line 502) recovers a signer on line 553 and tests it on line 553 against the signer it keeps in storage (splitSigner() returns 0xfbb4bb92d78fc66be38797378573d33fea355973). Neither isValidSignature selector is in the code, so that account is never asked. setSplitSigner (ListedEvmRouterLogic.sol, line 559) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 8 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
