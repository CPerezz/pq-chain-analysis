---
id: tranche-c58d0444-signed-shortcut-lost
format: 2
title: jrUSDe holders whose accounts take real code lose permit
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
  address: '0xc58d044404d8b14e953c115e67823784dea53d8f'
  name: Tranche
  code: verified
  code_url: https://etherscan.io/address/0xe91869f96806b480dd61d57e17919068d35ac09c#code
  proxy_of: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  copies: 4
  family: 909bdaa54ecc214594f762430af68ce6
  upgradeable: 'yes'
  admin: '0x89d2573471dc0bf81c7c553fffc1e31ce9e75bf1'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol'
  line: 49
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol'
  line: 66
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol'
  line: 149
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0xe91869f96806b480dd61d57e17919068d35ac09c'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol'
  line: 67
  has: if (signer != owner) {
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0xc58d044404d8b14e953c115e67823784dea53d8f'
  fn: totalSupply()(uint256)
  is: 2339401512347917539471410
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0xc58d044404d8b14e953c115e67823784dea53d8f'
  fn: symbol()(string)
  is: jrUSDe
  says: the token's symbol is jrUSDe
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

The jrUSDe token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xe91869f96806b480dd61d57e17919068d35ac09c#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0xe91869f96806b480dd61d57e17919068d35ac09c#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol, line 49) builds its digest and recovers the signer on line 66; the recovered address must equal the holder (line 67) before the allowance is set. approve (@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol, line 149) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 2,339,401,512,347,917,539,471,410 base units.
- Ruled out: Written by the shortcut recipe (D-029): the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
