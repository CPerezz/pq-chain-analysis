---
id: referral-aca282fb-rotate-signer-before-migrating
format: 2
title: 'Referral: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xaca282fbda8eabdcc156d6dbb6e63937823fc212'
  name: Referral
  code: verified
  code_url: https://etherscan.io/address/0xaca282fbda8eabdcc156d6dbb6e63937823fc212#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8d5d41ae0aeacd591515f442d30759716707337c'
value:
  usd: 240
  basis: held
activity:
  txs_90d: 8
impact: liveness
action: Replace the signer with setSmartWalletOwner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xaca282fbda8eabdcc156d6dbb6e63937823fc212'
  file: bdc_fixed.sol
  line: 1806
  has: address signer = hash.recover(_signature);
  says: setSizeAndCount recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xaca282fbda8eabdcc156d6dbb6e63937823fc212'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xaca282fbda8eabdcc156d6dbb6e63937823fc212'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xaca282fbda8eabdcc156d6dbb6e63937823fc212'
  file: bdc_fixed.sol
  line: 1807
  has: require(signer == SmartWalletOwner, "Signature is invalid");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xaca282fbda8eabdcc156d6dbb6e63937823fc212'
  file: bdc_fixed.sol
  line: 2183
  has: function setSmartWalletOwner
  says: setSmartWalletOwner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xaca282fbda8eabdcc156d6dbb6e63937823fc212'
  fn: SmartWalletOwner()(address)
  is: '0xddd6c26449617db919519cd6b39a16f28a855231'
  says: The signer it keeps in storage is 0xddd6c26449617db919519cd6b39a16f28a855231 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xddd6c26449617db919519cd6b39a16f28a855231'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x559766b4934315bf12062d342601ce8d8c3b648088b9fa17088986ef8246e6ae'
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

Referral accepts a call to setSizeAndCount only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSmartWalletOwner changes the signer.

## Evidence

- [setSizeAndCount](https://etherscan.io/address/0xaca282fbda8eabdcc156d6dbb6e63937823fc212#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSmartWalletOwner](https://etherscan.io/address/0xaca282fbda8eabdcc156d6dbb6e63937823fc212#code) changes the signer; only the owner can call it.
- The signer at the block is [0xddd6…5231](https://etherscan.io/address/0xddd6c26449617db919519cd6b39a16f28a855231), an account without code.

## Reviewer notes

### Mechanism

setSizeAndCount (bdc_fixed.sol, line 1797) recovers a signer on line 1806 and tests it on line 1807 against the signer it keeps in storage (SmartWalletOwner() returns 0xddd6c26449617db919519cd6b39a16f28a855231). Neither isValidSignature selector is in the code, so that account is never asked. setSmartWalletOwner (bdc_fixed.sol, line 2183) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-07, recovering 0xddd6…5231; 8 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
