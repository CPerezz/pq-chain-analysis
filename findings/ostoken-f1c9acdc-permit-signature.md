---
id: ostoken-f1c9acdc-permit-signature
format: 2
title: osETH accepts ECDSA permits after holders move to post-quantum keys
status: confirmed
severity: HIGH
justification: Holders' own osETH stays forgeable after they migrate their account, and nobody can change the token.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf1c9acdc66974dfb6decb12aa385b9cd01190e38'
  name: OsToken
  project: stakewise
  code: verified
  code_url: https://etherscan.io/address/0xf1c9acdc66974dfb6decb12aa385b9cd01190e38#code
  copies: 1
  upgradeable: 'no'
  admin: '0x0000000000000000000000000000000000000000'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Tell holders to move osETH to a fresh address before switching their account to post-quantum authorisation.
evidence_level: source
checks:
- id: recover
  source: '0xf1c9acdc66974dfb6decb12aa385b9cd01190e38'
  file: '@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol'
  lines:
  - 61
  - 62
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA and requires it to equal the owner
  for:
  - evidence-1
  - justification
  - what
- id: approve
  source: '0xf1c9acdc66974dfb6decb12aa385b9cd01190e38'
  file: '@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol'
  line: 66
  has: _approve(owner, spender, value);
  says: a valid permit sets an allowance over the owner's own tokens
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: owner
  call: '0xf1c9acdc66974dfb6decb12aa385b9cd01190e38'
  fn: owner()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: ownership is renounced
  for:
  - action
  - admin
  - evidence-2
  - justification
- id: no-upgrade
  selector: '0xf1c9acdc66974dfb6decb12aa385b9cd01190e38'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - evidence-2
  - justification
- id: no-proxy
  storage: '0xf1c9acdc66974dfb6decb12aa385b9cd01190e38'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-2
  - justification
- id: transfer
  selector: '0xf1c9acdc66974dfb6decb12aa385b9cd01190e38'
  fn: transfer(address,uint256)
  says: holders can move their own osETH by a direct call
  for:
  - action
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
reviews:
- who: r-f1c9acdc, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: 'kept: Kev''s first-study finding, HIGH (PQ-1): osETH''s permit (OZ ERC20Permit) checks only an ECDSA signature
    against the holder, so a holder that moves to post-quantum authorisation at the same address stays forgeable;
    no proxy, no upgrade, owner and pending owner renounced. Holders should move their osETH to a fresh address
    before switching. Two refuters agree; Claude read the sheet. Waits for Anon''s sign-off.'
related: []
---

## What happens

osETH grants a spending allowance to anyone holding a permit signed with the holder's ECDSA key. It never asks the account itself, so a quantum attacker who recovers a holder's key can drain that holder even after the holder moves the same address to post-quantum authorisation.

## Evidence

- [permit](https://etherscan.io/address/0xf1c9acdc66974dfb6decb12aa385b9cd01190e38#code) recovers the signer with ECDSA, compares it with the owner and sets the allowance; there is no ERC-1271 path.
- The [token](https://etherscan.io/address/0xf1c9acdc66974dfb6decb12aa385b9cd01190e38#code) has no proxy or upgrade function and its owner is the zero address.

## Reviewer notes

### Mechanism

OsToken (OsToken.sol) inherits OpenZeppelin 5.0 ERC20Permit unchanged. permit (ERC20Permit.sol lines 44-67) hashes the EIP-712 Permit struct, calls ECDSA.recover (line 61), reverts unless the recovered address equals owner (line 62) and then calls _approve(owner, spender, value) (line 66). The spender can then transferFrom the holder's balance. Nothing calls isValidSignature. The contract is not a proxy, has no upgrade function, and owner() is zero at the block, so even setController is unreachable; the permit logic cannot be changed. Plain approve still works for post-quantum accounts. Under EIP-8151, ecrecover returns nothing for an owner whose account has real code, which closes the forged path for those holders; an EIP-7702 delegation still recovers (a delegated signer used permit here in the window).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: permit calls only ECDSA.recover (ERC20Permit.sol lines 59-66).
- Ruled out: an upgrade or owner fix: no EIP-1967 implementation, no upgradeTo selector, owner() and pendingOwner() are zero at block 26,438,999.
- Ruled out: the replay 0xfcf97ef8...: not cited, because I could not read its other calls to confirm this token's check is the one that fails.
- Ruled out: controllers' mint and burn power is a separate trust question, not a signature check, and is left out.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
