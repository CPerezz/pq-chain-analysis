---
id: anchoragetokenusdtb-c139190f-permit-signature
format: 2
title: USDtb holders can be drained by a forged ECDSA permit, even after migrating
status: confirmed
severity: MEDIUM
justification: A forged permit takes a holder's tokens even after the holder migrates; fixing it needs a contract
  upgrade.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc139190f447e929f090edeb554d95abb8b18ac1c'
  name: AnchorageTokenUSDtb
  code: verified
  code_url: https://etherscan.io/address/0x9d6d77a21702b9afcf924983fbfb84aaaae79589#code
  proxy_of: '0x9d6d77a21702b9afcf924983fbfb84aaaae79589'
  copies: 1
  upgradeable: 'yes'
  admin: '0x3c405f68d5c6ece868e5646cac926679839acd68'
value:
  usd: 325109423
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade permit to refuse ECDSA for holders whose accounts have real code and to ask those accounts through
  ERC-1271 only.
evidence_level: source
checks:
- id: permit-recover
  source: '0x9d6d77a21702b9afcf924983fbfb84aaaae79589'
  file: lib/openzeppelin-contracts-upgradeable-v4/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  lines:
  - 71
  - 72
  has: address signer = ECDSAUpgradeable.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA and requires it to equal owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0x9d6d77a21702b9afcf924983fbfb84aaaae79589'
  file: lib/openzeppelin-contracts-upgradeable-v4/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol
  line: 74
  has: _approve(owner, spender, value);
  says: a valid permit approves the spender on the holder's own balance
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: permit-inherit
  source: '0x9d6d77a21702b9afcf924983fbfb84aaaae79589'
  file: src/AnchorageTokenUSDtb.sol
  line: 76
  has: ERC20PermitUpgradeable,
  says: the token inherits OpenZeppelin's permit
  for:
  - what
- id: permit-selector
  selector: '0x9d6d77a21702b9afcf924983fbfb84aaaae79589'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the running implementation has permit
  for:
  - what
- id: admin-slot
  storage: '0xc139190f447e929f090edeb554d95abb8b18ac1c'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0x3c405f68d5c6ece868e5646cac926679839acd68'
  says: the proxy's admin is ProxyAdmin 0x3c405f68
  for:
  - action
  - evidence-2
  - justification
- id: upgrade-fn
  selector: '0x3c405f68d5c6ece868e5646cac926679839acd68'
  fn: upgradeAndCall(address,address,bytes)
  says: the ProxyAdmin can upgrade the proxy
  for:
  - action
  - evidence-2
  - justification
- id: admin-owner
  call: '0x3c405f68d5c6ece868e5646cac926679839acd68'
  fn: owner()(address)
  is: '0xd93826bb299765c87d13aeba2a7e5d9b27a03956'
  says: the ProxyAdmin is owned by 0xd93826bb
  for:
  - action
  - evidence-2
  - justification
- id: owner-eoa
  code: '0xd93826bb299765c87d13aeba2a7e5d9b27a03956'
  is: empty
  says: 'the ProxyAdmin owner has no code: an externally owned account'
  for:
  - action
  - evidence-2
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
- who: r-c139190f, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 're-rated: Re-rated HIGH -> MEDIUM (PQ-1): USDtb (Anchorage) inherits OZ ERC20PermitUpgradeable''s ECDSA-only
    permit, so a holder that migrates stays forgeable; unlike USDe and sUSDe it is an upgradeable proxy whose ProxyAdmin
    is owned by a live EOA (nonce 15), so the fix is a reachable upgrade. Token supply affected (upper bound) about
    $325.1M. Two refuters agree; Claude read the sheet.'
related: []
---

## What happens

USDtb lets a holder approve a spender by signing a permit, which it checks with ECDSA alone. A quantum attacker who recovers a holder's key can sign a permit to itself and take the tokens, even after the holder moves to post-quantum keys at the same address.

## Evidence

- [permit](https://etherscan.io/address/0x9d6d77a21702b9afcf924983fbfb84aaaae79589#code) recovers the signer with ECDSA, requires it to be the owner and approves the spender; it never asks the account.
- USDtb is a [proxy](https://etherscan.io/address/0xc139190f447e929f090edeb554d95abb8b18ac1c#code) whose admin contract can upgrade it; one externally owned account owns that admin.

## Reviewer notes

### Mechanism

The proxy 0xc139190f delegates to AnchorageTokenUSDtb 0x9d6d77a2, which inherits OpenZeppelin 4.9 ERC20PermitUpgradeable (line 76) and does not override permit. permit (ERC20PermitUpgradeable.sol lines 56-75) builds the EIP-712 digest with the owner's nonce, takes ECDSAUpgradeable.recover(hash, v, r, s), requires it to equal owner and calls _approve(owner, spender, value); the spender then uses transferFrom. The account is never asked through ERC-1271, so an address that later moves to post-quantum authorisation stays signable with its old key. State at block 26,438,999: name USDtb, totalSupply 325,206,094.6 tokens, paused() false. Fix path: the EIP-1967 admin slot holds ProxyAdmin 0x3c405f68 (has upgradeAndCall), whose owner() is 0xd93826bb, an account with no code and nonce 15. Rated by the quantum-exposure table, step 3: the fix is a contract upgrade (MEDIUM). The old card's HIGH was set by USDe and sUSDe, which cannot be upgraded; it does not apply to this address.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or second signature path: the implementation's only recovery is permit's ECDSAUpgradeable.recover; no isValidSignature anywhere in the verified source.
- Ruled out: a closed path: paused() is false at the block and the token has supply.
- Ruled out: unused implementation: this is the proxy users call, with 325.2M tokens in supply.
- Ruled out: approve as an alternative: it lets a post-quantum holder grant allowances directly, but does not stop a forged permit for a migrated holder.
- Ruled out: the blocklister role can block an account's transfers, but that is a reaction per account, not a fix of the path.
- Ruled out: breaks under EIP-8151 alone: the dossier's replay of 0x939e193d passes under the eip8151 run; not cited, because the transaction's other calls were not read.
- Ruled out: a separate issue: the ProxyAdmin owner 0xd93826bb is itself an ECDSA key that controls the token's code (a wallet/admin-key exposure); not folded into this card.
- Ruled out: project: the verified source names Anchorage (contract name, security contact) while the first study filed it under Ethena; left unset.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
