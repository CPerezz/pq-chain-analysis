---
id: kungfutoken-b96afad4-signed-shortcut-lost
format: 2
title: KUNGFU holders whose accounts take real code lose signed vote delegation
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
  address: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  name: KungfuToken
  code: verified
  code_url: https://etherscan.io/address/0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee#code
  copies: 2
  family: ce85aeead1f6cbd9a76d13197cb29ebf
  upgradeable: 'no'
  admin: '0x50b309257ff446ef3ef5ec16fe5d1740882a7356'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that delegateBySig stops once their account takes real code; a direct delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: bysig-fn
  selector: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-body
  source: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  file: KungfuToken.sol
  line: 873
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-1
  - what
- id: bysig-recover
  source: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  file: KungfuToken.sol
  line: 909
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: bysig-acts
  source: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  file: KungfuToken.sol
  line: 913
  has: return _delegate(signatory, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-1
  - what
- id: delegate-body
  source: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  file: KungfuToken.sol
  line: 860
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  fn: totalSupply()(uint256)
  is: 227033203571428571428571408
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee'
  fn: symbol()(string)
  is: KUNGFU
  says: the token's symbol is KUNGFU
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

The KUNGFU token lets a holder delegate its votes with an ECDSA-signed message or with a direct delegate call. A holder whose account takes real code can no longer use delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [delegateBySig](https://etherscan.io/address/0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [delegate](https://etherscan.io/address/0xb96afad41789b4225d1283f9bc25f9e2c9fe40ee#code) delegates the caller's own votes without a signature.

## Reviewer notes

### Mechanism

delegateBySig (KungfuToken.sol, line 873) recovers the signer on line 909 and delegates that signer's votes on line 913. delegate (KungfuToken.sol, line 860) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 227,033,203,571,428,571,428,571,408 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
