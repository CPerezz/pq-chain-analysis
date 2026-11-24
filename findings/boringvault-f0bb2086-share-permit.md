---
id: boringvault-f0bb2086-share-permit
format: 2
title: Liquid ETH vault shares stay forgeable even after a holder migrates
status: confirmed
severity: MEDIUM
justification: Shares stay forgeable by the old key after migration; the vault cannot be upgraded, but a new hook
  could block it.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  name: BoringVault
  project: etherfi
  code: verified
  code_url: https://etherscan.io/address/0xf0bb20865277abd641a307ece5ee04e79073416c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 427277
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Install, through the timelock, a hook that refuses third-party transfers out of holders who move to post-quantum
  keys.
evidence_level: source
checks:
- id: permit-recover
  source: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  file: lib/solmate/src/tokens/ERC20.sol
  line: 130
  has: address recoveredAddress = ecrecover(
  says: permit recovers the signer of the Permit digest with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: permit-owner
  source: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  file: lib/solmate/src/tokens/ERC20.sol
  lines:
  - 154
  - 156
  has: recoveredAddress == owner
  says: permit sets the owner's allowance for the spender when the recovered address is the owner
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: no-1271
  bytecode: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  has: 1626ba7e
  absent: true
  says: the code never calls isValidSignature
  for:
  - evidence-1
  - what
- id: transfer-from
  source: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  file: lib/solmate/src/tokens/ERC20.sol
  lines:
  - 95
  - 99
  has: balanceOf[from] -= amount;
  says: transferFrom spends the allowance and moves the holder's balance
  for:
  - what
  - whose
- id: hook-call
  source: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  file: src/base/BoringVault.sol
  line: 121
  has: hook.beforeTransfer(from, to, msg.sender);
  says: every transfer asks the hook with from, to and the operator
  for:
  - action
  - justification
  - what
- id: hook-setter
  source: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  file: src/base/BoringVault.sol
  lines:
  - 113
  - 115
  has: function setBeforeTransferHook(address _hook) external requiresAuth {
  says: an authorised caller can replace the transfer hook
  for:
  - action
  - evidence-2
  - justification
  - what
- id: requires-auth
  source: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  file: lib/solmate/src/auth/Auth.sol
  line: 35
  has: auth.canCall(user, address(this), functionSig)) || user == owner
  says: requiresAuth admits the owner or whoever the authority allows
  for:
  - justification
- id: owner-zero
  call: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  fn: owner()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: the vault has no owner, so only the authority grants access
  for:
  - notes
- id: authority
  call: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  fn: authority()(address)
  is: '0x485bde66bb668a51f2372e34e45b1c6226798122'
  says: the vault's authority
  for:
  - action
  - justification
- id: hook-role
  call: '0x485bde66bb668a51f2372e34e45b1c6226798122'
  fn: getRolesWithCapability(address,bytes4)(bytes32)
  args:
  - '0xf0bb20865277abd641a307ece5ee04e79073416c'
  - '0x8929565f'
  is: '0x0000000000000000000000000000000000000000000000000000000000000100'
  says: role 8 may call setBeforeTransferHook on the vault
  for:
  - action
  - evidence-2
  - justification
- id: authority-owner
  call: '0x485bde66bb668a51f2372e34e45b1c6226798122'
  fn: owner()(address)
  is: '0xd829f278016b90fec735f9a12bf8b75e06102c89'
  says: the authority is owned by the timelock
  for:
  - notes
- id: timelock-can
  call: '0x485bde66bb668a51f2372e34e45b1c6226798122'
  fn: canCall(address,address,bytes4)(bool)
  args:
  - '0xd829f278016b90fec735f9a12bf8b75e06102c89'
  - '0xf0bb20865277abd641a307ece5ee04e79073416c'
  - '0x8929565f'
  is: true
  says: the timelock may call setBeforeTransferHook on the vault
  for:
  - action
  - evidence-2
  - justification
- id: timelock-delay
  call: '0xd829f278016b90fec735f9a12bf8b75e06102c89'
  fn: getMinDelay()(uint256)
  is: 86400
  says: the timelock's delay is one day
  for:
  - action
  - evidence-2
  - justification
- id: hook
  call: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  fn: hook()(address)
  is: '0x9aa79c84b79816ab920bbce20f8f74557b514734'
  says: the current hook
  for:
  - evidence-3
- id: hook-open
  call: '0x9aa79c84b79816ab920bbce20f8f74557b514734'
  data: '0xabd626b0000000000000000000000000ed0dcc9b9c875ee33f9ad01685d74694eb0b6b0e000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000beef'
  is: 0x
  says: the current hook lets the holder's shares move to a stranger by a stranger operator
  for:
  - evidence-3
- id: holder-balance
  call: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  fn: balanceOf(address)(uint256)
  args:
  - '0xed0dcc9b9c875ee33f9ad01685d74694eb0b6b0e'
  is: 46790047342553584616
  says: the holder owns 46.79 shares
  for:
  - evidence-3
- id: holder-plain
  code: '0xed0dcc9b9c875ee33f9ad01685d74694eb0b6b0e'
  is: empty
  says: the holder is a plain account
  for:
  - evidence-3
- id: supply
  call: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  fn: totalSupply()(uint256)
  is: 122745645451073881356018
  says: holders own 122,746 shares in all
  for:
  - what
- id: hook-accountant
  call: '0x9aa79c84b79816ab920bbce20f8f74557b514734'
  fn: accountant()(address)
  is: '0x0d05d94a5f1e76c18fbeb7a13d17c8a314088198'
  says: the hook names the accountant that prices shares
  for:
  - what
- id: accountant-vault
  call: '0x0d05d94a5f1e76c18fbeb7a13d17c8a314088198'
  fn: vault()(address)
  is: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  says: the accountant prices this vault
  for:
  - what
- id: rate
  call: '0x0d05d94a5f1e76c18fbeb7a13d17c8a314088198'
  fn: getRate()(uint256)
  is: 1111685370071508669
  says: one share is worth about 1.1117 of the base asset
  for:
  - what
- id: rate-base
  call: '0x0d05d94a5f1e76c18fbeb7a13d17c8a314088198'
  fn: base()(address)
  is: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  says: the base asset is WETH
  for:
  - what
- id: deny-from
  selector: '0x9aa79c84b79816ab920bbce20f8f74557b514734'
  fn: denyFrom(address)
  says: the current hook can deny a sender by address
  for:
  - notes
- id: deny-to
  selector: '0x9aa79c84b79816ab920bbce20f8f74557b514734'
  fn: denyTo(address)
  says: the current hook can deny a recipient by address
  for:
  - notes
- id: deny-operator
  selector: '0x9aa79c84b79816ab920bbce20f8f74557b514734'
  fn: denyOperator(address)
  says: the current hook can deny an operator by address
  for:
  - notes
- id: no-proxy
  storage: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-2
  - justification
  - what
- id: no-upgrade
  selector: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - evidence-2
  - justification
  - what
- id: name
  call: '0xf0bb20865277abd641a307ece5ee04e79073416c'
  fn: name()(string)
  is: Ether.Fi Liquid ETH
  says: the token names ether.fi
  for:
  - notes
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review14 (verified source and upgrade-authority reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews:
- who: r-f0bb2086, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding (old bundled MEDIUM), MEDIUM (PQ-1): the ether.fi Liquid ETH BoringVault''s
    solmate permit grants allowances on ECDSA alone; the vault cannot be upgraded, but a one-day-timelocked role
    can install a transfer hook that refuses third-party transfers (the author''s HIGH became MEDIUM after the refuter).
    About 122,746 shares at about 1.1117 WETH (roughly 136,450 ETH) as an upper bound. Third version after two returns;
    two refuters agree on it; Claude read the sheet.'
related: []
---

## What happens

Permit trusts ECDSA alone, never asking the holder's account. A key recovered from a past signature still moves shares after migration. Holders own 122,746 shares, up to about 136,450 ETH at the accountant's rate. The vault cannot be upgraded; a new hook could still block such transfers.

## Evidence

- [permit](https://etherscan.io/address/0xf0bb20865277abd641a307ece5ee04e79073416c#code) recovers the signer with ecrecover and sets the allowance when it matches the owner; there is no ERC-1271 path.
- The [vault](https://etherscan.io/address/0xf0bb20865277abd641a307ece5ee04e79073416c#code) cannot be upgraded; a role held by a one-day timelock can replace its transfer hook.
- The [current hook](https://etherscan.io/address/0x9aa79c84b79816ab920bbce20f8f74557b514734#code) lets a stranger move shares out of a plain account that holds 46.79 shares.

## Reviewer notes

### Mechanism

Solmate ERC20.permit (lines 116-160) recovers the EIP-712 Permit digest with raw ecrecover (line 130), requires recovered == owner (line 154) and sets allowance[owner][spender] (line 156); the bytecode has no isValidSignature selector, so the holder's account is never asked. BoringVault.transferFrom (lines 129-132) calls hook.beforeTransfer(from, to, msg.sender) (line 121), then Solmate transferFrom spends the allowance (lines 95-99). With a key recovered from any past signature, an attacker signs a permit to himself and calls transferFrom; this does not depend on the holder's account taking real code, because permit only checks the ECDSA signature. The vault has no EIP-1967 slot and no upgradeTo selector. setBeforeTransferHook (line 113) is requiresAuth; owner() is zero, so only the RolesAuthority 0x485b...8122 grants it: getRolesWithCapability gives role 8 (0x100), which the authority's owner, timelock 0xd829...2c89 (getMinDelay 86400), holds; canCall(timelock, vault, setBeforeTransferHook) is true. Because the hook receives the operator, a new hook can refuse transferFrom by anyone but the holder out of chosen holders (e.g. those with real code) while their own transfers stay open. The current hook already has denyFrom, denyTo and denyOperator lists, which block by address rather than per holder and operator, and at the block it lets a stranger operator move a holder's shares.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: the runtime code has no 0x1626ba7e selector bytes.
- Ruled out: unused code: the vault has a live supply and 75 recoveries in the two-week window, all signers plain accounts with no code.
- Ruled out: the current hook as a fix: beforeTransfer(holder, 0xdead, 0xbeef) returns without revert at the block; its denyFrom, denyTo and denyOperator lists block by address, so they cannot refuse only other operators' transfers out of one holder; a new hook is needed.
- Ruled out: an upgrade path: EIP-1967 slot empty and no upgradeTo selector; only the hook and the roles are configurable.
- Ruled out: a gas issue under EIP-8151: the dossier lists no replay for this code family, so none is claimed here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
