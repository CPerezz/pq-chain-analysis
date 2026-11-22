---
id: eggtoken-a1b51a1b-signed-shortcut-lost
format: 2
title: EGG holders whose accounts take real code lose signed vote delegation
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
  address: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  name: EggToken
  code: verified
  code_url: https://etherscan.io/address/0xa1b51a1b99acca9d87ad98d373750146204f7d6b#code
  copies: 2
  family: 4a1cf023f33d7cc9c45400f35ba8a3da
  upgradeable: 'no'
  admin: '0xd499dcf3e5b7d60fc4ccdd556a5f1201c72248ec'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that delegateBySig stops once their account takes real code; a direct delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: bysig-fn
  selector: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-body
  source: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  file: EggToken.sol
  line: 1202
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-1
  - what
- id: bysig-recover
  source: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  file: EggToken.sol
  line: 1238
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: bysig-acts
  source: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  file: EggToken.sol
  line: 1242
  has: return _delegate(signatory, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-1
  - what
- id: delegate-body
  source: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  file: EggToken.sol
  line: 1189
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  fn: totalSupply()(uint256)
  is: 32000000000000000015744
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xa1b51a1b99acca9d87ad98d373750146204f7d6b'
  fn: symbol()(string)
  is: EGG
  says: the token's symbol is EGG
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

The EGG token lets a holder delegate its votes with an ECDSA-signed message or with a direct delegate call. A holder whose account takes real code can no longer use delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [delegateBySig](https://etherscan.io/address/0xa1b51a1b99acca9d87ad98d373750146204f7d6b#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [delegate](https://etherscan.io/address/0xa1b51a1b99acca9d87ad98d373750146204f7d6b#code) delegates the caller's own votes without a signature.

## Reviewer notes

### Mechanism

delegateBySig (EggToken.sol, line 1202) recovers the signer on line 1238 and delegates that signer's votes on line 1242. delegate (EggToken.sol, line 1189) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 32,000,000,000,000,000,015,744 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
