---
id: lockerregistrar-8b0f19b4-rotate-signer-before-migrating
format: 2
title: 'LockerRegistrar: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8b0f19b4cf56cac3552d7df1d95da60660695e78'
  name: LockerRegistrar
  code: verified
  code_url: https://etherscan.io/address/0x8b0f19b4cf56cac3552d7df1d95da60660695e78#code
  copies: 1
  admin: '0x3c6bac3533f843235a734821487a2635bd43f10f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 101
impact: liveness
action: Before a signer's account moves to real code, use addAdmin so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x8b0f19b4cf56cac3552d7df1d95da60660695e78'
  file: src/LockerRegistrar.sol
  line: 259
  has: address signer = ECDSA.recover(digest, signature);
  says: _consumeSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8b0f19b4cf56cac3552d7df1d95da60660695e78'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8b0f19b4cf56cac3552d7df1d95da60660695e78'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x8b0f19b4cf56cac3552d7df1d95da60660695e78'
  file: src/LockerRegistrar.sol
  line: 260
  has: if (!admins[signer]) revert InvalidSignature();
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x8b0f19b4cf56cac3552d7df1d95da60660695e78'
  file: src/LockerRegistrar.sol
  line: 231
  has: function addAdmin
  says: addAdmin changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x244a630fffe8d1e0e46cbef12cb9e2246e96d67f'
  is: delegation
  target: '0xd6cedde84be40893d153be9d467cd6ad37875b28'
  says: 'the address recovered in the latest signature check on record holds an EIP-7702 delegation: an ECDSA key
    still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xb9edefa51566450b761f99c558ea81b7c87e163673f47a155b9e6e01568c881f'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

LockerRegistrar checks an ECDSA signature in _consumeSignature and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addAdmin changes who may sign.

## Evidence

- [_consumeSignature](https://etherscan.io/address/0x8b0f19b4cf56cac3552d7df1d95da60660695e78#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addAdmin](https://etherscan.io/address/0x8b0f19b4cf56cac3552d7df1d95da60660695e78#code) changes who may sign; only a role holder can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xb9edefa51566450b761f99c558ea81b7c87e163673f47a155b9e6e01568c881f) on record recovered [0x244a…d67f](https://etherscan.io/address/0x244a630fffe8d1e0e46cbef12cb9e2246e96d67f), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_consumeSignature (src/LockerRegistrar.sol, line 252) recovers a signer on line 259 and tests it on line 260 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addAdmin (src/LockerRegistrar.sol, line 231) writes it. The signer's account holds an EIP-7702 delegation to 0xd6cedde84be40893d153be9d467cd6ad37875b28. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-07, recovering 0x244a…d67f; 101 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
