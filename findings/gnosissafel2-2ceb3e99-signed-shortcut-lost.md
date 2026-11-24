---
id: gnosissafel2-2ceb3e99-signed-shortcut-lost
format: 2
title: Safe owners' ECDSA signatures stop counting once their accounts take real code
status: confirmed
severity: INFORMATIONAL
justification: An owner with real code loses only its ECDSA signature; it can still approve on-chain, and the owners
  can swap it out.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2ceb3e994a516c6ba8658211bc94d4c280486cb7'
  name: GnosisSafeL2
  code: verified
  code_url: https://etherscan.io/address/0x3e5c63644e683549055b9be8653de26e0b4cd36e#code
  proxy_of: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  copies: 8589
  family: 922d81504c51927118b2dda3d8ce64ee
value:
  usd: 7468573
  basis: held
activity: {}
impact: liveness
action: Swap an owner out with swapOwner, or have it approve on-chain instead, before that owner's account moves
  to real code.
evidence_level: source
checks:
- id: ecdsa
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: the default branch recovers the owner from an ECDSA signature
  for:
  - evidence-1
  - justification
  - what
- id: ethsign
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: the eth_sign branch also recovers with ecrecover
  for:
  - what
- id: ownercheck
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/GnosisSafe.sol
  line: 301
  has: owners[currentOwner] != address(0)
  says: each signer must be a stored owner
  for:
  - evidence-1
  - justification
  - what
- id: erc1271
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/GnosisSafe.sol
  line: 285
  has: isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: a v=0 entry asks the owner through ERC-1271
  for:
  - evidence-1
  - what
- id: approved
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/GnosisSafe.sol
  line: 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: a v=1 entry counts an owner that sends the transaction or approved the hash on-chain
  for:
  - action
  - evidence-1
  - what
