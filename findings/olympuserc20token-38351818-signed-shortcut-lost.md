---
id: olympuserc20token-38351818-signed-shortcut-lost
format: 2
title: OHM holders whose accounts take real code lose permit
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
  address: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  name: OlympusERC20Token
  code: verified
  code_url: https://etherscan.io/address/0x383518188c0c6d7730d91b2c03a03c837814a899#code
  copies: 2
  family: f887f078c32b9ba4faae412e8c01f28c
  upgradeable: 'no'
  admin: '0x763a641383007870ae96067818f1649e5586f6de'
value:
  usd: 32299
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  file: OlympusERC20Token.sol
  line: 1124
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  file: OlympusERC20Token.sol
  line: 1140
  has: address signer = ecrecover(_hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  file: OlympusERC20Token.sol
  line: 848
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  file: OlympusERC20Token.sol
  line: 1141
  has: 'require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  fn: totalSupply()(uint256)
  is: 475698335488954
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x383518188c0c6d7730d91b2c03a03c837814a899'
  fn: symbol()(string)
  is: OHM
  says: the token's symbol is OHM
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

The OHM token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x383518188c0c6d7730d91b2c03a03c837814a899#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0x383518188c0c6d7730d91b2c03a03c837814a899#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (OlympusERC20Token.sol, line 1124) builds its digest and recovers the signer on line 1140; the recovered address must equal the holder (line 1141) before the allowance is set. approve (OlympusERC20Token.sol, line 848) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 475,698,335,488,954 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
