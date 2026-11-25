---
id: gnosissafe-c61b9bb3-owner-ecdsa-keys
format: 2
title: Safe wallet can be emptied by anyone who forges three of its five owner keys
status: confirmed
severity: MEDIUM
justification: Three forged owner keys move everything; three owners must act to swap in post-quantum signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code
  proxy_of: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 122825151
  basis: held
activity: {}
impact: funds-loss
action: Swap each ECDSA owner for a post-quantum owner contract with legacy isValidSignature(bytes,bytes), or first
  upgrade the Safe to 1.5.0.
evidence_level: source
checks:
- id: ecdsa
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 906
  - 912
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: owner signatures other than contract and approved-hash slots are recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: owner-check
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 913
  - 917
  has: currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS
  says: each recovered address must be a distinct owner
  for:
  - evidence-1
  - justification
  - what
- id: exec
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 800
  - 807
  has: checkSignatures(txHash, txHashData, signatures, true);
  says: execTransaction checks the owner signatures and then executes the transaction
  for:
  - what
- id: erc1271
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 895
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: an owner signing with v=0 is asked through ERC-1271 with a signature of any length
  for:
  - action
  - evidence-2
  - justification
- id: swap
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 392
  - 410
  has: owners[newOwner] = owners[oldOwner];
  says: swapOwner replaces an owner, and is authorized
  for:
  - action
  - evidence-2
  - justification
- id: self-only
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 6
  - 9
  has: require(msg.sender == address(this), "Method can only be called from this contract");
  says: authorized functions run only when the Safe calls itself, that is through a Safe transaction
  for:
  - action
  - evidence-2
  - upgradeable
- id: mastercopy
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 27
  - 34
  has: masterCopy = _masterCopy;
  says: changeMasterCopy, authorized, replaces the singleton the proxy runs
  for:
  - action
  - upgradeable
- id: singleton
  storage: '0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c'
  slot: '0x0'
  is: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  says: the proxy runs the Safe 1.1.1 singleton
  for:
  - upgradeable
- id: threshold
  call: '0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals are needed
  for:
  - evidence-1
  - justification
  - what
- id: owners
  call: '0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c'
  fn: getOwners()(address[])
  is:
  - '0x61D5a4d5Bd270e59E9320243e574288e2a199fED'
  - '0xEb1Ff14852661aA18e61A47a6b0f382ADC8A02d2'
  - '0x37e3cE6b3dE70b95afB3D2de645E0d755d007c96'
  - '0x3C1138B7aD4bD293fAf933626f196FCAc98D7D5d'
  - '0x23d9c69eF0e20F783B81781517E75420eaeF5A99'
  says: the Safe has five owners
  for:
  - evidence-1
  - justification
  - what
- id: modules
  call: '0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c'
  fn: getModules()(address[])
  is: []
  says: no module is enabled
  for:
  - notes
- id: o1
  code: '0x61d5a4d5bd270e59e9320243e574288e2a199fed'
  is: empty
  says: owner 1 has no code
  for:
  - evidence-1
  - what
- id: o2
  code: '0xeb1ff14852661aa18e61a47a6b0f382adc8a02d2'
  is: empty
  says: owner 2 has no code
  for:
  - evidence-1
  - what
- id: o3
  code: '0x37e3ce6b3de70b95afb3d2de645e0d755d007c96'
  is: empty
  says: owner 3 has no code
  for:
  - evidence-1
  - what
- id: o4
  code: '0x3c1138b7ad4bd293faf933626f196fcac98d7d5d'
  is: empty
  says: owner 4 has no code
  for:
  - evidence-1
  - what
- id: o5
  code: '0x23d9c69ef0e20f783b81781517e75420eaef5a99'
  is: empty
  says: owner 5 has no code
  for:
  - evidence-1
  - what
- id: safe-nonce
  call: '0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c'
  fn: nonce()(uint256)
  is: 48
  says: the Safe has executed 48 transactions
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c'
  is: '68063760702337886530139'
  says: the Safe holds about 68,064 ETH
  for:
  - evidence-3
- id: leo
  call: '0x2af5d2ad76741191d15dfe7bf6ac92d4bd912ca3'
  fn: balanceOf(address)(uint256)
  args:
  - '0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c'
  is: '648000000000000000000000000'
  says: the Safe holds 648 million tokens of this contract (18 decimals)
  for:
  - evidence-3
- id: leo-symbol
  call: '0x2af5d2ad76741191d15dfe7bf6ac92d4bd912ca3'
  fn: symbol()(string)
  is: LEO
  says: the token's symbol is LEO
  for:
  - evidence-3
- id: leo-decimals
  call: '0x2af5d2ad76741191d15dfe7bf6ac92d4bd912ca3'
  fn: decimals()(uint8)
  is: 18
  says: the token has 18 decimals
  for:
  - evidence-3
