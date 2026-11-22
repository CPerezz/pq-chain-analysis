---
id: stakedaavev3-4da27a54-signed-shortcut-lost
format: 2
title: Staked Aave holders whose accounts take real code lose permit
status: confirmed
severity: INFORMATIONAL
justification: The direct approve and delegate calls still work with no signature needed.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4da27a545c0c5b758a6ba100e3a049001de870f5'
  name: StakedAaveV3
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0x0fe58fe1caa69951dc924a8c222be19013b89476#code
  proxy_of: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  copies: 2
  family: 8331b4fc7a7a197330e593b45cd126c1
  upgradeable: 'yes'
  admin: '0x86c3ffee349a7cff7ca88c449717b1b133bfb517'
value:
  usd: 273781669
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell stkAAVE holders that permit and metaDelegate stop working once their accounts take real code; use approve
  and delegate directly.
evidence_level: source
checks:
- id: permit
  source: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  file: src/contracts/StakedTokenV2.sol
  line: 140
  has: require(owner == ECDSA.recover(digest, v, r, s), 'INVALID_SIGNATURE');
  says: permit sets an allowance only when the ECDSA-recovered address is the owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve
  source: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  file: lib/aave-token-v3/src/BaseAaveToken.sol
  lines:
  - 74
  - 76
  has: _approve(owner, spender, amount);
  says: approve sets the caller's allowance without a signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: meta-delegate
  source: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  file: lib/aave-token-v3/src/BaseDelegation.sol
  line: 191
  has: require(delegator == ECDSA.recover(digest, v, r, s), 'INVALID_SIGNATURE');
  says: metaDelegate delegates only when the ECDSA-recovered address is the delegator
  for:
  - action
  - evidence-2
  - justification
  - what
- id: meta-delegate-type
  source: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  file: lib/aave-token-v3/src/BaseDelegation.sol
  line: 168
  has: require(delegator == ECDSA.recover(digest, v, r, s), 'INVALID_SIGNATURE');
  says: metaDelegateByType delegates only when the ECDSA-recovered address is the delegator
  for:
  - evidence-2
  - what
- id: delegate
  source: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  file: lib/aave-token-v3/src/BaseDelegation.sol
  lines:
  - 93
  - 95
  has: _delegateByType(msg.sender, delegatee, GovernancePowerType.VOTING);
  says: delegate delegates the caller's power without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: delegate-type
  source: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  file: lib/aave-token-v3/src/BaseDelegation.sol
  line: 89
  has: _delegateByType(msg.sender, delegatee, delegationType);
  says: delegateByType delegates the caller's power of one type without a signature
  for:
  - what
- id: ecrecover
  source: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 161
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is the ecrecover precompile, which EIP-8151 changes
  for:
  - what
- id: stake-mint
  source: '0x0fe58fe1caa69951dc924a8c222be19013b89476'
  file: src/contracts/StakedTokenV3.sol
  lines:
  - 471
  - 473
  has: _mint(to, sharesToMint.toUint104());
  says: staking takes the staker's AAVE and mints stkAAVE shares to the staker
  for:
  - whose
- id: impl-slot
  storage: '0x4da27a545c0c5b758a6ba100e3a049001de870f5'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x0000000000000000000000000fe58fe1caa69951dc924a8c222be19013b89476'
  says: the proxy runs the StakedAaveV3 implementation 0x0fe58fe1
  for:
  - evidence-3
- id: name
  call: '0x4da27a545c0c5b758a6ba100e3a049001de870f5'
  fn: name()(string)
  is: Staked Aave
  says: the token's name is Staked Aave
  for:
  - evidence-3
- id: supply
  call: '0x4da27a545c0c5b758a6ba100e3a049001de870f5'
  fn: totalSupply()(uint256)
  is: '2464174202152512939022861'
  says: about 2.46M stkAAVE are held by stakers
  for:
  - evidence-3
  - whose
- id: aave-held
  call: '0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9'
  fn: balanceOf(address)(uint256)
  args:
  - '0x4da27a545c0c5b758a6ba100e3a049001de870f5'
  is: '2464175769327503698813554'
  says: the contract holds about 2.46M AAVE
  for:
  - evidence-3
  - whose
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

Staked Aave lets a holder approve a spender or delegate voting power with an ECDSA signature that anyone can submit. A holder whose account takes real code loses this signed path; an EIP-7702 delegation keeps it. Direct approve and delegate calls keep working.

## Evidence

- [permit](https://etherscan.io/address/0x0fe58fe1caa69951dc924a8c222be19013b89476#code) approves only if the ECDSA-recovered address equals the owner; approve does the same for the caller.
- [metaDelegate](https://etherscan.io/address/0x0fe58fe1caa69951dc924a8c222be19013b89476#code) and metaDelegateByType require the recovered address to be the delegator; delegate needs no signature.
- [Staked Aave](https://etherscan.io/address/0x4da27a545c0c5b758a6ba100e3a049001de870f5#code) runs this code and holds about 2.46M AAVE staked by its holders.

## Reviewer notes

### Mechanism

The proxy 0x4da27a54 (EIP-1967 slot -> StakedAaveV3 0x0fe58fe1) runs StakedTokenV2.permit (lines 114-144): it builds the EIP-712 digest with the owner's nonce and requires owner == ECDSA.recover(digest, v, r, s) (line 140), then _approve(owner, spender, value). BaseDelegation.metaDelegateByType (142-170) and metaDelegate (173-194) require delegator == ECDSA.recover (lines 168, 191) and then delegate. OZ ECDSA.recover calls the ecrecover precompile with all gas (line 161) and reverts on address(0), so under EIP-8151 a holder whose account has real code gets INVALID_SIGNATURE / ECDSA revert. Direct equivalents: BaseAaveToken.approve (74-78) uses msg.sender; BaseDelegation.delegateByType (84-90) and delegate (93-96) use msg.sender. The proxy admin 0x86c3ffee has code and can upgrade the implementation.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 path for owners with code: the verified source of the implementation has no isValidSignature call; permit and metaDelegate compare only with ECDSA.recover (lines 140, 168, 191).
- Ruled out: a fixed gas budget: OZ ECDSA calls the ecrecover builtin, which forwards all gas (ECDSA.sol line 161); nothing here breaks without a holder migrating.
- Ruled out: unused implementation: this address is the proxy in use, with 2.46M stkAAVE supply and about 2.46M AAVE held at the block.
- Ruled out: stakeWithPermit: its signature is checked by the AAVE token (StakedTokenV3 line 179), not by this contract, and a failed permit is caught; staking then needs a prior AAVE approval, and stake() is the direct path. That belongs to the AAVE token's own row.
- Ruled out: copies: the dossier notes the row stands for 2 addresses with this code but lists none, so no other copy is judged here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
