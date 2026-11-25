---
id: sgho-e1753f2e-permit-ecdsa-only
format: 2
title: sGHO permit keeps holders forgeable through ECDSA after they migrate
status: confirmed
severity: MEDIUM
justification: Holders stay forgeable after migrating; fixing it takes an upgrade by the owner of the vault's proxy
  admin.
category: quantum-exposure
pattern: PQ-1
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  name: sGho
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xff229a0bbb614a284de8ae0e41e5974878fd7c04#code
  proxy_of: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  copies: 1
  upgradeable: 'yes'
  admin: '0xc15700631020eba02317964550365b95a9a28adb'
value:
  usd: 198671636
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Upgrade sGHO to a permit that asks owners with real code through ERC-1271 only and refuses their ECDSA signatures.
evidence_level: source
checks:
- id: ecdsa
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: ERC20PermitUpgradeable.sol
  lines:
  - 66
  - 71
  has: address signer = ECDSA.recover(hash, v, r, s); if (signer != owner) { revert ERC2612InvalidSigner(signer,
    owner); } _approve(owner, spender, value);
  says: permit recovers the signer with ECDSA, requires it to be the owner, and sets the owner's allowance for the
    spender
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-sel
  selector: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the implementation's code has the ERC-2612 permit function
  for:
  - evidence-1
- id: no1271
  bytecode: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  has: 1626ba7e
  absent: true
  says: the implementation's code never calls isValidSignature (ERC-1271)
  for:
  - action
  - evidence-1
  - justification
  - what
- id: spend
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: ERC4626Upgradeable.sol
  lines:
  - 288
  - 290
  has: if (caller != owner) { _spendAllowance(owner, caller, shares); }
  says: a withdrawal or redemption by someone other than the owner is paid for from the owner's allowance
  for:
  - evidence-2
  - what
- id: pay
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: ERC4626Upgradeable.sol
  lines:
  - 298
  - 299
  has: _burn(owner, shares); SafeERC20.safeTransfer($._asset, receiver, assets);
  says: the owner's shares are burned and the GHO goes to the receiver the caller names
  for:
  - evidence-2
  - what
- id: mint
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: ERC4626Upgradeable.sol
  lines:
  - 271
  - 272
  has: SafeERC20.safeTransferFrom($._asset, caller, address(this), assets); _mint(receiver, shares);
  says: deposited GHO stays in the vault and the shares are minted to the depositor's receiver
  for:
  - whose
