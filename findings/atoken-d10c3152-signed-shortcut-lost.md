---
id: atoken-d10c3152-signed-shortcut-lost
format: 2
title: rWETH holders whose accounts take real code lose permit
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
  address: '0xd10c315293872851184f484e9431daf4de6aa992'
  name: AToken
  code: verified
  code_url: https://etherscan.io/address/0x30d06a9a992473a6a5d8b54f56bf457fa020794d#code
  proxy_of: '0x30d06a9a992473a6a5d8b54f56bf457fa020794d'
  copies: 21
  family: 141aaada121736923ee942bc98d9e348
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x30d06a9a992473a6a5d8b54f56bf457fa020794d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x30d06a9a992473a6a5d8b54f56bf457fa020794d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0x30d06a9a992473a6a5d8b54f56bf457fa020794d'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x30d06a9a992473a6a5d8b54f56bf457fa020794d'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0x30d06a9a992473a6a5d8b54f56bf457fa020794d'
  file: contracts/mainnet/lending/tokenization/AToken.sol
  line: 329
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x30d06a9a992473a6a5d8b54f56bf457fa020794d'
  file: contracts/mainnet/lending/tokenization/AToken.sol
  line: 349
  has: require(owner == ecrecover(digest, v, r, s), "INVALID_SIGNATURE");
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x30d06a9a992473a6a5d8b54f56bf457fa020794d'
  file: contracts/mainnet/lending/tokenization/IncentivizedERC20.sol
  line: 106
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0xd10c315293872851184f484e9431daf4de6aa992'
  fn: totalSupply()(uint256)
  is: 31678217288130796011
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xd10c315293872851184f484e9431daf4de6aa992'
  fn: symbol()(string)
  is: rWETH
  says: the token's symbol is rWETH
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

The rWETH token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x30d06a9a992473a6a5d8b54f56bf457fa020794d#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0x30d06a9a992473a6a5d8b54f56bf457fa020794d#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (contracts/mainnet/lending/tokenization/AToken.sol, line 329) builds its digest and recovers the signer on line 349; the recovered address must equal the holder (line 349) before the allowance is set. approve (contracts/mainnet/lending/tokenization/IncentivizedERC20.sol, line 106) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 21 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 31,678,217,288,130,796,011 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
