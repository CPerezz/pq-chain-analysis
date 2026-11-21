---
id: contract-a5fef013-rotate-signer-before-migrating
format: 2
title: Multisig owners must be replaced before moving their accounts to real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if owners move to real code; the two others can still sign a replacement owner change.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  code: bytecode
  code_url: https://etherscan.io/address/0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8#code
  copies: 19
  family: d233af790d818cb4afc55cb73bd6576a
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Replace an owner key through a signed owner change before that owner moves its account to real code.
evidence_level: bytecode
checks:
- id: ecrec
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 600186828585604051600081526020016040526040516105029493929190610c19565b6020604051602081039080840390855afa
  says: each signature goes to the ecrecover precompile (address 1) by STATICCALL with all remaining gas
  for:
  - evidence-1
  - what
- id: scratch
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: '60405160008152602001604052'
  says: the output word is zeroed before the call, so an empty answer reads as the zero address
  for:
  - what
- id: isowner
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 6001600160a01b03811660009081526002602052604090205490915060ff1661032b57
  says: the recovered address must be marked as owner in the mapping at slot 2, else revert
  for:
  - evidence-1
  - what
- id: ascend
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 836001600160a01b0316816001600160a01b03161161035c57
  says: each recovered owner must be above the previous one (ascending order, no repeats)
  for:
  - evidence-1
- id: thresh
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 600354815110156102ad57
  says: the number of signatures must be at least the threshold stored at slot 3
  for:
  - evidence-1
  - justification
  - what
- id: execverify
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 6000805460010181556040516001600160a01b038716908690610219908790610b53565b60006040518083038185875af1
  says: execute increments the nonce and makes the signed CALL
  for:
  - what
- id: execsel
  selector: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  fn: execute(address,uint256,bytes,bytes[])
  says: the wallet has execute(address,uint256,bytes,bytes[])
  for:
  - what
- id: rotate
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 0184818361028a565b60008054600101905561019684610366565b50506003555056
  says: the owner-change function checks the signatures, increments the nonce, rewrites the owners and stores the
    new threshold at slot 3
  for:
  - action
  - evidence-2
  - justification
  - what
- id: rotatesel
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 631113c9a014610090
  says: the dispatcher routes selector 0x1113c9a0 to the owner-change function
  for:
  - action
- id: setowners
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 6001600260008684815181106103d957fe5b6020908102919091018101516001600160a01b03168252810191909152604001600020805460ff1916911515919091179055
  says: the owner rewrite marks each new owner in the mapping at slot 2
  for:
  - action
  - evidence-2
  - justification
- id: emptyrev
  call: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  data: '0x9beabdea00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011b00000000000000000000000000000000000000000000000000000000000000'
  reverts_with: Invalid signature
  says: execute with two empty-recovery signatures (r=0) reverts Invalid signature, as a real-code owner's signature
    does under EIP-8151.
  for:
  - evidence-3
  - what
- id: nowners
  storage: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  slot: '0x1'
  is: '0x3'
  says: the owner list has three entries
  for:
  - justification
  - what
- id: threshold
  call: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  fn: threshold()(uint256)
  is: 2
  says: two signatures are needed
  for:
  - justification
  - what
- id: nonce
  call: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  fn: nonce()(uint256)
  is: 0
  says: this wallet has never executed a signed operation
  for:
  - what
- id: ethbal
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  is: 0
  says: the wallet holds no ETH
  for:
  - what
- id: nonpay
  bytecode: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  has: 608060405234801561001057600080fd5b50
  says: any call carrying ETH reverts before the function dispatch, so the wallet cannot receive ETH by a call
  for:
  - what
- id: zeroowner
  call: '0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8'
  fn: isOwner(address)(bool)
  args:
  - '0x0000000000000000000000000000000000000000'
  is: false
  says: the zero address is not an owner, so a failed recovery never counts
  for:
  - what
- id: code0
  code: '0x1d6a7efd6ebbb36ad78069c3c40bcce1b7d422d3'
  is: empty
  says: owner 1 has no code
  for:
  - evidence-2
  - justification
- id: code1
  code: '0xe7bb039f01cbaeb8cb790864d12e408b22980d74'
  is: empty
  says: owner 2 has no code
  for:
  - evidence-2
  - justification
- id: code2
  code: '0x19667f023f5d0e7b991326fe17e1e7777e47b755'
  is: empty
  says: owner 3 has no code
  for:
  - evidence-2
  - justification
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

This multisig wallet makes a call or changes its owners when at least two of its three owners sign with ECDSA. A signature from an owner whose account takes real code reverts the whole call; an EIP-7702 delegation keeps working. The wallet has never run a signed operation and holds no ETH.

## Evidence

- The [wallet code](https://etherscan.io/address/0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8#code) recovers each signature with ecrecover and needs at least the threshold of owners, in ascending order.
- A [signed owner change](https://etherscan.io/address/0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8#code) rewrites the owner list and threshold; the three owners today are accounts without code.
- Given a signature for which ecrecover returns nothing, the [wallet](https://etherscan.io/address/0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8#code) reverts with Invalid signature.

## Reviewer notes

### Mechanism

Unverified, from the disassembly. Selectors: owners(uint256), isOwner(address), threshold(), nonce(), execute(address,uint256,bytes,bytes[]) (0x9beabdea), owner change 0x1113c9a0(address[],uint256,bytes[]). Both hash 0x19, the wallet address, their arguments and the nonce, then at 0x28a require signatures >= threshold (slot 3, 'Threshold not met'); the hash is an Ethereum signed message; each 65-byte signature goes to precompile 1 by STATICCALL with all gas, output pre-zeroed; the recovered address must be marked isOwner (slot 2, else 'Invalid signature') and above the previous one. A call with two signatures for which the precompile returns nothing (r=0) reverts 'Invalid signature': the same empty output EIP-8151 gives for a signer with real code, so the others must sign without it. No CALLER/ORIGIN opcode, no other call in the check: no ERC-1271 path, no direct path. execute increments the nonce and CALLs the target. The owner change checks signatures, increments the nonce, clears isOwner for the old list, sets it for the new, rewrites the array (slot 1) and the threshold. Here 2 of 3: one owner migrating unprepared leaves two who can replace it; two migrating stop the wallet. Not payable (CALLVALUE reverts before dispatch) and holds no ETH; nonce 0, never used; owners are EOAs (never sent, presumed live).

### Checks

- Header facts: this address alone, at block 26,438,999; 19 addresses run this code.
- Ruled out: wallets-fixed-signers (the row's root issue): the owner change 0x1113c9a0 rewrites isOwner, the owner array and the threshold, so the set is replaceable by the owners' signatures.
- Ruled out: the earlier removal as not affected: a replaceable owner set is still a migration notice; this wallet is configured (three owners, threshold 2), not a proxy implementation.
- Ruled out: an ERC-1271 or code-size path: the only STATICCALL in the runtime goes to address 1, with no other call in the check.
- Ruled out: a direct path without signatures: the code has no CALLER or ORIGIN opcode; both state-changing functions go through the signature check.
- Ruled out: key state: the three owners have no code and isOwner is true for each; isOwner(0) is false.
- Ruled out: a fixed gas budget or a break with nobody migrating: the precompile gets all remaining gas; no calls in the 90-day window and no replays exist.
- Ruled out: signature rechecked later: each signature is used once and the nonce increments.
- Ruled out: the other 18 copies are their own rows: 0x1241b6077e9ea082033ebd1e7fc6f149854a380b is 3 of 3, where a migrating owner must sign the change itself; 0x2c6e3a34d5d6bf6c8109590eb1562c6000131a9d has run 20 signed operations.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
