---
id: registry-dd0017e4-fixed-signer
format: 2
title: 'Registry: its signer cannot be replaced and must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb'
  name: Registry
  code: verified
  code_url: https://etherscan.io/address/0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb'
  file: src/Registry.sol
  line: 581
  has: (address signer, ECDSA.RecoverError err,) = ECDSA.tryRecover(attestationDigest(a), v, r, s);
  says: _check recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb'
  file: src/Registry.sol
  line: 582
  has: if (err != ECDSA.RecoverError.NoError || signer == address(0) || signer != attester) return 2;
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb'
  file: src/Registry.sol
  line: 234
  has: attester = attester_;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb'
  fn: attester()(address)
  is: '0x5598aa9146215bc13eb26f2c692ad1461fd32982'
  says: A signer fixed at deployment is 0x5598aa9146215bc13eb26f2c692ad1461fd32982 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x5598aa9146215bc13eb26f2c692ad1461fd32982'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x62ae440aba951eafc873c7f81ab85f7c6b195f68f608830efe67122e549c8576'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

Registry checks an ECDSA signature in _check and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [_check](https://etherscan.io/address/0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x5598…2982](https://etherscan.io/address/0x5598aa9146215bc13eb26f2c692ad1461fd32982), an account without code.

## Reviewer notes

### Mechanism

_check (src/Registry.sol, line 562) recovers a signer on line 581 and tests it on line 582 against a signer fixed at deployment (attester() returns 0x5598aa9146215bc13eb26f2c692ad1461fd32982). Neither isValidSignature selector is in the code, so that account is never asked. attester is written on line 234 of src/Registry.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-21, recovering 0x5598…2982; 3 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
