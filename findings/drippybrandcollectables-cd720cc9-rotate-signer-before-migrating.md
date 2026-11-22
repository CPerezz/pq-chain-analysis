---
id: drippybrandcollectables-cd720cc9-rotate-signer-before-migrating
format: 2
title: 'DrippyBrandCollectables: replace the signer before it takes real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcd720cc9d1957896e61fd9af87c53ec899ad92d3'
  name: DrippyBrandCollectables
  code: verified
  code_url: https://etherscan.io/address/0xcd720cc9d1957896e61fd9af87c53ec899ad92d3#code
  copies: 8
  family: ce535869983f6df1f3af18269f37ea0e
  upgradeable: 'no'
  admin: '0xdb9e2e04273ee289156aba19f728d190ae4277f5'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcd720cc9d1957896e61fd9af87c53ec899ad92d3'
  file: contracts/DrippyBrandCollectables.sol
  line: 1576
  has: return signerAddress == hash.recover(signature);
  says: matchAddresSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcd720cc9d1957896e61fd9af87c53ec899ad92d3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcd720cc9d1957896e61fd9af87c53ec899ad92d3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xcd720cc9d1957896e61fd9af87c53ec899ad92d3'
  file: contracts/DrippyBrandCollectables.sol
  line: 1685
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x862d16c915a0e8dab9c8c499871bbea07a90a3bc'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

DrippyBrandCollectables checks an ECDSA signature in matchAddresSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [matchAddresSigner](https://etherscan.io/address/0xcd720cc9d1957896e61fd9af87c53ec899ad92d3#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xcd720cc9d1957896e61fd9af87c53ec899ad92d3#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x862d…a3bc](https://etherscan.io/address/0x862d16c915a0e8dab9c8c499871bbea07a90a3bc), an account without code.

## Reviewer notes

### Mechanism

matchAddresSigner (contracts/DrippyBrandCollectables.sol, line 1575) recovers a signer on line 1576 and tests it on line 1576 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/DrippyBrandCollectables.sol, line 1685) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 8 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-02-20, recovering 0x862d…a3bc; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
