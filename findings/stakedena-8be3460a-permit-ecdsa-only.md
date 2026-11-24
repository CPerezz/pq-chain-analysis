---
id: stakedena-8be3460a-permit-ecdsa-only
format: 2
title: Staked ENA permit trusts ECDSA even after a holder moves to new keys
status: confirmed
severity: MEDIUM
justification: Holders' sENA stays forgeable after they migrate their accounts; an upgrade by the admin's 5-of-10
  Safe can fix it.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8be3460a480c80728a8c4d7a5d5303c85ba7b3b9'
  name: StakedENA
  code: verified
  code_url: https://etherscan.io/address/0x7fd57b46ae1a7b14f6940508381877ee03e1018b#code
  proxy_of: '0x7fd57b46ae1a7b14f6940508381877ee03e1018b'
  copies: 1
  upgradeable: 'yes'
  admin: '0xf849d7792ff9b30a57656ee10a2776bcb49f4fe4'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Upgrade permit to refuse ECDSA for holders whose accounts have real code and ask them through ERC-1271 only.
evidence_level: source
checks:
- id: inherits-permit
  source: '0x7fd57b46ae1a7b14f6940508381877ee03e1018b'
  file: contracts/StakedENA.sol
  line: 19
  has: ERC20PermitUpgradeable,
  says: StakedENA inherits the OpenZeppelin permit
  for:
  - what
- id: permit-recover
  source: '0x7fd57b46ae1a7b14f6940508381877ee03e1018b'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  line: 71
  has: address signer = ECDSAUpgradeable.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: permit-owner
  source: '0x7fd57b46ae1a7b14f6940508381877ee03e1018b'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  line: 72
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: the recovered address must be the holder
  for:
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0x7fd57b46ae1a7b14f6940508381877ee03e1018b'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  line: 74
  has: _approve(owner, spender, value);
  says: a valid permit sets an allowance on the holder's own balance
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: permit-sel
  selector: '0x7fd57b46ae1a7b14f6940508381877ee03e1018b'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the running implementation has permit
  for:
  - what
- id: approve-sel
  selector: '0x7fd57b46ae1a7b14f6940508381877ee03e1018b'
  fn: approve(address,uint256)
  says: a holder can also approve by a direct call
  for:
  - what
- id: no-1271
  bytecode: '0x7fd57b46ae1a7b14f6940508381877ee03e1018b'
  has: 1626ba7e
  absent: true
  says: the implementation never calls ERC-1271 isValidSignature
  for:
  - evidence-1
  - justification
  - what
- id: proxy-upgrade
  source: '0x8be3460a480c80728a8c4d7a5d5303c85ba7b3b9'
  file: lib/openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
  lines:
  - 85
  - 91
  has: ret = _dispatchUpgradeToAndCall();
  says: the proxy's admin can replace the implementation
  for:
  - action
  - evidence-2
  - justification
- id: admin-owner
  call: '0xf849d7792ff9b30a57656ee10a2776bcb49f4fe4'
  fn: owner()(address)
  is: '0x3b0aaf6e6fcd4a7ceef8c92c32dfea9e64dc1862'
  says: the proxy admin contract is owned by Safe 0x3b0aaf6e
  for:
  - action
  - evidence-2
  - justification
- id: proxyadmin-upgrade
  selector: '0xf849d7792ff9b30a57656ee10a2776bcb49f4fe4'
  fn: upgradeAndCall(address,address,bytes)
  says: the proxy admin contract has an upgrade function for its owner
  for:
  - action
  - evidence-2
- id: safe-threshold
  call: '0x3b0aaf6e6fcd4a7ceef8c92c32dfea9e64dc1862'
  fn: getThreshold()(uint256)
  is: '5'
  says: the Safe needs 5 signatures
  for:
  - evidence-2
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review10 (source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews:
- who: r-8be3460a, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding (old bundled HIGH), MEDIUM (PQ-1): sENA inherits OZ ERC20PermitUpgradeable''s
    ECDSA-only permit (no ERC-1271), so a holder that migrates stays forgeable; the proxy''s ProxyAdmin is owned
    by a 5-of-10 Safe, so an upgrade fixes it. It holds 962.9M ENA (unpriced) for stakers. Two refuters agree; Claude
    read the sheet.'
related: []
---

## What happens

Staked ENA lets a holder approve a spender with an ECDSA-signed permit, besides a direct approve call. Permit never asks the holder's account, so a quantum attacker with a holder's key can approve itself and take that holder's sENA, even after the holder moves to post-quantum keys.

## Evidence

- [permit](https://etherscan.io/address/0x7fd57b46ae1a7b14f6940508381877ee03e1018b#code) recovers the signer with ECDSA, requires it to be the holder, then sets the allowance; there is no ERC-1271 call.
- The [proxy](https://etherscan.io/address/0x8be3460a480c80728a8c4d7a5d5303c85ba7b3b9#code) is upgraded by its admin contract, which a 5-of-10 Safe owns.

## Reviewer notes

### Mechanism

The proxy delegates to StakedENA (0x7fd57b46), which inherits OpenZeppelin 4.9 ERC20PermitUpgradeable without overriding permit. permit (lines 56-75) builds the EIP-712 digest with the holder's nonce, calls ECDSAUpgradeable.recover(hash, v, r, s), requires the result to equal owner, and calls _approve(owner, spender, value); the spender then moves the holder's sENA with transferFrom. The (v, r, s) interface carries no other signature and the implementation bytecode holds no ERC-1271 selector. Under EIP-8151 a holder whose account takes real code is refused by permit (recover returns nothing); an EIP-7702 delegation still recovers. The proxy's admin is ProxyAdmin 0xf849d779, whose owner at the block is Safe 0x3b0aaf6e (threshold 5, 10 owners); the transparent proxy lets the admin call upgradeTo/upgradeToAndCall, so the permit can be replaced. Rated MEDIUM (exposure rubric): holders' own funds, fixable by a contract upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for holders with code: permit has none (lines 56-75) and the implementation bytecode has no 0x1626ba7e.
- Ruled out: unused implementation: this address is the proxy users call; totalSupply is about 945.6M sENA at the block and the dossier shows 40 recoveries in two weeks.
- Ruled out: the family replay 0x13f795f3 (root selector 0x9008d19f, a CoW settlement): not cited, it bundles other signed steps, so its revert with code at the signer does not isolate this contract; under EIP-8151 alone it succeeds, so nothing breaks by itself.
- Ruled out: copies: the dossier lists none; USDe, sUSDe and USDtb from the old finding are separate addresses and rows.
- Ruled out: a direct path: approve(address,uint256) exists, so a holder can always approve by calling from its own account; this does not stop a forged permit.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
