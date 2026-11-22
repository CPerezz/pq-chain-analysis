---
id: speedpaintings-07586ecf-rotate-signer-before-migrating
format: 2
title: 'SpeedPaintings: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x07586ecf78061c4748ec12bd92ca5d62e763b908'
  name: SpeedPaintings
  code: verified
  code_url: https://etherscan.io/address/0x07586ecf78061c4748ec12bd92ca5d62e763b908#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc91bc8eefb4e297a553273fa2e9af9b7791dc6b8'
value:
  usd: 10
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setAuthorizerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x07586ecf78061c4748ec12bd92ca5d62e763b908'
  file: contracts/Mixins/AuthorizerV1.sol
  line: 41
  has: ECDSA.recover(message, signature_) == authorizerAddress,
  says: requireRecovery recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x07586ecf78061c4748ec12bd92ca5d62e763b908'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x07586ecf78061c4748ec12bd92ca5d62e763b908'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x07586ecf78061c4748ec12bd92ca5d62e763b908'
  file: contracts/Mixins/AuthorizerV1.sol
  line: 56
  has: function setAuthorizerAddress
  says: setAuthorizerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x07586ecf78061c4748ec12bd92ca5d62e763b908'
  fn: authorizer()(address)
  is: '0x4598f4b92c1c2f016b0f3810fecf8417cd805a2f'
  says: The signer it keeps in storage is 0x4598f4b92c1c2f016b0f3810fecf8417cd805a2f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4598f4b92c1c2f016b0f3810fecf8417cd805a2f'
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

SpeedPaintings checks an ECDSA signature in requireRecovery and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthorizerAddress changes the signer.

## Evidence

- [requireRecovery](https://etherscan.io/address/0x07586ecf78061c4748ec12bd92ca5d62e763b908#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthorizerAddress](https://etherscan.io/address/0x07586ecf78061c4748ec12bd92ca5d62e763b908#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4598…5a2f](https://etherscan.io/address/0x4598f4b92c1c2f016b0f3810fecf8417cd805a2f), an account without code.

## Reviewer notes

### Mechanism

requireRecovery (contracts/Mixins/AuthorizerV1.sol, line 32) recovers a signer on line 41 and tests it on line 41 against the signer it keeps in storage (authorizer() returns 0x4598f4b92c1c2f016b0f3810fecf8417cd805a2f). Neither isValidSignature selector is in the code, so that account is never asked. setAuthorizerAddress (contracts/Mixins/AuthorizerV1.sol, line 56) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-11-19, recovering 0x4598…5a2f; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
