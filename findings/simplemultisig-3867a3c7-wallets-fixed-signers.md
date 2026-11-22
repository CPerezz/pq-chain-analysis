---
id: simplemultisig-3867a3c7-wallets-fixed-signers
format: 2
title: Wallet locks if two of its three fixed owners move to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless two owners move their accounts to real code; the owners can move the funds
  out first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  name: SimpleMultiSig
  code: verified
  code_url: https://etherscan.io/address/0x3867a3c7d53547eae0a20050957ec37064bce15f#code
  copies: 3210
  family: 2cce101b86c685e0f1546bfb2464bda7
  upgradeable: 'no'
value:
  usd: 67
  basis: held
activity: {}
impact: funds-locked
action: Move the funds to a new wallet with execute before any owner moves its account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  file: SimpleMultiSig.sol
  lines:
  - 34
  - 35
  has: require(recovered > lastAdd && isOwner[recovered]);
  says: each signature is recovered with ecrecover and the recovered address must be a stored owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: len-check
  source: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  file: SimpleMultiSig.sol
  line: 26
  has: require(sigR.length == threshold);
  says: execute requires exactly threshold signatures
  for:
  - what
- id: call-out
  source: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  file: SimpleMultiSig.sol
  line: 41
  has: require(destination.call.value(value)(data));
  says: after the signatures pass, execute sends the value and data to the destination the owners signed
  for:
  - action
  - justification
- id: set-once
  source: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  file: SimpleMultiSig.sol
  lines:
  - 11
  - 22
  has: isOwner[owners_[i]] = true;
  says: the constructor is where the owners and the threshold are written
  for:
  - action
  - evidence-1
  - what
- id: immutable-note
  source: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  file: SimpleMultiSig.sol
  lines:
  - 6
  - 9
  has: mapping (address => bool) isOwner; // immutable state
  says: the source declares the nonce as the only mutable state; owners and threshold are not written after deployment
  for:
  - what
- id: sel-exec
  selector: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  fn: execute(uint8[],bytes32[],bytes32[],address,uint256,bytes)
  says: the code that runs at the address has the execute function of this source
  for:
  - what
- id: threshold
  call: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  fn: threshold()(uint256)
  is: 2
  says: two signatures are required
  for:
  - evidence-2
  - justification
  - what
- id: n-owners
  storage: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  slot: 3
  is: 3
  says: the owner list has three entries
  for:
  - evidence-2
  - justification
  - what
- id: o0
  call: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  fn: ownersArr(uint256)(address)
  args:
  - 0
  is: '0x068ba566161c8d760020bd9e9c2f96de113bef04'
  says: the first owner
  for:
  - evidence-2
- id: o1
  call: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  fn: ownersArr(uint256)(address)
  args:
  - 1
  is: '0xa9d10cbc0690a0b45c2bbe2df233ee7e4a852f38'
  says: the second owner
  for:
  - evidence-2
- id: o2
  call: '0x3867a3c7d53547eae0a20050957ec37064bce15f'
  fn: ownersArr(uint256)(address)
  args:
  - 2
  is: '0xd6243f1013ed1b8fdcbbc9546c3120af4f15916f'
  says: the third owner
  for:
  - evidence-2
- id: o0-code
  code: '0x068ba566161c8d760020bd9e9c2f96de113bef04'
  is: empty
  says: the first owner has no code
  for:
  - evidence-2
- id: o1-code
  code: '0xa9d10cbc0690a0b45c2bbe2df233ee7e4a852f38'
  is: empty
  says: the second owner has no code
  for:
  - evidence-2
- id: o2-code
  code: '0xd6243f1013ed1b8fdcbbc9546c3120af4f15916f'
  is: empty
  says: the third owner has no code
  for:
  - evidence-2
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

This wallet sends a payment when two of its three owners sign it with ECDSA. The owners are set at deployment and no function replaces them. If two owners move their accounts to real code, their signatures stop counting and the funds stay locked.

## Evidence

- [execute](https://etherscan.io/address/0x3867a3c7d53547eae0a20050957ec37064bce15f#code) recovers each signature with ecrecover and requires an owner; the owners are written in the constructor.
- The [wallet](https://etherscan.io/address/0x3867a3c7d53547eae0a20050957ec37064bce15f) needs 2 signatures of 3 owners, and none of the three owner accounts has real code.

## Reviewer notes

### Mechanism

SimpleMultiSig.sol, 45 lines, Solidity 0.4. The constructor (lines 11-22) writes isOwner and ownersArr and the threshold; nothing else writes them. execute (lines 25-42) is the one function that moves anything: it requires exactly `threshold` signatures (line 26), recovers each with ecrecover over an ERC-191 hash that includes the wallet and its nonce (lines 30, 34), requires each recovered address to be an owner and above the previous one (line 35), adds one to the nonce and calls the destination with the value and data (lines 40-41). The other entries are the getters nonce, threshold, ownersArr and a payable fallback. At the block: threshold 2, three owners, nonce 1 (one payment made), 0.0369 ETH held. The three owners have no code and account nonce 0. One owner moving to code leaves the other two able to sign; two moving leaves fewer than two valid signers, and no path replaces an owner or moves the ETH. The row stands for 3,210 addresses with the same code; owners, thresholds and balances of the copies are their own and were not read.

### Checks

- Header facts: this address alone, at block 26,438,999; 3,210 addresses run this code.
- Ruled out: an ERC-1271 or code-size branch for owners with code: execute has only ecrecover and the isOwner test (lines 33-37).
- Ruled out: a function that replaces owners or the threshold: the runtime has four selectors (threshold, ownersArr, nonce, execute), one SSTORE (slot 0, the nonce), no DELEGATECALL, CALLCODE or SELFDESTRUCT; execute's outside call cannot write this wallet's storage.
- Ruled out: a direct call by an owner without signatures: execute never reads msg.sender; line 26 requires threshold signatures.
- Ruled out: a fixed gas amount for the precompile: both CALL opcodes in the runtime take GAS, not a constant, so the higher price alone does not break it.
- Ruled out: unset or contract owners: ownersArr(0..2) are set, index 3 reverts, each owner has empty code at the block.
- Ruled out: an unused template: this address has its own owners, nonce 1 and 0.0369 ETH; it is not a proxy.
- Ruled out: a signature relied on by others and checked again later: the signature is checked once, in the call that pays.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