- id: norescue
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: sGho.sol
  lines:
  - 170
  - 171
  has: if (erc20Token == asset()) { return 0; // Cannot rescue GHO
  says: the rescue role cannot take the vault's GHO
  for:
  - whose
- id: author
  source: '0xff229a0bbb614a284de8ae0e41e5974878fd7c04'
  file: sGho.sol
  line: 22
  has: '@author kpk, TokenLogic & Aave Labs'
  says: the verified source names its authors, among them Aave Labs
  for:
  - notes
- id: asset
  call: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  fn: asset()(address)
  is: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  says: the vault's underlying asset is GHO
  for:
  - what
- id: paused
  call: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  fn: paused()(bool)
  is: false
  says: the vault is not paused at the block
  for:
  - evidence-2
- id: gho-held
  call: '0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f'
  fn: balanceOf(address)(uint256)
  args:
  - '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  is: '198922628289117725997082872'
  says: the vault holds about 198.92M GHO
  for:
  - notes
- id: shares
  call: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  fn: totalSupply()(uint256)
  is: '194505068865222283937398016'
  says: about 194.5M sGHO shares are outstanding
  for:
  - notes
- id: admin-slot
  storage: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0xc15700631020eba02317964550365b95a9a28adb'
  says: the proxy's EIP-1967 admin is 0xc157…8adb
  for:
  - evidence-3
- id: admin-made
  source: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  file: lib/aave-address-book/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
  line: 80
  has: _admin = address(new ProxyAdmin(initialOwner));
  says: the proxy's admin is a ProxyAdmin the proxy created for its initial owner
  for:
  - evidence-3
- id: dispatch
  source: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  file: lib/aave-address-book/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol
  lines:
  - 96
  - 101
  has: if (msg.sender == _proxyAdmin()) { if (msg.sig != ITransparentUpgradeableProxy.upgradeToAndCall.selector)
    { revert ProxyDeniedAdminAccess(); } else { _dispatchUpgradeToAndCall(); }
  says: the admin can call upgradeToAndCall on the proxy to replace its implementation
  for:
  - action
  - evidence-3
- id: upgrade
  source: '0xe1753f2e00940cc31213dd92013cf019dfe4ca1d'
  file: lib/aave-address-book/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/transparent/ProxyAdmin.sol
  lines:
  - 38
  - 43
  has: 'function upgradeAndCall( ITransparentUpgradeableProxy proxy, address implementation, bytes memory data )
    public payable virtual onlyOwner { proxy.upgradeToAndCall{value: msg.value}(implementation, data);'
  says: the ProxyAdmin's owner upgrades the proxy with upgradeAndCall
  for:
  - action
  - evidence-3
  - justification
- id: pa-upgrade-sel
  selector: '0xc15700631020eba02317964550365b95a9a28adb'
  fn: upgradeAndCall(address,address,bytes)
  says: the admin contract at the slot has the upgradeAndCall function
  for:
  - notes
- id: pa-owner
  call: '0xc15700631020eba02317964550365b95a9a28adb'
  fn: owner()(address)
  is: '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  says: the ProxyAdmin's owner is 0x5300…192a
  for:
  - action
  - evidence-3
  - justification
- id: owner-code
  code: '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: contract
  bytes: 1808
  says: the ProxyAdmin's owner is a contract
  for:
  - notes
- id: owner-exec
  selector: '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  fn: executeTransaction(address,uint256,string,bytes,bool)
  says: the owner contract has a function to make calls, so it is not a contract with no way to call
  for:
  - notes
- id: owner-owner
  call: '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  fn: owner()(address)
  is: '0xdabad81af85554e9ae636395611c58f7ec1aaec5'
  says: the owner contract is itself owned by contract 0xdaba…aec5
  for:
  - notes
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
  rating: MEDIUM
  note: 'kept: MEDIUM (PQ-1), a lead added by Anon (D-029): sGHO permit keeps holders forgeable through ECDSA after
    they migrate. Holders stay forgeable after migrating; fixing it takes an upgrade by the owner of the vault''s
    proxy admin. Fix: Upgrade sGHO to a permit that asks owners with real code through ERC-1271 only and refuses
    their ECDSA signatures. Unlike GHO''s HIGH card, this vault''s proxy can be upgraded. The refuter agrees; Claude
    read the card and the answer.'
related: []
---

## What happens

sGHO, a GHO savings vault, lets a spender take a holder's shares once the holder's ECDSA key signs a permit. It never asks the holder's account, so a quantum attacker who recovers the key can redeem the shares for GHO, even after the holder moves to post-quantum authorisation.

## Evidence

- [permit](https://etherscan.io/address/0xff229a0bbb614a284de8ae0e41e5974878fd7c04#code) sets the allowance when the ECDSA signer equals the owner; the code never calls ERC-1271.
- With that allowance, [redeem](https://etherscan.io/address/0xff229a0bbb614a284de8ae0e41e5974878fd7c04#code) burns the owner's shares and sends their GHO to any receiver; the vault is not paused.
- The [proxy](https://etherscan.io/address/0xe1753f2e00940cc31213dd92013cf019dfe4ca1d#code) can be upgraded by its admin contract, owned by contract [0x5300…192a](https://etherscan.io/address/0x5300a1a15135ea4dc7ad5a167152c01efc9b192a).

## Reviewer notes

### Mechanism

The proxy (EIP-1967, implementation 0xff22…7c04) runs sGho, an ERC-4626 vault over GHO with an ERC-2612 permit inherited from OpenZeppelin 5.1 ERC20PermitUpgradeable. permit (lines 49-72) hashes the typed message with the owner's nonce, recovers the signer with ECDSA.recover and, if it equals owner, calls _approve(owner, spender, value). There is no ERC-1271 branch: the implementation's runtime code has no isValidSignature selector. With the allowance, redeem/withdraw call _withdraw, which spends the owner's allowance when the caller is not the owner, burns the owner's shares and transfers the GHO to any receiver; transferFrom moves the shares directly. A holder who moves the same address to post-quantum authorisation (EIP-8141 frames or a smart account) is still bound by its old ECDSA key here, because the vault never asks the account. Fix path: the proxy's admin slot holds 0xc157…8adb, the ProxyAdmin that the OpenZeppelin 5 TransparentUpgradeableProxy constructor creates; its upgradeAndCall (onlyOwner) calls upgradeToAndCall on the proxy. Its owner is 0x5300…192a, a 1,808-byte contract with an executeTransaction function, itself owned by contract 0xdaba…aec5. A contract upgrade is the fix: MEDIUM under the exposure rubric. State at block 26,438,999: not paused, 194.5M shares, totalAssets 198.85M GHO, 198.92M GHO held, supply cap 400M, target rate 450 bp.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: permit compares the recovered address with owner and nothing else (ERC20PermitUpgradeable lines 66-71), and the implementation's code lacks the isValidSignature selector 0x1626ba7e.
- Ruled out: an unused address: this is the proxy depositors call; at the block it holds 198.92M GHO, has 194.5M shares outstanding and is not paused. The dossier lists no copies or dependents.
- Ruled out: a fix by setting: the pause guardian can pause share transfers (whenNotPaused on _update), but permit never goes through _update, so a pause does not close the ECDSA path; only an upgrade changes permit.
- Ruled out: an inability to upgrade: the admin slot holds a ProxyAdmin whose owner is a contract with an executeTransaction function (selector present), not a zero or dead address; I did not read that contract's source.
- Ruled out: depositWithPermit: it calls GHO's own permit for the caller's GHO inside try/catch; that is GHO's check, covered by GHO's own card, not sGho's.
- Ruled out: the EIP-8151 notice on this address (row signed-shortcut-lost) is a separate root issue; not folded in here.
- Ruled out: a replay: the dossier has no scan data or replays for this address, so the evidence is the verified source and reads at the block.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
