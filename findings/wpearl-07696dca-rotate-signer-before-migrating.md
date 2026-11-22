---
id: wpearl-07696dca-rotate-signer-before-migrating
format: 2
title: 'WPearl: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x07696dcab55e62cfef953666b29fe1970518cb00'
  name: WPearl
  code: verified
  code_url: https://etherscan.io/address/0xfd03064ff0f29e3113a1198c2694fc8c10bd35e5#code
  proxy_of: '0xfd03064ff0f29e3113a1198c2694fc8c10bd35e5'
  copies: 3
  family: 7652d82cc32952d17ecc59fea243d1e9
  upgradeable: 'yes'
  admin: '0xc07c5b10fa35c0db94ab47484b9f667b7b649762'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 70551
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xfd03064ff0f29e3113a1198c2694fc8c10bd35e5'
  file: contracts/BridgeController.sol
  line: 1492
  has: address signer = ECDSA.recover(digest, signatures[i]);
  says: _verifyAttesterQuorum recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfd03064ff0f29e3113a1198c2694fc8c10bd35e5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfd03064ff0f29e3113a1198c2694fc8c10bd35e5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0xfd03064ff0f29e3113a1198c2694fc8c10bd35e5'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x8ef66adaf4ed6c9c8a0f6d92ce0194596118a54e'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xf9939cc50042134abdabcac35a6b00a3c070c4a17e0b0b6f6f091509e5f553f3'
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

WPearl checks an ECDSA signature in _verifyAttesterQuorum and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_verifyAttesterQuorum](https://etherscan.io/address/0xfd03064ff0f29e3113a1198c2694fc8c10bd35e5#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xfd03064ff0f29e3113a1198c2694fc8c10bd35e5#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0xf9939cc50042134abdabcac35a6b00a3c070c4a17e0b0b6f6f091509e5f553f3) on record recovered [0x8ef6…a54e](https://etherscan.io/address/0x8ef66adaf4ed6c9c8a0f6d92ce0194596118a54e), an account without code.

## Reviewer notes

### Mechanism

_verifyAttesterQuorum (contracts/BridgeController.sol, line 1478) recovers a signer on line 1492 and tests it on line 1492 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x8ef6…a54e; 70,551 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
