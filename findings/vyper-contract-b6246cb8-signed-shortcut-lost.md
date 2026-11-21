---
id: vyper-contract-b6246cb8-signed-shortcut-lost
format: 2
title: Yearn vault holders whose accounts take real code lose permit, keep approve
status: confirmed
severity: INFORMATIONAL
justification: Permit stops working only for a holder who moves to real code; approve by a direct call still works.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb6246cb8c98a59a753a94c8e16ac54eadb392e40'
  name: Vyper_contract
  project: yearn-finance
  code: verified
  code_url: https://etherscan.io/address/0x910e6e8c29e1e02602863535295a531249965294#code
  proxy_of: '0x910e6e8c29e1e02602863535295a531249965294'
  copies: 258
  family: 0db621e8a3a3ab558476948adecfeedf
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell share holders whose accounts take real code to call approve instead of signing a permit.
evidence_level: source
checks:
- id: permit-ec
  source: '0x910e6e8c29e1e02602863535295a531249965294'
  file: Vyper_contract.vy
  line: 802
  has: assert ecrecover(digest, v, r, s) == owner
  says: permit accepts only a signature that recovers to the owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-set
  source: '0x910e6e8c29e1e02602863535295a531249965294'
  file: Vyper_contract.vy
  line: 803
  has: self.allowance[owner][spender] = amount
  says: a valid permit sets the owner's allowance for the spender
  for:
  - evidence-1
  - what
- id: approve
  source: '0x910e6e8c29e1e02602863535295a531249965294'
  file: Vyper_contract.vy
  lines:
  - 721
  - 730
  has: self.allowance[msg.sender][spender] = amount
  says: approve sets the caller's allowance directly, with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: shares
  source: '0x910e6e8c29e1e02602863535295a531249965294'
  file: Vyper_contract.vy
  line: 931
  has: 'shares: uint256 = self._issueSharesForAmount(recipient, amount)'
  says: deposits issue shares to the depositor, so the vault's assets belong to its users
  for:
  - whose
- id: no-shares
  call: '0xb6246cb8c98a59a753a94c8e16ac54eadb392e40'
  fn: totalSupply()(uint256)
  is: '0'
  says: this vault has issued no shares at the block
  for:
  - what
- id: copy-shares
  call: '0x5383c1ab5beac04d6a6e6872cc6a422f2dc25576'
  fn: totalSupply()(uint256)
  is: '32923568799670257385'
  says: a copy of the same code has shares outstanding
  for:
  - what
- id: init
  call: '0xb6246cb8c98a59a753a94c8e16ac54eadb392e40'
  fn: activation()(uint256)
  is: '1723318703'
  says: this clone was initialized
  for:
  - notes
- id: full-gas
  bytecode: '0x910e6e8c29e1e02602863535295a531249965294'
  has: 60015afa
  says: the precompile is called with all remaining gas
  for:
  - notes
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

This Yearn vault lets a share holder approve a spender by calling approve or by signing a permit. A holder whose account takes real code can no longer use permit; approve still works, and so does an EIP-7702 delegation. At the block this vault has no shares; its copies do.

## Evidence

- [permit](https://etherscan.io/address/0x910e6e8c29e1e02602863535295a531249965294#code) requires `ecrecover(digest, v, r, s) == owner`, with no other check for the owner.
- [approve](https://etherscan.io/address/0x910e6e8c29e1e02602863535295a531249965294#code) sets the caller's allowance with no signature.

## Reviewer notes

### Mechanism

The address is an EIP-1167 clone of the Yearn Vault 0.4.6 code at 0x910e…5294 (initialized: activation is set; name 'Curve ynETH Factory yVault'). permit (lines 765-807) builds the EIP-712 Permit digest with the owner's nonce, unpacks r, s, v and asserts ecrecover(digest, v, r, s) == owner (line 802); it then sets allowance[owner][spender] (line 803) and bumps the nonce. approve (lines 720-733) sets allowance[msg.sender][spender] with no signature, so a holder with real code keeps the same act by a direct call. Under EIP-8151 ecrecover returns nothing for an owner with real code, so permit reverts for that owner; an EIP-7702 delegation still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 258 addresses run this code.
- Ruled out: an ERC-1271 path: the source has no isValidSignature, and permit's only owner check is line 802.
- Ruled out: unused implementation: this clone is initialized (activation() is non-zero) and has its own name and token.
- Ruled out: a break with nobody migrating: the vault calls the precompile with all remaining gas (bytecode has PUSH1 1, GAS, STATICCALL), not a fixed 3,000, so the higher recovery price does not break it.
- Ruled out: signature checked again later: a permit only sets an allowance; nobody relies on it after the call.
- Ruled out: path closed: emergencyShutdown() is false and permit is not gated by it anyway; at the block this vault has totalSupply 0, so no holder here is affected today, while copies such as 0x5383…5576 hold shares.
- Ruled out: label mismatch noted: the explorer label says yvCurve-ynETH-B-f, the chain's symbol() is yvCurve-ynETH-f; the label is not used.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
