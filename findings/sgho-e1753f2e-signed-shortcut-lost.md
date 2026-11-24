---
id: sgho-e1753f2e-signed-shortcut-lost
format: 2
title: sGHO permits and permit deposits stop working for accounts that take real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only for accounts that move to real code; they can still approve directly and deposit after
  a GHO approval.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  name: sGho
  code: verified
  code_url: https://etherscan.io/address/0xff229a0bbb614a284de8ae0e41e5974878fd7c04#code
  proxy_of: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  copies: 2
  family: 6f4eac71766d1cdf096275409f79328a
  upgradeable: 'yes'
  admin: '0xc15700631020eba02317964550365b95a9a28adb'
value:
  usd: 198671636
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell integrators to approve GHO and call deposit, and approve sGHO shares instead of permit, for accounts
  taking real code.
evidence_level: source
checks:
- id: inherits
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: lib/gho-origin/src/contracts/sgho/sGho.sol
  line: 30
  has: ERC20PermitUpgradeable,
  says: sGho inherits the OpenZeppelin ERC-2612 permit
  for:
  - what
- id: permit
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: lib/gho-origin/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  lines:
  - 66
  - 71
  has: if (signer != owner) {
  says: permit recovers the signer with ECDSA, reverts unless it equals owner, then sets the allowance
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: lib/aave-address-book/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover calls the ecrecover precompile with all gas
  for:
  - evidence-1
  - justification
  - what
- id: approve
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: lib/gho-origin/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol
  lines:
  - 150
  - 153
  has: _approve(owner, spender, value);
  says: approve sets the caller's allowance without a signature
  for:
  - action
  - evidence-2
  - justification
- id: deposit
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: lib/gho-origin/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC4626Upgradeable.sol
  line: 194
  has: function deposit(uint256 assets, address receiver)
  says: anyone deposits GHO and receives shares; the vault holds depositors' GHO
  for:
  - action
  - whose
- id: assets
  call: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  fn: balanceOf(address)(uint256)
  args:
  - '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  is: '198922628289117725997082872'
  says: the vault holds about 198.9M GHO
  for:
  - whose
- id: unpaused
  call: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  fn: paused()(bool)
  is: 'false'
  says: the vault is not paused
  for:
  - what
- id: depwp
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: lib/gho-origin/src/contracts/sgho/sGho.sol
  lines:
  - 117
  - 128
  has: '{} catch {}'
  says: depositWithPermit calls GHO's permit for the caller, ignores a failure, then calls deposit
  for:
  - action
  - evidence-3
  - justification
  - what
- id: pull
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: lib/gho-origin/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC4626Upgradeable.sol
  line: 271
  has: SafeERC20.safeTransferFrom($._asset, caller, address(this), assets);
  says: deposit pulls GHO from the caller, which needs a GHO allowance
  for:
  - action
  - evidence-3
  - justification
  - what
- id: ghosig
  selector: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: GHO's code has no ERC-1271 function
  for:
  - justification
  - what
- id: ghopermit
  selector: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: GHO's own code holds the permit that depositWithPermit calls
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-e1753f2e, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-19): the live sGHO vault (198.9M GHO): an account that takes real code can
    no longer use share permit, and its depositWithPermit reverts unless it approved GHO earlier (GHO''s permit
    is ECDSA-only and the failure is swallowed before the pull); approve and deposit stay open; an EIP-7702 delegation
    keeps both working. Second version after the first refuter found the deposit path; the fresh refuter agrees.
    Claude read the sheet. sGHO''s own PQ-1 exposure is parked for Anon.'
related: []
---

## What happens

sGHO, a live GHO savings vault, accepts a signed permit for its shares and a signed GHO permit in depositWithPermit. For an account with real code both fail: share permits revert, and the deposit reverts without an earlier GHO approval. An EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0xff229a0bbb614a284de8ae0e41e5974878fd7c04#code) recovers the signer with ECDSA and reverts unless it equals the share owner.
- [approve](https://etherscan.io/address/0xff229a0bbb614a284de8ae0e41e5974878fd7c04#code) sets the same allowance for the caller without a signature.
- [depositWithPermit](https://etherscan.io/address/0xff229a0bbb614a284de8ae0e41e5974878fd7c04#code) ignores a failed GHO permit, then pulls GHO from the caller, which needs an existing GHO allowance.

## Reviewer notes

### Mechanism

The proxy runs sGho, which inherits OpenZeppelin ERC20PermitUpgradeable. permit hashes the EIP-712 Permit struct, calls ECDSA.recover (plain ecrecover, all gas forwarded) and reverts unless the recovered address equals owner; on success it calls _approve. Under EIP-8151 ecrecover returns nothing for an owner whose account has real code, so permit reverts for that owner; approve sets the same allowance for msg.sender directly. depositWithPermit (sGho.sol 111-129) calls GHO's permit with the caller as owner inside try/catch, ignores a failure and calls deposit, whose _deposit pulls GHO from the caller with safeTransferFrom (ERC4626Upgradeable.sol 271). GHO's runtime code has permit (d505accf) and no isValidSignature (1626ba7e), so for a caller with real code GHO's permit cannot pass and the deposit reverts unless the caller approved GHO before. approve on GHO plus deposit is the direct path. At the block the vault is not paused and holds about 198.9M GHO.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 path for owners with code: the verified source has no isValidSignature or ERC-1271 code; share permit uses ECDSA only, and GHO's code has no isValidSignature selector.
- Ruled out: a break with nobody migrating: ECDSA.recover calls ecrecover with all gas forwarded, no fixed gas amount; depositWithPermit catches a failing permit.
- Ruled out: GHO's own permit exposure: it belongs to GHO's own row and is not rated here; this card covers only sGHO's use of it in depositWithPermit.
- Ruled out: a dormant or unused address: paused() is false and the vault holds about 198.9M GHO. The second copy of this code is not described here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
