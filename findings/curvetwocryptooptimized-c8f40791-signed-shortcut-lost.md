---
id: curvetwocryptooptimized-c8f40791-signed-shortcut-lost
format: 2
title: YLAYETH holders whose accounts take real code lose permit
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
  address: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  name: CurveTwocryptoOptimized
  code: verified
  code_url: https://etherscan.io/address/0xc8f40791b6c2ff6ae42836d3966b11874432edeb#code
  copies: 1
  admin: '0xeda0108d5bb8cde2ba4a59e22f3ed5d211c77187'
value:
  usd: 4681
  basis: held
activity:
  txs_90d: 298
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  file: CurveTwocryptoOptimized.vy
  line: 1366
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  file: CurveTwocryptoOptimized.vy
  line: 1406
  has: assert ecrecover(digest, _v, _r, _s) == _owner
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  file: CurveTwocryptoOptimized.vy
  line: 1352
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  fn: totalSupply()(uint256)
  is: 3086833055443418399023
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xc8f40791b6c2ff6ae42836d3966b11874432edeb'
  fn: symbol()(string)
  is: YLAYETH
  says: the token's symbol is YLAYETH
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

The YLAYETH token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xc8f40791b6c2ff6ae42836d3966b11874432edeb#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0xc8f40791b6c2ff6ae42836d3966b11874432edeb#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (CurveTwocryptoOptimized.vy, line 1366) builds its digest and recovers the signer on line 1406; the recovered address must equal the holder (line 1406) before the allowance is set. approve (CurveTwocryptoOptimized.vy, line 1352) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 3,086,833,055,443,418,399,023 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
