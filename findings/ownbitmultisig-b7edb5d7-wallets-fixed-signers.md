---
id: ownbitmultisig-b7edb5d7-wallets-fixed-signers
format: 2
title: Ownbit 2-of-3 wallet locks its funds if two owners move to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless owners move their accounts to real code, and the owners can move the funds
  to a new wallet first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  name: OwnbitMultiSig
  project: ownbit
  code: verified
  code_url: https://etherscan.io/address/0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f#code
  copies: 138
  family: 0464e742c63410fcfed3ae5235ee9d96
  upgradeable: 'no'
value:
  usd: 466002
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Move this wallet's funds to a new wallet before a second of its three owners moves its account to real code.
evidence_level: executed
checks:
- id: ecdsa
  source: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  file: OwnbitMultiSig.sol
  line: 127
  has: addrs[i] = ecrecover(message, vs[i]+27, rs[i], ss[i]);
  says: each signature is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: isowner
  source: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  file: OwnbitMultiSig.sol
  lines:
  - 138
  - 141
  has: if (!isOwner[addrs[i]]) {
  says: every recovered address must be an owner, or the signatures are refused
  for:
  - evidence-1
  - what
  - whose
- id: required
  source: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  file: OwnbitMultiSig.sol
  line: 122
  has: require(vs.length >= required);
  says: at least `required` signatures are needed
  for:
  - evidence-1
  - what
- id: ctor
  source: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  file: OwnbitMultiSig.sol
  lines:
  - 51
  - 61
  has: owners = _owners;
  says: the constructor sets the owners and the threshold
  for:
  - what
- id: spendcall
  source: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  file: OwnbitMultiSig.sol
  lines:
  - 105
  - 114
  has: '(bool sent, bytes memory _ret) = destination.call{value: value}(data);'
  says: a spend signed by enough owners can send any value or token call to any other address
  for:
  - action
  - justification
- id: owners
  call: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  fn: getOwners()(address[])
  is:
  - '0x17f0Db3f87B86c4121B07dFf266e98a0753792C2'
  - '0x33b9393ace303FBEEfe1D8487bF79F51F8B7cb83'
  - '0xEc77D7d83A20f0B4Bb4ae3664c4E8E1CC5844a55'
  says: the wallet has three owners
  for:
  - action
  - evidence-3
  - what
  - whose
- id: required-call
  call: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  fn: getRequired()(uint256)
  is: 2
  says: two owner signatures are required
  for:
  - action
  - what
- id: code1
  code: '0x17f0db3f87b86c4121b07dff266e98a0753792c2'
  is: empty
  says: the first owner has no code
  for:
  - evidence-3
- id: code2
  code: '0x33b9393ace303fbeefe1d8487bf79f51f8b7cb83'
  is: empty
  says: the second owner has no code
  for:
  - evidence-3
- id: code3
  code: '0xec77d7d83a20f0b4bb4ae3664c4e8e1cc5844a55'
  is: empty
  says: the third owner has no code
  for:
  - evidence-3
- id: no-add
  selector: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  fn: addOwner(address)
  absent: true
  says: there is no addOwner function
  for:
  - what
- id: no-remove
  selector: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  fn: removeOwner(address)
  absent: true
  says: there is no removeOwner function
  for:
  - what
- id: no-replace
  selector: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  fn: replaceOwner(address,address)
  absent: true
  says: there is no replaceOwner function
  for:
  - what
- id: no-change
  selector: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  fn: changeRequirement(uint256)
  absent: true
  says: there is no changeRequirement function
  for:
  - what
- id: replay-code
  replay: '0x7f54027484285f2197ddad97349f2de9495eeb7938e0e759653f530968520741'
  run: eip8151_signer_code
  ok: false
  says: a real spend on a copy of this code reverts under EIP-8151 when the signer has code
  for:
  - evidence-2
  - what
- id: replay-deleg
  replay: '0x7f54027484285f2197ddad97349f2de9495eeb7938e0e759653f530968520741'
  run: eip8151_signer_delegated
  ok: true
  says: the same spend passes when the signer has an EIP-7702 delegation
  for:
  - evidence-2
  - what
- id: replay-today-rule
  replay: '0x7f54027484285f2197ddad97349f2de9495eeb7938e0e759653f530968520741'
  run: eip8151
  ok: true
  says: the same spend passes under EIP-8151 when nobody migrates
  for:
  - evidence-2
  - justification
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  is: 466463990000
  says: the wallet holds 466,463.99 USDT
  for:
  - evidence-3
- id: spendnonce
  call: '0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f'
  fn: getSpendNonce()(uint256)
  is: 1
  says: the wallet has made one spend
  for:
  - notes
- id: nonce1
  nonce: '0x17f0db3f87b86c4121b07dff266e98a0753792c2'
  is: 0
  says: the first owner has sent no transaction
  for:
  - notes
- id: nonce2
  nonce: '0x33b9393ace303fbeefe1d8487bf79f51f8b7cb83'
  is: 0
  says: the second owner has sent no transaction
  for:
  - notes
- id: nonce3
  nonce: '0xec77d7d83a20f0b4bb4ae3664c4e8e1cc5844a55'
  is: 0
  says: the third owner has sent no transaction
  for:
  - notes
- id: copy-22-req
  call: '0x527d87a0502cf6bc60be5db7158e0e51bfb86c56'
  fn: getRequired()(uint256)
  is: 2
  says: a copy needs two signatures
  for:
  - notes
- id: copy-22-own
  call: '0x527d87a0502cf6bc60be5db7158e0e51bfb86c56'
  fn: getOwners()(address[])
  is:
  - '0x8F9875fe35fB14b1Fb893184cF06091C82a63185'
  - '0xc6476319D6683aD53DBe10FAc0Ed27ca7b89CFC0'
  says: that copy has two owners
  for:
  - notes
- id: copy-33-req
  call: '0x070f50ab6a7115187593e3e363d23e8d6f75a8ca'
  fn: getRequired()(uint256)
  is: 3
  says: another copy needs three signatures
  for:
  - notes
- id: copy-33-own
  call: '0x070f50ab6a7115187593e3e363d23e8d6f75a8ca'
  fn: getOwners()(address[])
  is:
  - '0x70c61880154e26f104b48ccA91F7bbFEe37e345a'
  - '0x24778d767528de745Ff0950cD13DC916792789a6'
  - '0x53B1564532D62Ee3ecd588A4443F69aFc4Bb8838'
  says: that copy has three owners
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-b7edb5d7, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: 'agree: evidence-3 (wording only, facts hold): ''none with code at the block'' is a working-note phrase;
    say ''none has code'' and let the as-of date carry the time'
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-17): an Ownbit 2-of-3 wallet holding 466,463.99 USDT whose owners are fixed
    in the constructor; once two owners move to real code it can never spend again (an EIP-7702 delegation still
    counts). Move the funds first. The replay on a same-code copy reverts under eip8151_signer_code only. Refuter
    agrees (wording nit only); Claude read the sheet.'
