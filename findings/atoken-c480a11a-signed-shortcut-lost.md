---
id: atoken-c480a11a-signed-shortcut-lost
format: 2
title: UwU's uMIM permit stops working for holders whose accounts take real code
status: confirmed
severity: INFORMATIONAL
justification: Holders who move to real code lose gasless approval; a direct approve still works, so nothing is
  locked.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc480a11a524e4db27c6d4e814b4d9b3646bc12fc'
  name: AToken
  code: verified
  code_url: https://etherscan.io/address/0xb5bb4f1a3a5a644d80f97bd60eed0c2dfb2afeb8#code
  proxy_of: '0xb5bb4f1a3a5a644d80f97bd60eed0c2dfb2afeb8'
  copies: 41
  family: a3df5c92afe9e1c286ec7b2937371567
  upgradeable: 'yes'
  admin: '0x408c9764993209dc772eb12ff641f4b55f5b005c'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell uMIM holders to approve spenders with a direct approve call, not permit, once their accounts take real
  code.
evidence_level: source
checks:
- id: ecdsa
  source: '0xb5bb4f1a3a5a644d80f97bd60eed0c2dfb2afeb8'
  file: contracts/aave-protocol-v2/protocol/tokenization/AToken.sol
  line: 346
  has: require(owner == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
  says: permit accepts only an ECDSA signature that recovers to the owner
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: approve
  source: '0xb5bb4f1a3a5a644d80f97bd60eed0c2dfb2afeb8'
  file: contracts/aave-protocol-v2/protocol/tokenization/IncentivizedERC20.sol
  lines:
  - 109
  - 110
  has: _approve(_msgSender(), spender, amount);
  says: approve sets the caller's own allowance without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
  - whose
- id: name
  call: '0xc480a11a524e4db27c6d4e814b4d9b3646bc12fc'
  fn: name()(string)
  is: UwU interest bearing MIM
  says: the token is UwU's interest-bearing MIM
  for:
  - what
- id: supply
  call: '0xc480a11a524e4db27c6d4e814b4d9b3646bc12fc'
  fn: totalSupply()(uint256)
  is: '1208840326995921910509'
  says: 1,208.84 uMIM are outstanding
  for:
  - evidence-3
  - what
- id: impl
  storage: '0xc480a11a524e4db27c6d4e814b4d9b3646bc12fc'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0xb5bb4f1a3a5a644d80f97bd60eed0c2dfb2afeb8'
  says: the proxy runs the AToken implementation 0xb5bb4f1a
  for:
  - evidence-3
- id: frozen
  call: '0x2409af0251dcb89ee3dee572629291f9b087c668'
  fn: getConfiguration(address)(uint256)
  args:
  - '0x99d8a9c45b2eca8864373a26d1459e3dff1e17f3'
  is: '184467950254048592527360'
  says: the MIM reserve configuration has the active bit (56) and the frozen bit (57) set
  for:
  - what
- id: admin
  call: '0xc480a11a524e4db27c6d4e814b4d9b3646bc12fc'
  fn: admin()(address)
  from: '0x408c9764993209dc772eb12ff641f4b55f5b005c'
  is: '0x408c9764993209dc772eb12ff641f4b55f5b005c'
  says: the proxy's admin is 0x408c9764, the pool's configurator
  for:
  - admin
  - upgradeable
- id: admin-bytes
  bytecode: '0xc480a11a524e4db27c6d4e814b4d9b3646bc12fc'
  has: 7f000000000000000000000000408c9764993209dc772eb12ff641f4b55f5b005c
  says: the admin is an immutable in the proxy code
  for:
  - admin
- id: upgrade
  source: '0xc480a11a524e4db27c6d4e814b4d9b3646bc12fc'
  file: contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
  line: 50
  has: function upgradeTo(address newImplementation) external ifAdmin {
  says: the admin can replace the implementation
  for:
  - upgradeable
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

uMIM, UwU's interest-bearing MIM token, lets a holder approve a spender by a direct call or by an ECDSA-signed permit. A holder whose account takes real code loses permit and keeps approve; an EIP-7702 delegation keeps working. The MIM market is frozen; 1,208 uMIM remain outstanding.

## Evidence

- [permit](https://etherscan.io/address/0xb5bb4f1a3a5a644d80f97bd60eed0c2dfb2afeb8#code) approves a spender only if ecrecover returns the owner; it has no ERC-1271 path.
- [approve](https://etherscan.io/address/0xb5bb4f1a3a5a644d80f97bd60eed0c2dfb2afeb8#code) sets the caller's own allowance and takes no signature.
- [uMIM](https://etherscan.io/address/0xc480a11a524e4db27c6d4e814b4d9b3646bc12fc#code) runs this code through a proxy and has 1,208 tokens outstanding.

## Reviewer notes

### Mechanism

The address is an Aave v2 style proxy (InitializableImmutableAdminUpgradeabilityProxy) whose EIP-1967 slot points to the AToken implementation 0xb5bb4f1a. permit (AToken.sol, lines 326-349) builds the EIP-712 digest with the owner's nonce and requires owner == ecrecover(digest, v, r, s), then calls _approve(owner, spender, value). There is no ERC-1271 or code-size branch. Under EIP-8151 ecrecover returns nothing for an owner with real code, so the require fails; an EIP-7702 delegated owner still recovers. approve (IncentivizedERC20.sol, lines 109-112) and increaseAllowance set the caller's own allowance with no signature, so an owner with real code keeps the same act by a direct call. Proxy admin is an immutable in the proxy code: 0x408c9764 (the pool's configurator, per getLendingPoolConfigurator on addresses provider 0x011c0d38); upgradeTo is ifAdmin (line 50). Reserve configuration for MIM in pool 0x2409af02: active bit 56 = 1, frozen bit 57 = 1, pool not paused.

### Checks

- Header facts: this address alone, at block 26,438,999; 41 addresses run this code.
- Ruled out: unused implementation: this address is the proxy users call; name() is 'UwU interest bearing MIM' and totalSupply is 1,208.84 uMIM at the block, so it is initialized and in use.
- Ruled out: ERC-1271 or second signed path: permit has none (AToken.sol lines 326-349); no isValidSignature in the implementation source.
- Ruled out: breaks by itself: permit uses Solidity's ecrecover, which forwards all remaining gas, not a fixed amount below 6,100.
- Ruled out: rechecked later: the permit signature is consumed once (nonce incremented) and not checked again after anyone relied on it.
- Ruled out: value: the scaffold counts $0 because MIM is not a priced token; the aToken holds 920.68 MIM (balanceOf at the block), not stated on the card.
- Ruled out: copies: 40 other addresses run the same implementation, several with their own supply; each is its own row and not described here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
