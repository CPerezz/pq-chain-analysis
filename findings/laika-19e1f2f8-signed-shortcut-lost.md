---
id: laika-19e1f2f8-signed-shortcut-lost
format: 2
title: LAIKA holders whose accounts take real code lose permit
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
  address: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  name: Laika
  code: verified
  code_url: https://etherscan.io/address/0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc947c70d549c1db86abe30d74c97944b06a32b8a'
value:
  usd: 549
  basis: held
activity:
  txs_90d: 2794
impact: liveness
action: Tell holders that permit stops once their account takes real code; a direct approve call keeps working.
evidence_level: source
checks:
- id: no-1271
  bytecode: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: permit-fn
  selector: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has the permit function
  for:
  - what
- id: approve-fn
  selector: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  fn: approve(address,uint256)
  says: the code has a direct approve
  for:
  - action
  - evidence-2
  - justification
  - what
- id: permit-body
  source: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  file: Laika.sol
  line: 3781
  has: permit
  says: permit is defined here
  for:
  - evidence-1
  - what
- id: recover
  source: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  file: Laika.sol
  line: 3798
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve-body
  source: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  file: Laika.sol
  line: 433
  has: approve
  says: approve is a direct call of the holder
  for:
  - action
  - evidence-2
- id: match
  source: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  file: Laika.sol
  line: 3799
  has: if (signer != owner) {
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: supply
  call: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  fn: totalSupply()(uint256)
  is: 63999990000000000000000000
  says: 'the token has a supply at this address: it is in use here'
  for:
  - what
- id: symbol
  call: '0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6'
  fn: symbol()(string)
  is: LAIKA
  says: the token's symbol is LAIKA
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

The LAIKA token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6#code) recovers the signer with ECDSA and requires it to equal the holder; the code never asks the holder's account.
- [approve](https://etherscan.io/address/0x19e1f2f837a3b90ebd0730cb6111189be0e1b6d6#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (Laika.sol, line 3781) builds its digest and recovers the signer on line 3798; the recovered address must equal the holder (line 3799) before the allowance is set. approve (Laika.sol, line 433) sets the caller's own allowance. Nothing in the code calls the holder's account: neither isValidSignature selector is present. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for holders with code: neither selector is in the code, and the source of permit has no such branch.
- Ruled out: another signed function left out of this card: no function in the source recovers a signature except permit and the ECDSA library they call.
- Ruled out: an unused copy: totalSupply() at this address is 63,999,990,000,000,000,000,000,000 base units.
- Ruled out: Written by the shortcut recipe: the reasoning is that of the permit and delegateBySig cards authors wrote and refuters checked; the source lines, the symbol and the supply were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
