---
id: bitsafeevmassetbridge-b5d425d6-rotate-signer-before-migrating
format: 2
title: 'BitSafeEvmAssetBridge: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb5d425d678b10949dd0f7bb0dd0427c47451d57e'
  name: BitSafeEvmAssetBridge
  code: verified
  code_url: https://etherscan.io/address/0x228e610f26cfbc366b8f003e124871f8caee78aa#code
  proxy_of: '0x228e610f26cfbc366b8f003e124871f8caee78aa'
  copies: 2
  family: 3a8dddb40d28144e29bb9451bcbb2250
  upgradeable: 'yes'
  admin: '0x393aa3ca8566c10fc5aab740b8fe43cec8f141ad'
value:
  usd: 172384
  basis: held
activity:
  txs_90d: 25
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x228e610f26cfbc366b8f003e124871f8caee78aa'
  file: src/BitSafeEvmAssetBridge.sol
  line: 574
  has: (address signer, ECDSA.RecoverError err,) = ECDSA.tryRecover(digest, signatures[i]);
  says: withdraw recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x228e610f26cfbc366b8f003e124871f8caee78aa'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x228e610f26cfbc366b8f003e124871f8caee78aa'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0x228e610f26cfbc366b8f003e124871f8caee78aa'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xa92e4313894fbe76ced75feb5e6bd059849e18c5'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x05e2dcb613563d2bb6de785fcd137d959ced943b348c708b470b009df38f42b9'
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

BitSafeEvmAssetBridge accepts a call to withdraw only with an ECDSA signature of a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [withdraw](https://etherscan.io/address/0x228e610f26cfbc366b8f003e124871f8caee78aa#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x228e610f26cfbc366b8f003e124871f8caee78aa#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x05e2dcb613563d2bb6de785fcd137d959ced943b348c708b470b009df38f42b9) on record recovered [0xa92e…18c5](https://etherscan.io/address/0xa92e4313894fbe76ced75feb5e6bd059849e18c5), an account without code.

## Reviewer notes

### Mechanism

withdraw (src/BitSafeEvmAssetBridge.sol, line 546) recovers a signer on line 574 and tests it on line 574 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0xa92e…18c5; 25 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
