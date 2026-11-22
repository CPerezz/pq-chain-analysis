---
id: mintcontrol-db5070d7-rotate-signer-before-migrating
format: 2
title: 'MintControl: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdb5070d7494891c75f8e46d6bd1b74d6fe54fa81'
  name: MintControl
  code: verified
  code_url: https://etherscan.io/address/0xfaa01b43cda3731525f8a0ebeb6bf097501f2517#code
  proxy_of: '0xfaa01b43cda3731525f8a0ebeb6bf097501f2517'
  copies: 2
  family: 0a2920d6fe13d0a1c481cdb1cf6b1005
  upgradeable: 'yes'
  admin: '0xf5f5ff338530bfa83464cd6d1d50651f2a465ed2'
value:
  usd: 496
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with openWhiteList before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfaa01b43cda3731525f8a0ebeb6bf097501f2517'
  file: contracts/MintControl.sol
  line: 100
  has: return whitelistAdmin == hash.recover(signature);
  says: isAuthorized recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfaa01b43cda3731525f8a0ebeb6bf097501f2517'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfaa01b43cda3731525f8a0ebeb6bf097501f2517'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xfaa01b43cda3731525f8a0ebeb6bf097501f2517'
  file: contracts/MintControl.sol
  line: 83
  has: function openWhiteList
  says: openWhiteList changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xdb5070d7494891c75f8e46d6bd1b74d6fe54fa81'
  fn: whitelistAdmin()(address)
  is: '0x24eb98ef270fa36308cd0e880d867f9d185a5723'
  says: The signer it keeps in storage is 0x24eb98ef270fa36308cd0e880d867f9d185a5723 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x24eb98ef270fa36308cd0e880d867f9d185a5723'
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

MintControl checks an ECDSA signature in isAuthorized and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. openWhiteList changes the signer.

## Evidence

- [isAuthorized](https://etherscan.io/address/0xfaa01b43cda3731525f8a0ebeb6bf097501f2517#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [openWhiteList](https://etherscan.io/address/0xfaa01b43cda3731525f8a0ebeb6bf097501f2517#code) changes the signer; only the owner can call it.
- The signer at the block is [0x24eb…5723](https://etherscan.io/address/0x24eb98ef270fa36308cd0e880d867f9d185a5723), an account without code.

## Reviewer notes

### Mechanism

isAuthorized (contracts/MintControl.sol, line 98) recovers a signer on line 100 and tests it on line 100 against the signer it keeps in storage (whitelistAdmin() returns 0x24eb98ef270fa36308cd0e880d867f9d185a5723). Neither isValidSignature selector is in the code, so that account is never asked. openWhiteList (contracts/MintControl.sol, line 83) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-11-19, recovering 0x24eb…5723; 0 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
