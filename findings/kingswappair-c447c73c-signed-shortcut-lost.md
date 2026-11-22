---
id: kingswappair-c447c73c-signed-shortcut-lost
format: 2
title: KLP holders whose accounts take real code lose permit
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
  address: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  name: KingSwapPair
  code: verified
  code_url: https://etherscan.io/address/0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c#code
  copies: 12
  family: ec1084dead15d88251963be970c32522
  upgradeable: 'no'
value:
  usd: 202
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  file: contracts/kingswap/KingSwapERC20.sol
  line: 81
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  file: contracts/kingswap/KingSwapERC20.sol
  line: 90
  has: address recoveredAddress = ecrecover(digest, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  file: contracts/kingswap/KingSwapERC20.sol
  line: 63
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  file: contracts/kingswap/KingSwapERC20.sol
  line: 91
  has: 'require(recoveredAddress != address(0) && recoveredAddress == owner, "KingSwap: INVALID_SIGNATURE");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  fn: totalSupply()(uint256)
  is: 2323432805139
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c'
  fn: symbol()(string)
  is: KLP
  says: the token's symbol is KLP
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

The KLP token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0xc447c73c8e395e4f5c272d3ba40bb40ca5f23e1c#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (contracts/kingswap/KingSwapERC20.sol, line 81) builds its digest and recovers the signer on line 90; the recovered address must equal the holder (line 91) before the allowance is set. approve (contracts/kingswap/KingSwapERC20.sol, line 63) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 12 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 2,323,432,805,139 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
