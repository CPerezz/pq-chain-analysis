---
id: heyedugenesis-720f86db-rotate-signer-before-migrating
format: 2
title: 'HeyEduGenesis: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b'
  name: HeyEduGenesis
  code: verified
  code_url: https://etherscan.io/address/0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b#code
  copies: 2
  family: edc97237a3bcaf74a459e1b7a1588a76
  upgradeable: 'no'
  admin: '0x326f6e9c168b4814bbb496bfda3ac8b5f4b1ab08'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setVoucherSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b'
  file: contracts/HeyEduGenesis.sol
  line: 792
  has: address signedBy = ECDSA.recover(
  says: isVoucherValid recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b'
  file: contracts/HeyEduGenesis.sol
  line: 799
  has: return signedBy == voucherSigner;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b'
  file: contracts/HeyEduGenesis.sol
  line: 777
  has: function setVoucherSigner
  says: setVoucherSigner changes the signer
  for:
  - action
  - evidence-2
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

HeyEduGenesis checks an ECDSA signature in isVoucherValid and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVoucherSigner changes the signer.

## Evidence

- [isVoucherValid](https://etherscan.io/address/0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVoucherSigner](https://etherscan.io/address/0x720f86dbe782f0e6b7b043451a7f4fbf94eb2f9b#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

isVoucherValid (contracts/HeyEduGenesis.sol, line 791) recovers a signer on line 792 and tests it on line 799 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setVoucherSigner (contracts/HeyEduGenesis.sol, line 777) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
