---
id: who404-32d3e847-signed-shortcut-lost
format: 2
title: WHO holders whose accounts take real code lose permit
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
  address: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  name: WHO404
  code: verified
  code_url: https://etherscan.io/address/0x32d3e84741a4b79b157dce8270eb4e813d2cda2d#code
  copies: 2
  family: d8a32134c58f68f81fd507f81ea3d4b3
  upgradeable: 'no'
  admin: '0xcdf74bff7c62c72775a2cdb83dbc0a1d4866703a'
value:
  usd: 412
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  file: contracts/ERC404/ERC404.sol
  line: 304
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  file: contracts/ERC404/ERC404.sol
  line: 326
  has: address recoveredAddress = ecrecover(
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  file: contracts/ERC404/ERC404.sol
  line: 142
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  file: contracts/ERC404/ERC404.sol
  line: 350
  has: if (recoveredAddress == address(0) || recoveredAddress != owner_) {
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  fn: totalSupply()(uint256)
  is: 734595617958917125475
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x32d3e84741a4b79b157dce8270eb4e813d2cda2d'
  fn: symbol()(string)
  is: WHO
  says: the token's symbol is WHO
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

The WHO token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x32d3e84741a4b79b157dce8270eb4e813d2cda2d#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0x32d3e84741a4b79b157dce8270eb4e813d2cda2d#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (contracts/ERC404/ERC404.sol, line 304) builds its digest and recovers the signer on line 326; the recovered address must equal the holder (line 350) before the allowance is set. approve (contracts/ERC404/ERC404.sol, line 142) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 734,595,617,958,917,125,475 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
