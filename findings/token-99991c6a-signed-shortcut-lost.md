---
id: token-99991c6a-signed-shortcut-lost
format: 2
title: CAP holders lose permit once their accounts take real code
status: confirmed
severity: INFORMATIONAL
justification: Only the signed approval stops, and only for a holder that moves to real code; approve keeps working.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x99991c6aabba5a096f24f250b73580f5179b9999'
  name: Token
  project: cap-labs
  label: 'cap: CAP Token 2'
  code: verified
  code_url: https://etherscan.io/address/0x9c850771b321c6e7aa909413b5cc98c86ccba96f#code
  proxy_of: '0x9c850771b321c6e7aa909413b5cc98c86ccba96f'
  copies: 2
  family: e90d2ee8f25a68b5ab65de11f2d8575f
  upgradeable: 'yes'
  admin: '0x00000000c3da1f276183e66ebdb2b6db7763b709'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell holders to use approve, not permit, once their account takes real code; an EIP-7702 delegation keeps
  permit.
evidence_level: source
checks:
- id: permit-match
  source: '0x9c850771b321c6e7aa909413b5cc98c86ccba96f'
  file: node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  lines:
  - 64
  - 69
  has: if (signer != owner) {
  says: permit recovers the signer and reverts unless it equals the holder named in the call, then sets that holder's
    allowance
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: ecdsa
  source: '0x9c850771b321c6e7aa909413b5cc98c86ccba96f'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is the ecrecover precompile, with no gas constant
  for:
  - evidence-1
  - what
- id: approve
  source: '0x9c850771b321c6e7aa909413b5cc98c86ccba96f'
  file: node_modules/@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
  lines:
  - 143
  - 147
  has: address owner = _msgSender();
  says: approve sets the caller's own allowance without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
  - whose
- id: sel-permit
  selector: '0x9c850771b321c6e7aa909413b5cc98c86ccba96f'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the running implementation has permit
  for:
  - what
- id: sel-approve
  selector: '0x9c850771b321c6e7aa909413b5cc98c86ccba96f'
  fn: approve(address,uint256)
  says: the running implementation has approve
  for:
  - evidence-2
- id: token-name
  call: '0x99991c6aabba5a096f24f250b73580f5179b9999'
  fn: symbol()(string)
  is: CAP
  says: the token at this address is CAP and is initialized
  for:
  - what
- id: author
  source: '0x9c850771b321c6e7aa909413b5cc98c86ccba96f'
  file: contracts/token/Token.sol
  line: 11
  has: Cap Labs
  says: the verified source names Cap Labs as author
  for:
  - notes
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

The CAP token lets a holder approve a spender by calling approve or by signing a permit that anyone submits. A permit counts only if the ECDSA signer is the holder; there is no ERC-1271 path. A holder whose account takes real code loses permit and keeps approve.

## Evidence

- [permit](https://etherscan.io/address/0x9c850771b321c6e7aa909413b5cc98c86ccba96f#code) recovers the signer with ECDSA and reverts unless it equals the holder.
- [approve](https://etherscan.io/address/0x9c850771b321c6e7aa909413b5cc98c86ccba96f#code) sets the caller's own allowance with no signature.

## Reviewer notes

### Mechanism

The proxy delegates to Token (OpenZeppelin 5 ERC20PermitUpgradeable, Ownable, UUPS). permit (ERC20PermitUpgradeable.sol lines 47-70) checks the deadline, hashes the EIP-712 Permit struct with the holder's nonce, calls ECDSA.recover (ecrecover with all remaining gas, ECDSA.sol line 148) and reverts with ERC2612InvalidSigner unless the recovered address equals owner; then _approve(owner, spender, value). approve (ERC20Upgradeable.sol lines 143-147) sets the same allowance for msg.sender with no signature. No isValidSignature/ERC-1271 anywhere in the sources. Token.sol adds only initialize and _authorizeUpgrade (onlyOwner). State at block 26,438,999: name Cap, symbol CAP, totalSupply 1e28, owner 0x00000000c3da...b709 (a contract), implementation slot 0x9c85...a96f.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: erc1271: permit has no ERC-1271 or code-size branch (ERC20PermitUpgradeable.sol lines 64-67; no isValidSignature in any source file).
- Ruled out: unused-implementation: this address is the initialized proxy (name Cap, totalSupply 1e28). The only copy, 0x9c85...a96f, is the implementation itself: its constructor disables initializers and at the block its name() is empty and totalSupply() is 0, so it is not used on its own.
- Ruled out: gas / breaks-by-itself: ECDSA.recover uses Solidity ecrecover with all remaining gas, no constant; the one real recovery in the window (tx 0xf416fa93...797e, signer an EOA) passes in the EIP-8151 replay. That replay is not cited: it shows nothing breaks for an EOA signer.
- Ruled out: rechecked-later: the permit signature is consumed once (nonce) and never checked again; nobody relies on it after the approval is set.
- Ruled out: direct-path: approve exists and needs no signature (ERC20Upgradeable.sol lines 143-147; selector 0x095ea7b3 in the implementation code).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
