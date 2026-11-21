---
id: vaultv2-b5aee319-signed-shortcut-lost
format: 2
title: Vault share holders whose accounts take real code lose permit
status: confirmed
severity: INFORMATIONAL
justification: Only a holder that moves its account to real code loses permit, and approve still works for it.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb5aee31903eb465def0ad08fe4a88d77d58100db'
  name: VaultV2
  code: verified
  code_url: https://etherscan.io/address/0xb5aee31903eb465def0ad08fe4a88d77d58100db#code
  copies: 808
  family: eb32adf7302b5b0629491e61cdda18ce
  admin: '0x5d8b947ce5853bd8e5caca8a7c39eaca452b6752'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell share holders that permit stops for accounts with real code, and that they can call approve directly.
evidence_level: source
checks:
- id: permit-recover
  source: '0xb5aee31903eb465def0ad08fe4a88d77d58100db'
  file: lib/vault-v2/src/VaultV2.sol
  lines:
  - 905
  - 906
  has: recoveredAddress == _owner
  says: permit recovers the signer with ecrecover and requires it to equal the holder named in the call
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: allowance-set
  source: '0xb5aee31903eb465def0ad08fe4a88d77d58100db'
  file: lib/vault-v2/src/VaultV2.sol
  line: 908
  has: allowance[_owner][spender] = shares;
  says: a valid permit sets the holder's allowance for the spender
  for:
  - what
  - whose
- id: approve
  source: '0xb5aee31903eb465def0ad08fe4a88d77d58100db'
  file: lib/vault-v2/src/VaultV2.sol
  lines:
  - 889
  - 890
  has: allowance[msg.sender][spender] = shares;
  says: approve sets the caller's own allowance with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: supply
  call: '0xb5aee31903eb465def0ad08fe4a88d77d58100db'
  fn: totalSupply()(uint256)
  is: '1000000000000000000'
  says: the vault has 1e18 shares in all
  for:
  - evidence-3
  - what
- id: dead-balance
  call: '0xb5aee31903eb465def0ad08fe4a88d77d58100db'
  fn: balanceOf(address)(uint256)
  args:
  - '0x000000000000000000000000000000000000dEaD'
  is: '1000000000000000000'
  says: the burn address holds all 1e18 shares
  for:
  - evidence-3
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

Share holders can approve a spender with a signed permit, checked with ECDSA against the holder's address. A holder whose account takes real code loses permit and keeps approve; an EIP-7702 delegation keeps working. Today a burn address holds all of the vault's shares.

## Evidence

- [permit](https://etherscan.io/address/0xb5aee31903eb465def0ad08fe4a88d77d58100db#code) recovers the signature with ecrecover and requires it to equal the holder named in the call.
- [approve](https://etherscan.io/address/0xb5aee31903eb465def0ad08fe4a88d77d58100db#code) sets the caller's own allowance without a signature.
- All 1e18 [shares](https://etherscan.io/address/0xb5aee31903eb465def0ad08fe4a88d77d58100db#readContract) belong to the burn address 0x000000000000000000000000000000000000dEaD.

## Reviewer notes

### Mechanism

VaultV2 (Morpho Association code, named 'Splits Earn USDT', asset USDT) has one signature check: permit (lines 896-911) builds the EIP-712 digest, calls ecrecover and requires the result to be non-zero and equal to _owner, then sets allowance[_owner][spender]. Under EIP-8151 ecrecover returns nothing for an _owner with real code, so permit reverts InvalidSigner for that holder. approve (lines 889-893) sets allowance[msg.sender][spender] directly, so the same act stays open to the holder by a direct call; transfer and transferFrom need no signature either. State at block 26,438,999: totalSupply 1e18, all held by 0x...dEaD (the usual seed deposit); totalAssets 1,004,550 (about 1.0 USDT, held through liquidityAdapter 0xf0ad...f1e4); owner and curator 0x5d8b...6752, an account with no code and nonce 0. So no live holder can use permit today; the notice applies to future depositors.

### Checks

- Header facts: this address alone, at block 26,438,999; 808 addresses run this code.
- Ruled out: an ERC-1271 path for holders with code: permit (lines 896-911) only uses ecrecover.
- Ruled out: a break with nobody migrating: Solidity's ecrecover forwards all available gas, there is no fixed gas amount; the dossier's only family replay (tx 0xf7ea...f5d5, another address 0x8ac9...475c) succeeds under EIP-8151 and is not cited.
- Ruled out: unused address (D-028): the vault is configured (name, asset, an adapter) and holds a seed deposit, so it is a deployed vault rather than an uninitialized implementation; it has no holders besides the burn address, which the card states.
- Ruled out: other copies of this code (808 in the family) are not described here; each in use is its own row.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
