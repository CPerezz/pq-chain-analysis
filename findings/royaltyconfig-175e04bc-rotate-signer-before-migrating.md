---
id: royaltyconfig-175e04bc-rotate-signer-before-migrating
format: 2
title: 'RoyaltyConfig: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x175e04bcb90c8744903307517a9812b408b3defe'
  name: RoyaltyConfig
  code: verified
  code_url: https://etherscan.io/address/0x8f067a697ae2040038443ee1815684461ac7a956#code
  proxy_of: '0x8f067a697ae2040038443ee1815684461ac7a956'
  copies: 2
  family: ad2be7ba8d95a6d0be05877ee61552d3
  upgradeable: 'yes'
  admin: '0xe631110035f2610cd890ba208f8fa32d63135538'
value:
  usd: 574
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x8f067a697ae2040038443ee1815684461ac7a956'
  file: contracts/RoyaltyConfig.sol
  line: 145
  has: require(ECDSA.recover(hash, sign) == signer, "INVALID SIGNER");
  says: setCollectionConfig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8f067a697ae2040038443ee1815684461ac7a956'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8f067a697ae2040038443ee1815684461ac7a956'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x8f067a697ae2040038443ee1815684461ac7a956'
  file: contracts/RoyaltyConfig.sol
  line: 138
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x175e04bcb90c8744903307517a9812b408b3defe'
  fn: signer()(address)
  is: '0x9456cb356038524c4464acef5f563ff5b579fdef'
  says: The signer it keeps in storage is 0x9456cb356038524c4464acef5f563ff5b579fdef at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x9456cb356038524c4464acef5f563ff5b579fdef'
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

RoyaltyConfig accepts a call to setCollectionConfig only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [setCollectionConfig](https://etherscan.io/address/0x8f067a697ae2040038443ee1815684461ac7a956#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x8f067a697ae2040038443ee1815684461ac7a956#code) changes the signer.
- The signer at the block is [0x9456…fdef](https://etherscan.io/address/0x9456cb356038524c4464acef5f563ff5b579fdef), an account without code.

## Reviewer notes

### Mechanism

setCollectionConfig (contracts/RoyaltyConfig.sol, line 142) recovers a signer on line 145 and tests it on line 145 against the signer it keeps in storage (signer() returns 0x9456cb356038524c4464acef5f563ff5b579fdef). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/RoyaltyConfig.sol, line 138) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-11-19, recovering 0x9456…fdef; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
