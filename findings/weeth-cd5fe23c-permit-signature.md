---
id: weeth-cd5fe23c-permit-signature
format: 2
title: weETH permits are ECDSA-only, so a quantum attacker could take holders' weETH
status: confirmed
severity: MEDIUM
justification: Holders' tokens can be taken with a forged permit, and the fix is a contract upgrade behind a 10-day
  timelock.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee'
  name: WeETH
  project: etherfi
  code: verified
  code_url: https://etherscan.io/address/0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3#code
  proxy_of: '0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3'
  copies: 1
  upgradeable: 'yes'
  admin: '0x9f26d4c958fd811a1f59b01b86be7dffc9d20761'
value:
  usd: 3980783928
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade permit to check accounts with code only through ERC-1271, so holders who migrate stop being forgeable.
evidence_level: source
checks:
- id: permit-ecdsa
  source: '0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol
  lines:
  - 71
  - 72
  has: address signer = ECDSAUpgradeable.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA and requires it to be the owner
  for:
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol
  line: 74
  has: _approve(owner, spender, value);
  says: a valid permit sets the spender's allowance over the owner's tokens
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3'
  has: 1626ba7e
  absent: true
  says: the implementation code never names isValidSignature, so there is no ERC-1271 path
  for:
  - evidence-1
  - what
- id: transfer-from
  source: '0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol
  lines:
  - 168
  - 170
  has: _spendAllowance(from, spender, amount);
  says: transferFrom spends the allowance and moves the owner's tokens
  for:
  - what
- id: supply
  call: '0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee'
  fn: totalSupply()(uint256)
  is: '1991571267102548244403092'
  says: 1.99 million weETH are in circulation
  for:
  - what
- id: project
  source: '0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3'
  file: src/core/WeETH.sol
  line: 8
  has: '@etherfi/core/interfaces/IeETH.sol'
  says: the verified source is ether.fi's code base
  for:
  - what
- id: authorize
  source: '0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3'
  file: src/core/WeETH.sol
  line: 241
  has: function _authorizeUpgrade(address newImplementation) internal override onlyUpgradeTimelock {}
  says: only the upgrade timelock can upgrade weETH
  for:
  - action
  - admin
  - evidence-2
  - justification
- id: upgrade-to
  source: '0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3'
  file: lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol
  lines:
  - 72
  - 75
  has: _authorizeUpgrade(newImplementation);
  says: upgradeTo asks _authorizeUpgrade and then replaces the implementation
  for:
  - action
  - evidence-2
- id: timelock-role
  call: '0x62247d29b4b9becf4bb73e0c722cf6445cfc7ce9'
  fn: roleHolders(bytes32)(address[])
  args:
  - '0x5ba17a247620ef8426ae0fffc28eee4ee4b18eb3b8bcfa95664565c35371dfb5'
  is:
  - '0x9f26d4C958fD811A1F59B01B86Be7dFFc9d20761'
  says: the upgrade timelock role is held by EtherFiTimelock alone
  for:
  - action
  - admin
  - evidence-2
  - justification
- id: timelock-delay
  call: '0x9f26d4c958fd811a1f59b01b86be7dffc9d20761'
  fn: getMinDelay()(uint256)
  is: '864000'
  says: the timelock's minimum delay is 10 days
  for:
  - evidence-2
  - justification
- id: registry
  call: '0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee'
  fn: roleRegistry()(address)
  is: '0x62247D29B4B9BECf4BB73E0c722cf6445cfC7cE9'
  says: weETH checks roles in this registry
  for:
  - notes
- id: not-paused
  call: '0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee'
  fn: paused()(bool)
  is: 'false'
  says: weETH is not paused
  for:
  - notes
- id: self-held
  call: '0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee'
  fn: balanceOf(address)(uint256)
  args:
  - '0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee'
  is: '6766117832567071194'
  says: the token holds 6.77 of its own weETH
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
- who: r-cd5fe23c, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-1): weETH''s permit is unmodified OZ ERC20PermitUpgradeable
    (ECDSA only); the fix is an upgrade through ether.fi''s upgrade timelock (10-day delay, the only UPGRADE_TIMELOCK_ROLE
    holder); the action routes accounts with code through ERC-1271 only. Token supply affected (upper bound) $3.98B.
    Both refuters agree; Claude read the sheet.'
related: []
---

## What happens

weETH, ether.fi's wrapped staked ETH, sets an allowance when the holder signs a permit, and checks that signature only with ECDSA. A quantum attacker who recovers a holder's key can sign a permit to itself and take that holder's weETH. About 1.99 million weETH are in circulation.

## Evidence

- [permit](https://etherscan.io/address/0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3#code) recovers the signer with ECDSA and approves the spender if it is the owner; the code has no ERC-1271 check.
- [Upgrades](https://etherscan.io/address/0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3#code) need ether.fi's upgrade timelock, which has a 10-day delay.

## Reviewer notes

### Mechanism

The proxy runs WeETH (implementation 0xa6ca...ccf3), which inherits OpenZeppelin ERC20PermitUpgradeable. permit (lines 56-75) builds the EIP-712 digest with the owner's nonce, calls ECDSAUpgradeable.recover (line 71, raw ecrecover at line 152 of the library), requires signer == owner (line 72) and calls _approve(owner, spender, value) (line 74). The spender then calls transferFrom (ERC20Upgradeable lines 163-172), which spends the allowance and moves the owner's balance. There is no isValidSignature call anywhere in the runtime code. A plain approve (lines 141-145) is open to any holder, so post-quantum accounts are not locked out; the exposure is forgery of ECDSA-key holders' permits, which stays after a holder moves to a post-quantum account that keeps the same address (EIP-8151 not assumed). Upgrade: UUPS upgradeTo (lines 72-75) calls _authorizeUpgrade, which is onlyUpgradeTimelock (WeETH line 241) against RoleRegistry 0x6224...7ce9; roleHolders(UPGRADE_TIMELOCK_ROLE) is the EtherFiTimelock 0x9f26...0761 with getMinDelay 864,000 s (10 days). At the block the token is not paused, supply is 1,991,571 weETH; the proxy itself holds 6.77 weETH (the $13.5k held value), stray tokens that only the operating timelock can recover.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: permit has none (lines 56-75) and the implementation code has no isValidSignature selector.
- Ruled out: unused implementation: this is the proxy users call; totalSupply is 1.99M weETH and paused() is false at the block.
- Ruled out: direct path: approve lets any holder, including a post-quantum account, approve without a signature, so this is forgery exposure, not a lockout; it does not stop a forged permit.
- Ruled out: setter: upgradeTo reaches _authorizeUpgrade, gated to the upgrade timelock; the registry accepts the timelock and rejects another address (onlyUpgradeTimelock reverts 0x2603b7da for 0x...01).
- Ruled out: wrapWithPermit calls eETH's permit, not weETH's; eETH is its own contract (0x35fa...8ac2) and its own row.
- Ruled out: whose: the $13.5k held at the address is 6.77 weETH sent to the token itself; no check shows whose it is, so whose is left empty. The holders' balances (supply) are what a forged permit reaches.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
