---
id: mgg-7237c0b3-signed-shortcut-lost
format: 2
title: MGG holders whose accounts take real code lose permit and signed delegation
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
  address: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  name: MGG
  code: verified
  code_url: https://etherscan.io/address/0x7237c0b30b1355f1b76355582f182f6f04b08740#code
  copies: 1
  admin: '0x3ff9bda6bb59fb87853a25a07764dc241a5ca4eb'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7
impact: liveness
action: Tell holders that permit and delegateBySig stop once their account takes real code; a direct approve and
  delegate call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: no-1271-legacy
  bytecode: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - evidence-2
  - what
- id: permit-fn
  selector: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-3
  - justification
  - what
- id: permit-body
  source: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  file: MGG.sol
  line: 619
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  file: MGG.sol
  line: 630
  has: address signatory = ecrecover(digest, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  file: MGG.sol
  line: 595
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-3
- id: match
  source: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  file: MGG.sol
  line: 632
  has: 'require(signatory == owner, "MGG::permit: unauthorized");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: bysig-fn
  selector: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has delegateBySig
  for:
  - what
- id: delegate-fn
  selector: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  fn: delegate(address)
  says: the code has a direct delegate
  for:
  - action
  - evidence-3
  - justification
  - what
- id: bysig-body
  source: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  file: MGG.sol
  line: 701
  has: delegateBySig
  says: delegateBySig is defined here
  for:
  - evidence-2
  - what
- id: bysig-recover
  source: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  file: MGG.sol
  line: 705
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ECDSA
  for:
  - action
  - evidence-2
  - justification
  - what
- id: bysig-acts
  source: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  file: MGG.sol
  line: 709
  has: return _delegate(signatory, delegatee);
  says: the votes delegated are the recovered signer's
  for:
  - evidence-2
  - what
- id: delegate-body
  source: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  file: MGG.sol
  line: 688
  has: delegate
  says: delegate is a direct call of the holder
  for:
  - action
  - evidence-3
- id: supply
  call: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  fn: totalSupply()(uint256)
  is: 999230770000000000000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x7237c0b30b1355f1b76355582f182f6f04b08740'
  fn: symbol()(string)
  is: MGG
  says: the token's symbol is MGG
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

The MGG token lets a holder approve a spender and delegate its votes with an ECDSA signature, or with direct approve and delegate calls. A holder whose account takes real code can no longer use permit and delegateBySig; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x7237c0b30b1355f1b76355582f182f6f04b08740#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [delegateBySig](https://etherscan.io/address/0x7237c0b30b1355f1b76355582f182f6f04b08740#code) recovers the signer with ECDSA and delegates that signer's votes; the code never asks the signer's account.
- [approve and delegate](https://etherscan.io/address/0x7237c0b30b1355f1b76355582f182f6f04b08740#code) act for the caller and take no signature.

## Reviewer notes

### Mechanism

permit (MGG.sol, line 619) builds its digest and recovers the signer on line 630; the recovered address must equal the holder (line 632) before the allowance is set. approve (MGG.sol, line 595) sets the caller's own allowance. delegateBySig (MGG.sol, line 701) recovers the signer on line 705 and delegates that signer's votes on line 709. delegate (MGG.sol, line 688) delegates the caller's own votes. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit and delegateBySig has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and delegateBySig and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 999,230,770,000,000,000,000,000,000 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
