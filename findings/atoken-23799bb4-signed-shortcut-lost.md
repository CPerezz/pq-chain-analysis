---
id: atoken-23799bb4-signed-shortcut-lost
format: 2
title: mWETH holders whose accounts take real code lose permit
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
  address: '0x23799bb4e743bde3783c34f9519098abd38ab9bc'
  name: AToken
  code: verified
  code_url: https://etherscan.io/address/0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f#code
  proxy_of: '0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f'
  copies: 4
  family: 9b3a27ce8d0af7d5eb33d785c979efb8
value:
  usd: 18
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f'
  file: '@mahalend/core-v3/contracts/protocol/tokenization/AToken.sol'
  line: 173
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f'
  file: '@mahalend/core-v3/contracts/protocol/tokenization/AToken.sol'
  line: 193
  has: require(owner == ecrecover(digest, v, r, s), Errors.INVALID_SIGNATURE);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f'
  file: '@mahalend/core-v3/contracts/protocol/tokenization/base/IncentivizedERC20.sol'
  line: 145
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: supply
  call: '0x23799bb4e743bde3783c34f9519098abd38ab9bc'
  fn: totalSupply()(uint256)
  is: 10000000000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x23799bb4e743bde3783c34f9519098abd38ab9bc'
  fn: symbol()(string)
  is: mWETH
  says: the token's symbol is mWETH
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

The mWETH token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0xac3418ce48dbd35fe213dcfdfb70f044a47f9b0f#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (@mahalend/core-v3/contracts/protocol/tokenization/AToken.sol, line 173) builds its digest and recovers the signer on line 193; the recovered address must equal the holder (line 193) before the allowance is set. approve (@mahalend/core-v3/contracts/protocol/tokenization/base/IncentivizedERC20.sol, line 145) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 10,000,000,000,000,000 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
