---
id: eeth-35fa1647-permit-ecdsa-only
format: 2
title: eETH permit takes ECDSA only, so holders stay exposed after they migrate
status: confirmed
severity: MEDIUM
justification: Holders' tokens stay forgeable after they migrate; ether.fi fixes it by upgrading through its timelock.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x35fa164735182de50811e8e2e824cfb9b6118ac2'
  name: EETH
  project: etherfi
  code: verified
  code_url: https://etherscan.io/address/0xd1901dd36cbf4a81386d0162df2707f7ddb60527#code
  proxy_of: '0xd1901dd36cbf4a81386d0162df2707f7ddb60527'
  copies: 1
  upgradeable: 'yes'
  admin: '0x9f26d4c958fd811a1f59b01b86be7dffc9d20761'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Upgrade permit to refuse ECDSA for owners whose accounts have code and to ask those owners through ERC-1271
  only.
evidence_level: source
checks:
- id: ecdsa
  source: '0xd1901dd36cbf4a81386d0162df2707f7ddb60527'
  file: src/core/EETH.sol
  lines:
  - 276
  - 279
  has: address signer = ECDSAUpgradeable.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA, reverts unless it equals owner, and sets owner's allowance for spender
  for:
  - action
  - evidence-1
  - justification
  - what
- id: transferfrom
  source: '0xd1901dd36cbf4a81386d0162df2707f7ddb60527'
  file: src/core/EETH.sol
  lines:
  - 241
  - 248
  has: _transfer(_sender, _recipient, _amount);
  says: transferFrom spends the allowance and moves the holder's own balance to any recipient
  for:
  - what
  - whose
- id: upgrade-auth
  source: '0xd1901dd36cbf4a81386d0162df2707f7ddb60527'
  file: src/core/EETH.sol
  line: 444
  has: function _authorizeUpgrade(address newImplementation) internal override onlyUpgradeTimelock {}
  says: an upgrade needs the upgrade-timelock role in the role registry
  for:
  - action
  - admin
  - evidence-2
  - justification
- id: registry
  call: '0x35fa164735182de50811e8e2e824cfb9b6118ac2'
  fn: roleRegistry()(address)
  is: '0x62247d29b4b9becf4bb73e0c722cf6445cfc7ce9'
  says: the role registry eETH asks is 0x6224…7ce9
  for:
  - admin
- id: role-holder
  call: '0x62247d29b4b9becf4bb73e0c722cf6445cfc7ce9'
  fn: roleHolders(bytes32)(address[])
  args:
  - '0x5ba17a247620ef8426ae0fffc28eee4ee4b18eb3b8bcfa95664565c35371dfb5'
  is:
  - '0x9f26d4c958fd811a1f59b01b86be7dffc9d20761'
  says: UPGRADE_TIMELOCK_ROLE's only holder is EtherFiTimelock 0x9f26…0761
  for:
  - action
  - admin
  - evidence-2
  - justification
- id: delay
  call: '0x9f26d4c958fd811a1f59b01b86be7dffc9d20761'
  fn: getMinDelay()(uint256)
  is: 864000
  says: the timelock's minimum delay is 10 days
  for:
  - evidence-2
  - justification
- id: project
  call: '0x35fa164735182de50811e8e2e824cfb9b6118ac2'
  fn: name()(string)
  is: ether.fi ETH
  says: the token names itself ether.fi ETH
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
reviews: []
related: []
---

## What happens

ether.fi's eETH token approves a spender when the holder's ECDSA signature on a permit checks out, and never asks the holder's account itself. A quantum attacker with a holder's key can sign a permit and take the tokens, even after the holder moves that address to post-quantum authorisation.

## Evidence

- [permit](https://etherscan.io/address/0xd1901dd36cbf4a81386d0162df2707f7ddb60527#code) recovers the signer with ECDSA and approves the spender if it equals the owner; there is no ERC-1271 path.
- [eETH](https://etherscan.io/address/0x35fa164735182de50811e8e2e824cfb9b6118ac2) upgrades need the upgrade-timelock role, held by ether.fi's timelock with a 10-day delay.

## Reviewer notes

### Mechanism

The proxy 0x35fa…8ac2 delegates to EETH 0xd190…0527. permit (lines 261-280) builds the EIP-712 digest with the owner's nonce, recovers the signer with ECDSAUpgradeable.recover (line 276), reverts unless it equals owner (277) and sets the allowance with _approve (279). Nothing checks whether owner has code or calls isValidSignature. transferFrom (241-248) then spends the allowance and moves the owner's shares. Upgrades go through UUPS upgradeTo/upgradeToAndCall, which call _authorizeUpgrade, gated by onlyUpgradeTimelock (line 444) on the immutable roleRegistry 0x6224…7ce9; at the block UPGRADE_TIMELOCK_ROLE is held by EtherFiTimelock 0x9f26…0761 with getMinDelay 864,000 s (10 days). Quantum-exposure rubric: users' own funds stay forgeable after they migrate, and the fix is a contract upgrade, so MEDIUM (step 3).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size branch for owners with code: permit (lines 261-280) has none.
- Ruled out: unused implementation: this address is the proxy users call; totalSupply() at the block is 2,280,758.73 eETH, and the dossier's trace window shows 9 real permit recoveries (selector 0x03dcfbdc) here.
- Ruled out: a direct path that makes the signed path harmless: approve (lines 200-201) lets a holder approve directly, but that does not switch permit off, so a forged permit still works.
- Ruled out: a paused or closed path: paused() is false at the block, and permit itself has no pause check.
- Ruled out: EIP-8151 is not assumed by this rubric; under it the recovery returns nothing for an owner whose account takes real code (an EIP-7702 delegation still recovers), which would close this path for those holders. The study's replay 0x613ec2f4… passes both today and under EIP-8151 alone, so nothing here breaks with nobody migrating.
- Ruled out: weETH 0xcd5fe23c… and the Liquid ETH vault 0xf0bb2086… were filed with this address in the old finding; they are other contracts with their own permit code and their own rows.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