related: []
---

## What happens

This Ownbit wallet needs ECDSA signatures from two of its three owners to move funds; owners and threshold are fixed at deployment. An owner whose account takes real code stops counting (an EIP-7702 delegation still counts), so once two of the three have real code the wallet cannot move anything.

## Evidence

- [_validSignature](https://etherscan.io/address/0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f#code) recovers each signature with ecrecover and accepts only distinct owners, at least two of them.
- [A real spend](https://etherscan.io/tx/0x7f54027484285f2197ddad97349f2de9495eeb7938e0e759653f530968520741) on a copy of this code reverts when its signer has real code, and passes with a delegation.
- [The wallet](https://etherscan.io/address/0xb7edb5d79c1cde621f0ad0bdd01cfe85e017d60f#readContract) holds 466,463.99 USDT and has three owners, none with code at the block.

## Reviewer notes

### Mechanism

spend (lines 105-114) calls _validSignature (118-131): it requires at least `required` signatures (2 at the block, getRequired), recovers each with ecrecover (line 127) and _distinctOwners (134-150) requires every recovered address to be a distinct isOwner entry. isOwner, owners and required are written only in the constructor (51-61); no other function writes them, and spend refuses itself as destination (line 106), so not even a signed call can change them. No function acts on msg.sender, so there is no direct path. There is no ERC-1271 or code-size branch. Under EIP-8151 ecrecover returns nothing for an owner with real code, so _distinctOwners fails; with three owners and two required, two owners with real code lock the wallet for good. An EIP-7702 delegation still recovers (replay run eip8151_signer_delegated). The replayed tx is a direct spend on copy 0x3242012283fcc75f9fac1ff8f8c042f07c940e2c (same code hash); it passes under EIP-8151 alone and reverts with real code at the signer. At the block this address holds 466,463.99 USDT and 0 ETH, its spend nonce is 1, and its three owners have no code and nonce 0.

### Checks

- Header facts: this address alone, at block 26,438,999; 138 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for owners with code: _validSignature and _distinctOwners have none (lines 118-150).
- Ruled out: a function that replaces owners or the threshold: only the constructor writes isOwner, owners and required (lines 51-61); selectors addOwner, removeOwner, replaceOwner and changeRequirement are absent from the runtime code.
- Ruled out: a signed self-call to change owners: spend rejects destination == address(this) (line 106).
- Ruled out: breaks under the change alone: the real spend replayed under EIP-8151 with no migration succeeds (gas 109,074 vs 102,874).
- Ruled out: owners already contracts: all three owners have empty code at block 26,438,999.
- Ruled out: that this card speaks for every copy: the 137 other addresses running this code have their own owners and thresholds, e.g. 0x527d87a0502cf6bc60be5db7158e0e51bfb86c56 is 2-of-2 and 0x070f50ab6a7115187593e3e363d23e8d6f75a8ca is 3-of-3 (one owner with real code locks them); each copy in use is its own row.
- Ruled out: a fixed gas amount for ecrecover: the Solidity builtin forwards all gas (line 127), and the real spend passes under EIP-8151 with nobody migrating.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