- id: leo-supply
  call: '0x2af5d2ad76741191d15dfe7bf6ac92d4bd912ca3'
  fn: totalSupply()(uint256)
  is: '660000000000000000000000000'
  says: the Safe's 648M LEO is about 98% of LEO's 660M total supply
  for:
  - notes
- id: magic-in-code
  selector: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's runtime code has the pre-final isValidSignature(bytes,bytes) selector, 0x20c13b0b
  for:
  - action
  - evidence-2
- id: std-absent
  selector: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the singleton's runtime code lacks the final isValidSignature(bytes32,bytes) selector, 0x1626ba7e
  for:
  - action
  - evidence-2
- id: v150
  call: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  fn: VERSION()(string)
  is: 1.5.0
  says: a deployed Safe singleton at this address answers VERSION 1.5.0
  for:
  - action
- id: v150-std
  selector: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  fn: isValidSignature(bytes32,bytes)
  says: the Safe 1.5.0 singleton's runtime code has the final isValidSignature(bytes32,bytes) selector, 0x1626ba7e
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (source of 1.3.0 read, two real transactions replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-12
reviews:
- who: r-c61b9bb3, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): Safe wallet can be emptied by anyone who forges three
    of its five owner keys. Three forged owner keys move everything; three owners must act to swap in post-quantum
    signer contracts. Fix: Swap each ECDSA owner for a post-quantum owner contract with legacy isValidSignature(bytes,bytes),
    or first upgrade the Safe to 1.5.0. One refuter agrees on the current card with no objection (D-029: a second
    refuter only for removals); Claude read the card and the answer.'
related: []
---

## What happens

This Safe wallet runs any transaction, including moving all it holds, once three of its five owners approve it. All five owners are accounts without code whose ECDSA signatures count as approvals, so whoever derives three owner keys with a quantum computer can empty it.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) recovers each owner signature with ecrecover and needs three; none of the five owners holds code.
- [swapOwner](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) replaces an owner; the owner contract must answer legacy isValidSignature(bytes,bytes).
- The [Safe](https://etherscan.io/address/0xc61b9bb3a7a0767e3179713f3a5c7a9aedce193c) holds about 68,064 ETH and 648 million LEO tokens.

## Reviewer notes

### Mechanism

SafeProxy delegates to the Safe 1.1.1 singleton 0x34cf...3f5f (slot 0; VERSION 1.1.1). execTransaction (lines 774-817) hashes the transaction with the Safe nonce, calls checkSignatures (line 800) and then executes any call or delegatecall (line 807). checkSignatures (849-918) reads threshold-many 65-byte slots; v=0 asks the owner contract isValidSignature(data, contractSignature) with a signature of any length (line 895, magic 0x20c13b0b, the pre-final draft, not the final 0x1626ba7e); v=1 accepts an owner that is msg.sender or pre-approved the hash with approveHash; v>30 and the default recover with ecrecover (908, 911). Each address must be an owner, in ascending order (914). Threshold is 3, owners are five accounts with empty code and no EIP-7702 delegation, no module is enabled. Owners, threshold and singleton change only through calls from the Safe itself (authorized, line 7): swapOwner (392), addOwnerWithThreshold, removeOwner, changeThreshold, changeMasterCopy (27). So a holder of three owner keys can move everything; the owners can remove the ECDSA path by swapping their EOAs for contract owners that verify post-quantum signatures, which needs three of them to act (MEDIUM: fix by owners migrating, several parties acting).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 for owners with code: the v=0 path exists (line 895) but is the pre-final isValidSignature(bytes,bytes)/0x20c13b0b, not final isValidSignature(bytes32,bytes)/0x1626ba7e (absent from its code); all five owners have empty code today so ecrecover satisfies them, but a new owner contract built to the modern selector would be rejected here.
- Ruled out: Module bypass: getModules() returns an empty list at the block, so no module can execute without owner signatures.
- Ruled out: Unused implementation: the address is a proxy in use, Safe nonce 48, five owners and threshold 3 set, and holds ETH.
- Ruled out: Replay in the dossier: tx 0xa6434e8b... runs on another Safe of the same code (signer 0x07d9...), not this address; not cited. It fails under the plain eip8151 run too, which may point to a sender-gas-limit notice on that Safe, not here.
- Ruled out: Value: the tool's value counts ETH and two priced tokens; LEO is not priced by the tool. The LEO contract is identified only by its symbol() answer. Whose is not established: 648M LEO is 98% of LEO's total supply, suggesting an issuer or exchange reserve, but no check here shows who controls it, so whose stays null rather than guessed.
- Ruled out: Admin: owners, threshold and singleton change only through the Safe's own transactions (authorized, line 7), so the admin is the Safe itself behind its three-of-five owners; left to the tool's reading.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
