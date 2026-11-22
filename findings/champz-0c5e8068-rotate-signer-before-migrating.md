---
id: champz-0c5e8068-rotate-signer-before-migrating
format: 2
title: 'Champz: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0c5e8068bb4edbc6512eff42da1f40e67081e3d1'
  name: Champz
  code: verified
  code_url: https://etherscan.io/address/0xe41352732d7987fffa2d2666977646fdecadb95f#code
  proxy_of: '0xe41352732d7987fffa2d2666977646fdecadb95f'
  copies: 2
  family: 3ff1b6bd6bec09a61fc536aba448c039
  upgradeable: 'yes'
  admin: '0x69ee50320ac8adac004563d11473ebe3ffc81893'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 94
impact: liveness
action: Replace the signer with updateSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe41352732d7987fffa2d2666977646fdecadb95f'
  file: contracts/Champz.sol
  line: 258
  has: ).toEthSignedMessageHash().recover(_signature) == _signer,
  says: verifyKeySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe41352732d7987fffa2d2666977646fdecadb95f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe41352732d7987fffa2d2666977646fdecadb95f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe41352732d7987fffa2d2666977646fdecadb95f'
  file: contracts/Champz.sol
  line: 163
  has: function updateSignerAddress
  says: updateSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0c5e8068bb4edbc6512eff42da1f40e67081e3d1'
  fn: _signer()(address)
  is: '0xc45079f030b88c9242624166edceb5b6852a377f'
  says: The signer it keeps in storage is 0xc45079f030b88c9242624166edceb5b6852a377f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc45079f030b88c9242624166edceb5b6852a377f'
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

Champz checks an ECDSA signature in verifyKeySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSignerAddress changes the signer.

## Evidence

- [verifyKeySignature](https://etherscan.io/address/0xe41352732d7987fffa2d2666977646fdecadb95f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSignerAddress](https://etherscan.io/address/0xe41352732d7987fffa2d2666977646fdecadb95f#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc450…377f](https://etherscan.io/address/0xc45079f030b88c9242624166edceb5b6852a377f), an account without code.

## Reviewer notes

### Mechanism

verifyKeySignature (contracts/Champz.sol, line 235) recovers a signer on line 258 and tests it on line 258 against the signer it keeps in storage (_signer() returns 0xc45079f030b88c9242624166edceb5b6852a377f). Neither isValidSignature selector is in the code, so that account is never asked. updateSignerAddress (contracts/Champz.sol, line 163) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-02-22, recovering 0xc450…377f; 94 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
