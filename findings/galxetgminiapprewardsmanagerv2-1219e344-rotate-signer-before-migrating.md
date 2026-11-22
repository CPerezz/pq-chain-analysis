---
id: galxetgminiapprewardsmanagerv2-1219e344-rotate-signer-before-migrating
format: 2
title: 'This contract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1219e344863aa79fe9dee2a023753dbc675e5fd4'
  name: GalxeTGMiniAppRewardsManagerV2
  code: verified
  code_url: https://etherscan.io/address/0xbade0254f709a70c1aebbb6346bcf51ed2ce2137#code
  proxy_of: '0xbade0254f709a70c1aebbb6346bcf51ed2ce2137'
  copies: 2
  family: ad50310ceb545db9aed50c4e6a9a3796
  upgradeable: 'yes'
  admin: '0x73eb342ebc92a4b77942b6cab927ad5faed595be'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 90
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xbade0254f709a70c1aebbb6346bcf51ed2ce2137'
  file: src/GalxeTGMiniAppRewardsManager/GalxeTGMiniAppRewardsManagerV2.sol
  line: 273
  has: return ECDSA.recover(_hash, _signature) == signer;
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbade0254f709a70c1aebbb6346bcf51ed2ce2137'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbade0254f709a70c1aebbb6346bcf51ed2ce2137'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xbade0254f709a70c1aebbb6346bcf51ed2ce2137'
  file: src/GalxeTGMiniAppRewardsManager/GalxeTGMiniAppRewardsManagerV2.sol
  line: 107
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1219e344863aa79fe9dee2a023753dbc675e5fd4'
  fn: signer()(address)
  is: '0x111ae6fe1ad173def8dc36e9dff5144c713f2880'
  says: The signer it keeps in storage is 0x111ae6fe1ad173def8dc36e9dff5144c713f2880 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x111ae6fe1ad173def8dc36e9dff5144c713f2880'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xdf6f30d2c4cd3eeccb3e92cbbe98038f3956013314b98adf92453dbdaa6aac8a'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

This contract checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0xbade0254f709a70c1aebbb6346bcf51ed2ce2137#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xbade0254f709a70c1aebbb6346bcf51ed2ce2137#code) changes the signer; only the owner can call it.
- The signer at the block is [0x111a…2880](https://etherscan.io/address/0x111ae6fe1ad173def8dc36e9dff5144c713f2880), an account without code.

## Reviewer notes

### Mechanism

_verify (src/GalxeTGMiniAppRewardsManager/GalxeTGMiniAppRewardsManagerV2.sol, line 272) recovers a signer on line 273 and tests it on line 273 against the signer it keeps in storage (signer() returns 0x111ae6fe1ad173def8dc36e9dff5144c713f2880). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/GalxeTGMiniAppRewardsManager/GalxeTGMiniAppRewardsManagerV2.sol, line 107) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-24, recovering 0x111a…2880; 90 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
