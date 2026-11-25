---
id: ghotoken-40d16fc0-permit-ecdsa-only
format: 2
title: GHO permit keeps holders forgeable through ECDSA after they migrate
status: confirmed
severity: HIGH
justification: Holders stay forgeable after migrating; GHO has no proxy or upgrade to change the check.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  name: GhoToken
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 698118029
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Move GHO to a token whose permit asks owners with real code through ERC-1271 only and refuses their ECDSA
  signatures.
evidence_level: source
checks:
- id: ecdsa
  source: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  file: lib/gho-core/src/contracts/gho/ERC20.sol
  lines:
  - 129
  - 131
  has: require(recoveredAddress != address(0) && recoveredAddress == owner, 'INVALID_SIGNER');
  says: permit recovers the signer with ecrecover and requires it to be the owner
  for:
  - evidence-1
  - justification
  - what
- id: approve
  source: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  file: lib/gho-core/src/contracts/gho/ERC20.sol
  line: 133
  has: allowance[recoveredAddress][spender] = value;
  says: a valid permit sets the owner's allowance for the spender
  for:
  - evidence-1
  - justification
  - what
- id: pull
  source: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  file: lib/gho-core/src/contracts/gho/ERC20.sol
  lines:
  - 85
  - 91
  has: balanceOf[from] -= amount;
  says: transferFrom moves the holder's own balance using the allowance
  for:
  - justification
  - what
  - whose
- id: no1271
  bytecode: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  has: 1626ba7e
  absent: true
  says: the runtime code never calls isValidSignature
  for:
  - action
  - evidence-2
  - what
- id: noupgrade
  selector: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  fn: upgradeTo(address)
  absent: true
  says: no upgradeTo function
  for:
  - action
  - evidence-2
  - justification
- id: noupgradecall
  selector: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: no upgradeToAndCall function
  for:
  - action
  - evidence-2
  - justification
- id: supply
  call: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  fn: totalSupply()(uint256)
  is: '699000000000000000000000000'
  says: 699M GHO in supply at the block
  for:
  - notes
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-1
reviews:
- who: r-40d16fc0, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: 'kept: Kev''s first-study finding, HIGH (PQ-1): GHO''s permit recovers the signer with ecrecover only, so
    a holder that moves to post-quantum authorisation at the same address stays forgeable; no proxy or upgrade,
    and the admin roles manage facilitators only. Token supply affected (upper bound) at 699M GHO. Claude fixed
    the title (no drain is under way: holders stay forgeable). Two refuters agree on the final card; Claude read
    the sheet. Waits for Anon''s sign-off.'
related: []
---

## What happens

GHO sets an allowance when a permit is signed with the owner's ECDSA key. It never asks the owner's account itself, so a quantum attacker who recovers the key can sign a permit and take the balance, even after the holder moves to post-quantum authorisation.

## Evidence

- [permit](https://etherscan.io/address/0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f#code) recovers the signer with ecrecover and sets the allowance when it equals the owner.
- The [runtime code](https://etherscan.io/address/0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f#code) has no ERC-1271 call and no upgrade function.

## Reviewer notes

### Mechanism

permit (ERC20.sol lines 107-136) builds the EIP-712 digest with the owner's nonce, calls ecrecover (line 129), requires the result to be non-zero and equal to owner (line 131), and writes allowance[owner][spender] (line 133). transferFrom (lines 85-101) then moves balanceOf[from] for the spender. There is no code-size branch and no isValidSignature call, so the account's own (post-quantum) authorisation is never consulted. GhoToken is not a proxy and has no upgrade function; its AccessControl roles only manage facilitators and bucket capacities (GhoToken.sol), not permit. totalSupply at block 26,438,999 is 699,000,000 GHO.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: the selector 0x1626ba7e does not appear in the runtime code and permit has no code-size branch (lines 107-136).
- Ruled out: an upgrade: the runtime code has neither upgradeTo nor upgradeToAndCall, and the tool found no proxy slots.
- Ruled out: a break under EIP-8151 alone: the dossier's replay of a permit-using transaction succeeds under EIP-8151, and the recovered signers seen are accounts without code; EIP-8151 would instead close this path for owners with real code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
