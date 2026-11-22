---
id: ad-d88b8b8c-rotate-signer-before-migrating
format: 2
title: 'Ad: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a'
  name: Ad
  code: verified
  code_url: https://etherscan.io/address/0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a#code
  copies: 1
  upgradeable: 'no'
  admin: '0xbfc3f52c68406ee159fc9045adc89162d18d15f4'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 221
impact: liveness
action: Replace the signer with setPrePubSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a'
  file: contracts/Ad.sol
  line: 124
  has: address signerAddress = hash.toEthSignedMessageHash().recover(signString);
  says: _verifySinger recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a'
  file: contracts/Ad.sol
  line: 125
  has: return signerAddress == pubPureSaleSigner;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a'
  file: contracts/Ad.sol
  line: 139
  has: function setPrePubSigner
  says: setPrePubSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
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

Ad checks an ECDSA signature in _verifySinger and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPrePubSigner changes the signer.

## Evidence

- [_verifySinger](https://etherscan.io/address/0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPrePubSigner](https://etherscan.io/address/0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

_verifySinger (contracts/Ad.sol, line 122) recovers a signer on line 124 and tests it on line 125 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setPrePubSigner (contracts/Ad.sol, line 139) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-11-03; 221 transactions called the address in the 90 days before the block. 25 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
