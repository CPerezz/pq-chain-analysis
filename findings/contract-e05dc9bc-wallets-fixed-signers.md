---
id: contract-e05dc9bc-wallets-fixed-signers
format: 2
title: Multisig wallet cannot replace a signer whose account takes real code
status: candidate
severity: INFORMATIONAL
justification: Nothing breaks unless signers move their accounts to real code; the signers are fixed, so the funds
  have to move first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe05dc9bc8ec0705328046e3756141261b8f574e2'
  code: decompiled
  code_url: code/0xe44bd85d9fe9c92f051c7698c1a512682e8e49a02a92d18a5f2f2aeea57c72e6.sol
  proxy_of: '0xe5176064c995adad5ac00e2a592260c434861717'
  copies: 31
  family: 9733b8d82b4a3d2c786481ea9cc25594
  upgradeable: 'no'
value:
  usd: 461
  basis: held
activity: {}
impact: funds-locked
action: Move the funds to a wallet with replaceable signers before any signer moves their account to real code.
evidence_level: bytecode
checks:
- id: clone
  code: '0xe05dc9bc8ec0705328046e3756141261b8f574e2'
  is: contract
  bytes: 45
  says: the address is a 45-byte clone
  for:
  - notes
- id: clonetarget
  bytecode: '0xe05dc9bc8ec0705328046e3756141261b8f574e2'
  has: 363d3d373d3d3d363d73e5176064c995adad5ac00e2a592260c4348617175af4
  says: the clone delegates every call to 0xe5176064
  for:
  - notes
- id: recover
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: 6020604051602081039080840390855afa15
  says: the signature is recovered by a STATICCALL that passes all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: caller
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: 4e6f6e2d7369676e657220696e206f6e6c795369676e6572206d6574686f64
  says: the send functions revert with 'Non-signer in onlySigner method' unless the caller is a signer
  for:
  - evidence-1
  - evidence-3
  - what
- id: noteq
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: 5369676e6572732063616e6e6f7420626520657175616c
  says: the recovered signer must differ from the caller ('Signers cannot be equal')
  for:
  - evidence-1
  - evidence-3
  - what
- id: no1271
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: 1626ba7e
  absent: true
  says: the code never asks a signer with real code through ERC-1271
  for:
  - evidence-1
  - what
- id: fivesigners
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: 600582829050146109ff57
  says: init requires the signer list to hold exactly five entries
  for:
  - evidence-2
  - justification
  - what
- id: initonce
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: 436f6e747261637420616c726561647920696e697469616c697a6564
  says: init reverts with 'Contract already initialized' once it has run
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signerwrite
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: 5260200190815260200160002060006101000a81548160ff0219169083151502179055
  says: the only write to the signers mapping, inside the init loop
  for:
  - action
  - evidence-2
  - justification
  - what
- id: initialized
  call: '0xe05dc9bc8ec0705328046e3756141261b8f574e2'
  fn: initialized()(bool)
  is: true
  says: this clone has run init, so its signer set is fixed
  for:
  - evidence-2
  - what
- id: safemode
  call: '0xe05dc9bc8ec0705328046e3756141261b8f574e2'
  fn: safeMode()(bool)
  is: false
  says: safe mode is off at the block
  for:
  - notes
- id: sendeth
  selector: '0xe5176064c995adad5ac00e2a592260c434861717'
  fn: sendMultiSig(address,uint256,bytes,uint256,bytes)
  says: the wallet has a send function for ether
  for:
  - action
  - evidence-3
  - what
- id: sendtoken
  selector: '0xe5176064c995adad5ac00e2a592260c434861717'
  fn: sendMultiSigToken(address,uint256,address,uint256,bytes)
  says: the wallet has a send function for tokens
  for:
  - action
  - evidence-3
  - what
- id: zeroout
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: '60405160008152602001604052'
  says: the ecrecover output word is zeroed before the call, so an empty return reads as address 0, which is not
    a signer
  for:
  - justification
  - what
- id: expiry
  bytecode: '0xe5176064c995adad5ac00e2a592260c434861717'
  has: 5472616e73616374696f6e2065787069726564
  says: sends revert with 'Transaction expired' after the signed deadline
  for:
  - what
- id: usdt-held
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0xe05dc9bc8ec0705328046e3756141261b8f574e2'
  is: 100000000
  says: this wallet holds 100 USDT
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

The wallet sends ETH or tokens when a signer calls it with another signer's unexpired signature. Its up to five signers are fixed at creation. A signer whose account takes real code cannot co-sign; an EIP-7702 delegation still can. If every signer does, its funds are locked.

## Evidence

- The [wallet code](https://etherscan.io/address/0xe5176064c995adad5ac00e2a592260c434861717#code) recovers the co-signer with ecrecover and accepts only a stored signer other than the caller.
- The [wallet code](https://etherscan.io/address/0xe5176064c995adad5ac00e2a592260c434861717#code) writes the signers once, in an init that takes five entries, and never again.
- This wallet holds 0.2 ETH and 100 USDT; it leaves only through sends that two of its signers approve ([wallet code](https://etherscan.io/address/0xe5176064c995adad5ac00e2a592260c434861717#code)).

## Reviewer notes

### Mechanism

The address is a 45-byte EIP-1167 clone of 0xe5176064 (unverified, a WalletSimple-like wallet). sendMultiSig and sendMultiSigToken require msg.sender to be a signer ('Non-signer in onlySigner method'), a 65-byte signature, an unexpired deadline ('Transaction expired') and, in safe mode, a signer as recipient ('External transfer in safe mode'). The signature is recovered by a STATICCALL to 0x01 passing all remaining gas, into a zeroed output word, and the recovered address must be in the signers mapping ('Invalid signer') and differ from msg.sender ('Signers cannot be equal'). The runtime has three SSTOREs: the signer write in the init loop, the initialized flag, and safeMode in activateSafeMode. init(address[]) takes exactly 5 non-zero entries once; it does not reject duplicates, so a wallet has up to five distinct signers. Under EIP-8151 a signer with real code no longer recovers (a 7702 delegation still does); msg.sender is not code-tested, so a signer with real code can still be the caller, and sends stop only when no signer still recovers. At block 26,438,999 this clone is initialized, safe mode is off, and it holds 0.2 ETH and 100 USDT; each of the 31 copies has its own signer set.

### Checks

- Header facts: this address alone, at block 26,438,999; 31 addresses run this code.
- Ruled out: an ERC-1271 path for a signer with code: the runtime holds no 0x1626ba7e selector and no EXTCODESIZE opcode; its only outgoing PUSH4 besides its own selectors is transfer (0xa9059cbb).
- Ruled out: a fixed-gas recovery: the STATICCALL to 0x01 is fed by GAS (all remaining gas), not a constant.
- Ruled out: a signer setter: only three SSTOREs exist (signer write inside init, initialized flag, safeMode flag); the dispatcher has nine selectors, none of them a setter.
- Ruled out: an unused or uninitialized address: initialized() returns true at this clone at the block, and it holds 0.2 ETH.
- Ruled out: a path closed for good: safeMode() is false at the block and nothing pauses the send functions.
- Ruled out: a send without a co-signer: the fallback only accepts deposits; both send functions require the recovered co-signer.

### Questions

- Who the signers of this clone and of its copies are, whether they are the wallet's owners or a custodian, and whether any already has real code: the signers mapping cannot be listed; it needs each clone's init transaction.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
