---
id: metamorpho-beef0173-share-permit
format: 2
title: Steakhouse USDC vault shares can be taken with a forged ECDSA permit
status: confirmed
severity: HIGH
justification: Holders' shares stay forgeable after they migrate their account, and nobody can change the vault's
  permit check.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  name: MetaMorpho
  project: morpho
  code: verified
  code_url: https://etherscan.io/address/0xbeef01735c132ada46aa9aa4c54623caa92a64cb#code
  copies: 1
  upgradeable: 'no'
  admin: '0x0a0e559bc3b0950a7e448f0d4894db195b9cf8dd'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Tell holders to move shares to a fresh account before migrating; new vaults should ask owners with real
  code via ERC-1271 only.
evidence_level: source
checks:
- id: name
  call: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  fn: name()(string)
  is: Steakhouse USDC
  says: the vault's token name is Steakhouse USDC
  for:
  - what
- id: permit
  source: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  lines:
  - 61
  - 66
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA, requires it to equal owner, then approves the spender
  for:
  - action
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  has: 631626ba7e
  absent: true
  says: the runtime code never pushes the ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - justification
  - what
- id: withdraw-allowance
  source: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol
  lines:
  - 267
  - 269
  has: _spendAllowance(owner, caller, shares);
  says: redeem and withdraw for another owner need only that owner's allowance
  for:
  - what
  - whose
- id: mint-receiver
  source: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol
  line: 252
  has: _mint(receiver, shares);
  says: 'deposits mint shares to the depositor''s receiver: the shares are users'''
  for:
  - whose
- id: transfer-direct
  source: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
  lines:
  - 109
  - 111
  has: address owner = _msgSender();
  says: a holder can transfer its shares by a direct call, without a signature
  for:
  - action
- id: no-proxy
  storage: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-2
  - justification
  - upgradeable
- id: no-upgrade
  selector: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - evidence-2
  - justification
  - upgradeable
- id: multicall-self
  source: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  file: lib/openzeppelin-contracts/contracts/utils/Multicall.sol
  line: 19
  has: Address.functionDelegateCall(address(this), data[i])
  says: the only delegate call runs the vault's own code
  for:
  - evidence-2
  - justification
  - upgradeable
- id: asset
  call: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  fn: asset()(address)
  is: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'
  says: the vault's asset is USDC
  for:
  - evidence-2
- id: total-assets
  call: '0xbeef01735c132ada46aa9aa4c54623caa92a64cb'
  fn: totalAssets()(uint256)
  is: 71786982491213
  says: the vault manages 71,786,982.49 USDC (6 decimals)
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review23 (finding review)
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
reviews: []
related: []
---

## What happens

Steakhouse USDC, a Morpho vault, accepts an ECDSA-signed permit from a share holder to approve a spender. A quantum attacker with a holder's key can permit itself the shares and redeem them, even after the holder moves the address to post-quantum authorisation: the vault never asks the account.

## Evidence

- [permit](https://etherscan.io/address/0xbeef01735c132ada46aa9aa4c54623caa92a64cb#code) sets the allowance when the ECDSA-recovered signer equals the owner; the vault has no ERC-1271 check.
- The [vault](https://etherscan.io/address/0xbeef01735c132ada46aa9aa4c54623caa92a64cb) is not a proxy, has no upgrade function, and manages 71.79M USDC of depositors' assets.

## Reviewer notes

### Mechanism

MetaMorpho inherits OpenZeppelin v5 ERC20Permit. permit (ERC20Permit.sol lines 44-67) builds the EIP-712 hash with the owner's nonce, calls ECDSA.recover (ecrecover, ECDSA.sol line 142) and reverts unless the recovered signer equals `owner`, then calls _approve(owner, spender, value). No isValidSignature call exists in any source file of the vault, and the runtime code has no PUSH4 of 0x1626ba7e. With the allowance, the spender can transferFrom the shares, or call redeem/withdraw with owner = holder: ERC4626._withdraw spends the allowance when caller != owner (lines 267-269) and pays any receiver from the vault's Morpho Blue positions. The only DELEGATECALL is Multicall.multicall, which delegates to address(this) (Multicall.sol line 19), so the code cannot be swapped; the EIP-1967 slot is empty and there is no upgradeTo. The owner (a Safe 1.4.1, 5 of 10) sets curator, fees, timelock and guardian, none of which touch permit. Direct paths need no signature: approve, transfer and redeem by the holder's own address (ERC20.sol lines 109-113, 132-136).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for owners with code: no isValidSignature in the source, no 0x1626ba7e PUSH4 in the runtime code.
- Ruled out: unused implementation: the vault itself is in use, totalAssets is 71,786,982.49 USDC and it is not a proxy or clone.
- Ruled out: an upgrade that could change permit: EIP-1967 slot empty, no upgradeTo selector; the DELEGATECALL is multicall to itself.
- Ruled out: breaks by itself under EIP-8151: the family's only replay (tx 0x3bb7b21f…, on another vault 0xc080f565…) succeeds under eip8151; it is not this address, so it is not cited.
- Ruled out: Morpho Blue's setAuthorizationWithSig is on another contract (0xbbbbbbbb…) and belongs to its own row; the old finding bundled five addresses.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
