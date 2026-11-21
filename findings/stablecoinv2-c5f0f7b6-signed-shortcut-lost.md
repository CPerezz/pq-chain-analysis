---
id: stablecoinv2-c5f0f7b6-signed-shortcut-lost
format: 2
title: FDUSD holders whose accounts take real code lose signed permits
status: confirmed
severity: INFORMATIONAL
justification: Only a shortcut is lost; approve and transfer keep working. The $10 shown is FDUSD at the token's
  own address.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc5f0f7b66764f6ec8c8dff7ba683102295e16409'
  name: StablecoinV2
  label: 'First Digital USD: FDUSD Token'
  code: verified
  code_url: https://etherscan.io/address/0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50#code
  proxy_of: '0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50'
  copies: 2
  family: 0b71442ba97feb2fb11fa5da28836bf3
  upgradeable: 'yes'
  admin: '0xbb812b978e41929e86ad9ea8c1025710fee85957'
value:
  usd: 10
  basis: held
activity: {}
impact: liveness
action: Tell holders whose accounts take real code to call approve instead of permit, and that their authorizations
  then need ERC-1271.
evidence_level: source
checks:
- id: permit-recover
  source: '0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol
  line: 71
  has: address signer = ECDSAUpgradeable.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA
  for:
  - evidence-1
  - what
- id: permit-owner
  source: '0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol
  line: 72
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: permit requires the recovered address to be the owner, with no other way to accept the signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: auth-checker
  source: '0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50'
  file: src/StablecoinV2.sol
  line: 240
  has: SignatureCheckerUpgradeable.isValidSignatureNow(from, digest, signature)
  says: the authorization transfers check the payer's signature through SignatureChecker
  for:
  - evidence-1
  - what
- id: checker-ecdsa
  source: '0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50'
  file: lib/openzeppelin-contracts-upgradeable/contracts/utils/cryptography/SignatureCheckerUpgradeable.sol
  lines:
  - 30
  - 31
  has: recovered == signer
  says: SignatureChecker first accepts an ECDSA signature recovered to the signer
  for:
  - what
- id: checker-1271
  source: '0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50'
  file: lib/openzeppelin-contracts-upgradeable/contracts/utils/cryptography/SignatureCheckerUpgradeable.sol
  lines:
  - 35
  - 40
  has: IERC1271Upgradeable.isValidSignature.selector
  says: otherwise SignatureChecker asks the signer's code through ERC-1271
  for:
  - action
  - evidence-1
  - what
- id: approve
  source: '0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol
  lines:
  - 141
  - 143
  has: _approve(owner, spender, amount);
  says: approve sets the caller's allowance without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: transfer
  source: '0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50'
  file: lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol
  lines:
  - 118
  - 120
  has: _transfer(owner, to, amount);
  says: transfer moves the caller's tokens without a signature
  for:
  - evidence-2
  - justification
  - what
- id: not-paused
  call: '0xc5f0f7b66764f6ec8c8dff7ba683102295e16409'
  fn: paused()(bool)
  is: false
  says: the token is not paused
  for:
  - what
- id: auth-on
  call: '0xc5f0f7b66764f6ec8c8dff7ba683102295e16409'
  fn: eip7598EnableFlag()(bool)
  is: true
  says: the authorization transfers are switched on
  for:
  - what
- id: replay-8151
  replay: '0xea351082b72bd504d65865d72b15aeabda263727d988de814550d2099f879c89'
  run: eip8151
  ok: true
  says: the transaction passes under EIP-8151 when nobody has migrated
  for:
  - notes
- id: replay-delegated
  replay: '0xea351082b72bd504d65865d72b15aeabda263727d988de814550d2099f879c89'
  run: eip8151_signer_delegated
  ok: true
  says: with an EIP-7702 delegation at the signer the transaction, which needs that signer's ECDSA signatures, passes
  for:
  - what
- id: proxy-bal
  call: '0xc5f0f7b66764f6ec8c8dff7ba683102295e16409'
  fn: balanceOf(address)(uint256)
  args:
  - '0xc5f0f7b66764f6ec8c8dff7ba683102295e16409'
  is: '10000000000000000000'
  says: the token contract itself holds 10 FDUSD
  for:
  - justification
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

FDUSD holders can approve by permit or pay by signed authorization, or call approve and transfer directly. Holders whose accounts take real code lose permit, and keep authorizations only through ERC-1271; an EIP-7702 delegation keeps both. The token is not paused and authorizations are on.

## Evidence

- [permit](https://etherscan.io/address/0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50#code) accepts only an ECDSA signature by the owner; the authorization transfers also ask the account by ERC-1271.
- [approve and transfer](https://etherscan.io/address/0xa6b2c3d2910246fb0adb02e5f6b39e29026e6d50#code) act for the caller with no signature, so a holder with real code keeps both; no balance is at risk.

## Reviewer notes

### Mechanism

The proxy runs StablecoinV2 (EIP-1967 slot). permit (OpenZeppelin 4 ERC20PermitUpgradeable, lines 56-75) recovers the signer with ECDSA and requires it to equal owner, with no ERC-1271 fallback. transferWithAuthorization and receiveWithAuthorization (both overloads, StablecoinV2 lines 90-182) go through _transferOrReceiveWithAuthorization (lines 205-250), which calls SignatureChecker.isValidSignatureNow(from, ...): ECDSA first, then a staticcall to from's isValidSignature. Under EIP-8151 the ECDSA recovery returns nothing for a holder with real code, so permit fails for it, and authorizations pass only if its code implements ERC-1271. approve and transfer (ERC20Upgradeable lines 118-145) use msg.sender with no signature, so the holder keeps both acts by calling directly. The owner can switch the authorization functions off (disableEIP7598) and pause transfers and approvals; at the block neither is in effect.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 path for permit: permit has none (lines 71-72); the authorization transfers do have one, so the card says those keep working for code that answers ERC-1271.
- Ruled out: a break with nobody migrating: the replay of tx 0xea35...9c89 under EIP-8151 alone succeeds; OpenZeppelin's ECDSA forwards all gas to the precompile (scan: no constant gas).
- Ruled out: a signature others rely on: a holder can always void its own outstanding permit or authorization by moving its balance, and authorizations also by cancelAuthorization, so this is a notice, not a rated finding.
- Ruled out: unused implementation: this address is the proxy in use (name First Digital USD, owner set, authorizations on); the other copy is the implementation 0xa6b2...6d50 itself, never initialized (owner zero, authorizations off).
- Ruled out: value: the $10 is 10 FDUSD held at the token's own address; no function moves it out, so whose it is is left empty; the card says it is the token's own balance and that no holder balance is at risk.
- Ruled out: the replay with real code at the signer (0x5b43...8088) reverts, but the tx is a CoW settlement whose own sell order that account signed with ECDSA, so the revert cannot be pinned on this token; it is not used as evidence. The delegated replay passing shows only that the signer's ECDSA signatures still recover with an EIP-7702 delegation.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
