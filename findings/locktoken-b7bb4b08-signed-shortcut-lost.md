---
id: locktoken-b7bb4b08-signed-shortcut-lost
format: 2
title: LOCK holders whose accounts take real code lose signed vote delegation
status: confirmed
severity: INFORMATIONAL
justification: A holder loses only the signed way, and only by moving its account to real code; the direct call
  still works.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  name: LockToken
  code: verified
  code_url: https://etherscan.io/address/0xb7bb4b08995b96bb5e577c5b02a237a6c625c172#code
  copies: 1
  upgradeable: 'no'
  admin: '0x0e41986db14ed784ff959c26d7fd7f2b7375f074'
value:
  usd: 226
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Tell holders that delegateBySig stops once their account takes real code; a direct delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: bysig-fn
  selector: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-body
  source: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  file: browser/LockToken.sol
  line: 1006
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-1
  - what
- id: bysig-recover
  source: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  file: browser/LockToken.sol
  line: 1031
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: bysig-acts
  source: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  file: browser/LockToken.sol
  line: 1041
  has: return _delegate(signatory, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-1
  - what
- id: delegate-body
  source: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  file: browser/LockToken.sol
  line: 993
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  fn: totalSupply()(uint256)
  is: 22848927852857142857142440
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xb7bb4b08995b96bb5e577c5b02a237a6c625c172'
  fn: symbol()(string)
  is: LOCK
  says: the token's symbol is LOCK
  for:
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

The LOCK token lets a holder delegate its votes with an ECDSA-signed message or with a direct delegate call. A holder whose account takes real code can no longer use delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [delegateBySig](https://etherscan.io/address/0xb7bb4b08995b96bb5e577c5b02a237a6c625c172#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [delegate](https://etherscan.io/address/0xb7bb4b08995b96bb5e577c5b02a237a6c625c172#code) delegates the caller's own votes without a signature.

## Reviewer notes

### Mechanism

delegateBySig (browser/LockToken.sol, line 1006) recovers the signer on line 1031 and delegates that signer's votes on line 1041. delegate (browser/LockToken.sol, line 993) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 22,848,927,852,857,142,857,142,440 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