- id: swap
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/base/OwnerManager.sol
  line: 94
  has: function swapOwner(
  says: swapOwner exists
  for:
  - action
  - evidence-2
  - justification
- id: swapauth
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/base/OwnerManager.sol
  line: 98
  has: ) public authorized {
  says: swapOwner is callable only by the Safe itself
  for:
  - action
  - evidence-2
  - justification
- id: selfauth
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized means a call from the Safe itself, i.e. an executed Safe transaction
  for:
  - notes
- id: swapwrite
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/base/OwnerManager.sol
  lines:
  - 106
  - 108
  has: owners[prevOwner] = newOwner;
  says: swapOwner puts the new owner in the old one's place and removes the old one
  for:
  - action
  - evidence-2
- id: threshold
  call: '0x2ceb3e994a516c6ba8658211bc94d4c280486cb7'
  fn: getThreshold()(uint256)
  is: 4
  says: four owner approvals are needed
  for:
  - evidence-2
  - what
- id: owners
  call: '0x2ceb3e994a516c6ba8658211bc94d4c280486cb7'
  fn: getOwners()(address[])
  is:
  - '0xe7054A9B58fB409809479E5cC33e96C55BD96fa1'
  - '0xBf75592c5004F5922411109aDF3b313c4a120fe0'
  - '0xD09C6d90bE621ca54Ec4a067c78B107D4f6DBc41'
  - '0xdFA3C79505290E6717Ae488D764a593505B0770A'
  - '0xba5932C1AEcE79Da0189092342F259e8eCacbd65'
  says: the Safe has five owners
  for:
  - evidence-2
  - what
- id: o1
  code: '0xe7054a9b58fb409809479e5cc33e96c55bd96fa1'
  is: empty
  says: owner 1 has no code
  for:
  - notes
- id: o2
  code: '0xbf75592c5004f5922411109adf3b313c4a120fe0'
  is: empty
  says: owner 2 has no code
  for:
  - notes
- id: o3
  code: '0xd09c6d90be621ca54ec4a067c78b107d4f6dbc41'
  is: empty
  says: owner 3 has no code
  for:
  - notes
- id: o4
  code: '0xdfa3c79505290e6717ae488d764a593505b0770a'
  is: empty
  says: owner 4 has no code
  for:
  - notes
- id: o5
  code: '0xba5932c1aece79da0189092342f259e8ecacbd65'
  is: empty
  says: owner 5 has no code
  for:
  - notes
- id: guard
  storage: '0x2ceb3e994a516c6ba8658211bc94d4c280486cb7'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: no transaction guard is set
  for:
  - notes
- id: nomodule
  call: '0x2ceb3e994a516c6ba8658211bc94d4c280486cb7'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled, so no path skips owner signatures
  for:
  - notes
- id: legacy-bytes
  bytecode: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  has: '0x20c13b0b'
  says: the 1.3.0 L2 singleton's code holds the legacy isValidSignature magic value 0x20c13b0b
  for:
  - what
- id: no-final
  bytecode: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  has: '0x1626ba7e'
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is absent from the singleton
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-2ceb3e99, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'moved: Moved to signed-shortcut-lost, INFORMATIONAL (PQ-19), by Claude for consistency with 0xf4ac5a5d:
    a 4-of-5 GnosisSafeL2 1.3.0 owner whose account takes real code loses only its off-chain ECDSA signature and
    still approves on-chain (approveHash or sending the transaction), or through the legacy isValidSignature(bytes,bytes);
    swapOwner replaces it. Fresh refuter agrees (its only note: evidence-1 could say ''legacy''). Claude read the
    sheet.'
related: []
---

## What happens

This Safe runs a transaction when four of its five owners approve it, by ECDSA signature, by on-chain approval or through the legacy isValidSignature(bytes,bytes). An owner whose account takes real code no longer counts by ECDSA signature; an EIP-7702 delegation keeps working.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x3e5c63644e683549055b9be8653de26e0b4cd36e#code) recovers ECDSA signatures and counts only stored owners; it also takes on-chain approvals and ERC-1271.
- [swapOwner](https://etherscan.io/address/0x3e5c63644e683549055b9be8653de26e0b4cd36e#code) replaces an owner through a transaction the Safe itself runs, which needs 4 of its 5 owners.

## Reviewer notes

### Mechanism

execTransaction (GnosisSafeL2 -> GnosisSafe.execTransaction) hashes the transaction and calls checkSignatures, which needs threshold (4 at the block) entries. checkNSignatures takes each 65-byte entry: v=0 calls isValidSignature (ERC-1271) on the owner in r; v=1 accepts the owner in r if it is msg.sender or has called approveHash; v>30 recovers an eth_sign signature with ecrecover; otherwise ecrecover on the hash. The result must be a stored owner (owners[...] != 0) in ascending order. Under EIP-8151 the two ecrecover branches return nothing for an owner whose account has real code, so that owner's off-chain ECDSA signature fails with GS026; the owner can still count by calling approveHash or execTransaction from its account, or through ERC-1271 if its new code implements it. swapOwner/removeOwner/addOwnerWithThreshold are `authorized` (msg.sender == the Safe), i.e. reached through execTransaction with the current threshold. At block 26,438,999: owners are 5 EOAs with no code (four with nonce 0, one with nonce 20), threshold 4, nonce 13, no modules enabled, no guard set.

### Checks

- Header facts: this address alone, at block 26,438,999; 8,589 addresses run this code.
- Ruled out: an automatic ERC-1271 fallback for owners with code: the ECDSA branches (lines 292-300) do not check code size; the owner must send a different signature type (v=0 or v=1), so its ECDSA signature itself stops counting.
- Ruled out: a module path that skips signatures: getModulesPaginated at the block returns no module, and the guard slot is empty.
- Ruled out: already-affected owners: all five owners have no code at the block.
- Ruled out: funds-locked impact: an owner with real code keeps the on-chain approval path (approveHash or calling execTransaction itself, line 291), so the loss is the off-chain signing flow, not the funds; locked only if its new code can neither make calls nor answer ERC-1271.
- Ruled out: replay 0xbef15df1b3cc83bbb029e48432a7887ab6c1a953afb3385dab1dd55d397a1a06 fails under EIP-8151 alone, but it calls another copy (0x66264e76316b2122738998e325533a9a7d1b1e82) with a 94,345 gas limit for 93,392 used: a sender-gas-limits lead for that copy, not this address.
- Ruled out: replay 0x336afbe173f678ac218f1167ab1580433e73b576ea8c5e7302249eeb1397b2eb (signer-code run reverts) calls 0x4444aaaacdba5580282365e25b16309bd770ce4a, which runs other code (0xfb1bffc9...), so it is not cited; evidence stays source.
- Ruled out: other copies of this code: the card covers this address's own owners and state only.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
