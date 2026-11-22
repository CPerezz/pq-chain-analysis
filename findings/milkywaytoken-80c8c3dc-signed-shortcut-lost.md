---
id: milkywaytoken-80c8c3dc-signed-shortcut-lost
format: 2
title: MILK2 holders whose accounts take real code lose signed vote delegation
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
  address: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  name: MilkyWayToken
  code: verified
  code_url: https://etherscan.io/address/0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de#code
  copies: 2
  family: d3ba991043ae3cf74ca5e9b92caa508e
  upgradeable: 'no'
  admin: '0xdedb5f78dabf7541c3367080695eb51458cd5317'
value:
  usd: 165
  basis: held
activity: {}
impact: liveness
action: Tell holders that delegateBySig stops once their account takes real code; a direct delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: bysig-fn
  selector: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-body
  source: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  file: MilkyWayToken.sol
  line: 906
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-1
  - what
- id: bysig-recover
  source: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  file: MilkyWayToken.sol
  line: 942
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: bysig-acts
  source: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  file: MilkyWayToken.sol
  line: 946
  has: return _delegate(signatory, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-1
  - what
- id: delegate-body
  source: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  file: MilkyWayToken.sol
  line: 893
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  fn: totalSupply()(uint256)
  is: 22056260473608963324791073
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de'
  fn: symbol()(string)
  is: MILK2
  says: the token's symbol is MILK2
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

The MILK2 token lets a holder delegate its votes with an ECDSA-signed message or with a direct delegate call. A holder whose account takes real code can no longer use delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [delegateBySig](https://etherscan.io/address/0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [delegate](https://etherscan.io/address/0x80c8c3dcfb854f9542567c8dac3f44d709ebc1de#code) delegates the caller's own votes without a signature.

## Reviewer notes

### Mechanism

delegateBySig (MilkyWayToken.sol, line 906) recovers the signer on line 942 and delegates that signer's votes on line 946. delegate (MilkyWayToken.sol, line 893) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 22,056,260,473,608,963,324,791,073 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
