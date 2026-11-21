---
id: proxy-02479bfc-signed-shortcut-lost
format: 2
title: Owners whose accounts take real code lose ECDSA signing on this Safe
status: confirmed
severity: INFORMATIONAL
justification: An owner signature stops counting only once that owner moves to real code; it can still approve by
  call.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x02479bfc7dce53a02e26fe7baea45a0852cb0909'
  name: Proxy
  code: verified
  code_url: https://etherscan.io/address/0x6851d6fdfafd08c0295c392436245e5bc78b0185#code
  proxy_of: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  copies: 749
  family: f15632f51822929a9fbf0492ef338d70
  upgradeable: 'yes'
value:
  usd: 344271
  basis: held
activity: {}
impact: liveness
action: Swap out an owner key before its account takes real code, unless that code answers isValidSignature or can
  call approveHash.
evidence_level: source
checks:
- id: master
  storage: '0x02479bfc7dce53a02e26fe7baea45a0852cb0909'
  slot: '0x0'
  is: '0x0000000000000000000000006851d6fdfafd08c0295c392436245e5bc78b0185'
  says: slot 0 holds the master copy the proxy runs
  for:
  - proxy_of
- id: proxysrc
  source: '0x02479bfc7dce53a02e26fe7baea45a0852cb0909'
  file: Proxy.sol
  lines:
  - 29
  - 35
  has: delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
  says: the proxy delegate-calls the master copy read from slot 0
  for:
  - proxy_of
- id: ecdsa
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/GnosisSafe.sol
  lines:
  - 253
  - 256
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a plain owner signature is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: ethsign
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/GnosisSafe.sol
  lines:
  - 250
  - 252
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: an eth_sign owner signature is recovered with ecrecover
  for:
  - evidence-1
- id: ownercheck
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/GnosisSafe.sol
  lines:
  - 257
  - 260
  has: currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS
  says: the recovered or named address must be a current owner, in ascending order
  for:
  - evidence-1
  - what
- id: contractsig
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/GnosisSafe.sol
  lines:
  - 211
  - 239
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "Invalid contract signature provided");
  says: v=0 asks the owner contract named in r through isValidSignature, without any recovery
  for:
  - action
  - evidence-1
  - justification
  - what
- id: magic
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/interfaces/ISignatureValidator.sol
  lines:
  - 4
  - 5
  has: bytes4 constant internal EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the expected answer is that of the older isValidSignature(bytes,bytes)
  for:
  - action
  - evidence-1
- id: approved
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/GnosisSafe.sol
  lines:
  - 241
  - 245
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "Hash has not been approved");
  says: v=1 counts an owner that sends the call or approved the hash, without any recovery
  for:
  - action
  - evidence-2
  - justification
  - what
- id: approvehash
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/GnosisSafe.sol
  lines:
  - 294
  - 299
  has: require(owners[msg.sender] != address(0), "Only owners can approve a hash"); approvedHashes[msg.sender][hashToApprove]
    = 1;
  says: an owner approves a hash by its own call
  for:
  - action
  - evidence-2
  - justification
  - what
- id: swap
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/base/OwnerManager.sol
  lines:
  - 100
  - 113
  has: owners[newOwner] = owners[oldOwner]; owners[prevOwner] = newOwner; owners[oldOwner] = address(0);
  says: swapOwner replaces an owner, and is authorized
  for:
  - action
  - evidence-2
- id: selfauth
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "Method can only be called from this contract");
  says: authorized functions run only through a wallet transaction
  for:
  - evidence-2
  - upgradeable
- id: upgrade
  source: '0x6851d6fdfafd08c0295c392436245e5bc78b0185'
  file: contracts/common/MasterCopy.sol
  lines:
  - 18
  - 24
  has: masterCopy = _masterCopy;
  says: changeMasterCopy replaces the code the proxy runs, by a wallet transaction
  for:
  - upgradeable
- id: owners
  call: '0x02479bfc7dce53a02e26fe7baea45a0852cb0909'
  fn: getOwners()(address[])
  is:
  - '0x52560053b2669c8579c7514b15cee469969d8be2'
  - '0xa6e8772af29b29b9202a073f8e36f447689beef6'
  - '0x46a6f15b5a5cd0f1c93f87c4af0a0586fc9d07e8'
  - '0x7d7935edd4b6cdb5f34b0e1cceaf85a3c4a11254'
  - '0xe885814daf2c5a9f6ade1ca08ecae793469e470e'
  - '0x93bc131e07c6a373601490b7cb50ec4237d99df1'
  - '0xbfc85ba39fe772c75efea0eb90a850f09a581cb6'
  says: the wallet has seven owners
  for:
  - evidence-3
  - what
- id: threshold
  call: '0x02479bfc7dce53a02e26fe7baea45a0852cb0909'
  fn: getThreshold()(uint256)
  is: 3
  says: three owners must approve
  for:
  - evidence-3
  - what
- id: modules
  call: '0x02479bfc7dce53a02e26fe7baea45a0852cb0909'
  fn: getModules()(address[])
  is: []
  says: no module can execute without owner approvals
  for:
  - evidence-3
- id: nested
  code: '0xa6e8772af29b29b9202a073f8e36f447689beef6'
  is: contract
  says: one owner already has code
  for:
  - evidence-3
- id: nestedsafe
  call: '0xa6e8772af29b29b9202a073f8e36f447689beef6'
  fn: VERSION()(string)
  is: 1.3.0
  says: that owner is a Safe 1.3.0 wallet
  for:
  - evidence-3
- id: nestedhandler
  storage: '0xa6e8772af29b29b9202a073f8e36f447689beef6'
  slot: '0x6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d5'
  is: '0x0000000000000000000000002f55e8b20d0b9fefa187aa7d00b6cbe563605bf5'
  says: the Safe owner's fallback handler
  for:
  - notes
- id: nestedmethod
  call: '0x2f55e8b20d0b9fefa187aa7d00b6cbe563605bf5'
  fn: safeMethods(address,bytes4)(bytes32)
  args:
  - '0xa6e8772af29b29b9202a073f8e36f447689beef6'
  - '0x20c13b0b'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: that handler has no method set for isValidSignature(bytes,bytes) on the Safe owner
  for:
  - notes
- id: nestedreverts
  call: '0xa6e8772af29b29b9202a073f8e36f447689beef6'
  fn: isValidSignature(bytes,bytes)(bytes4)
  args:
  - '0x1234'
  - 0x
  reverts: true
  says: the Safe owner does not answer the older isValidSignature at the block
  for:
  - notes
- id: eip
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: EIP-8151 returns no address for real code and still recovers an EIP-7702 delegation
  for:
  - what
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

This Safe runs a transaction once 3 of its 7 owners approve: by ECDSA signature, by a call from the owner, or by an owner contract's signature check. An owner whose account takes real code no longer counts by ECDSA signature; an EIP-7702 delegation keeps working.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x6851d6fdfafd08c0295c392436245e5bc78b0185#code) recovers owner signatures with ecrecover, or asks an owner contract via isValidSignature(bytes,bytes).
- [approveHash](https://etherscan.io/address/0x6851d6fdfafd08c0295c392436245e5bc78b0185#code) lets an owner approve by its own call; swapOwner replaces an owner by a wallet transaction.
- [The wallet](https://etherscan.io/address/0x02479bfc7dce53a02e26fe7baea45a0852cb0909#readProxyContract) has 7 owners, needs 3 and has no modules; one owner is already a Safe contract.

## Reviewer notes

### Mechanism

The address is a Safe proxy: its fallback delegate-calls the master copy in slot 0, Safe 1.2.0 at 0x6851d6fd. execTransaction calls checkSignatures, which needs 3 entries in ascending owner order. v=0: a contract owner is asked through the older isValidSignature(bytes,bytes) and must return 0x20c13b0b (line 239); v=1: the owner is msg.sender or stored an approval with approveHash; v>30: eth_sign recovered with ecrecover; else plain ecrecover. The result must be a current owner. Under EIP-8151 the two ecrecover branches return no owner once its account has real code. v=0 and v=1 recover nothing, so an owner whose new code answers the older isValidSignature, or can call approveHash or execTransaction, keeps counting. swapOwner and changeMasterCopy are authorized (wallet only), so the other owners can replace a migrated key by a 3-of-7 transaction. At the block: 7 owners, threshold 3, nonce 496, no modules; six owners have no code, one (0xa6e8772a) is a Safe 1.3.0 proxy whose fallback handler has no method set for isValidSignature(bytes,bytes) (the call reverts), so today it counts through v=1, and it can set such a method. This address holds about $344,271 (mostly USDC); the 749 copies hold about $377,694 in all (study data).

### Checks

- Header facts: this address alone, at block 26,438,999; 749 addresses run this code.
- Ruled out: not affected (the earlier removal): the ecrecover branches stop recovering an owner with real code; v=0 accepts only code answering the older isValidSignature, which not all code does. The signed path for ECDSA owners is lost, so this is a notice, not a removal.
- Ruled out: erc1271 (refuter): v=0 is now named. The refuter's example does not hold at the block: owner 0xa6e8772a reverts on isValidSignature and its handler has no method for 0x20c13b0b; it counts through v=1 instead.
- Ruled out: rotate-signer-before-migrating (old issue): a migrated owner keeps v=1 (and v=0 if supported) and the others can swap it; nothing waits on a rotation, so filed as a lost signed shortcut.
- Ruled out: unused implementation: this address is an initialized proxy with 7 owners, threshold 3, nonce 496.
- Ruled out: a signature checked again after others relied on it: checkSignatures runs once, at execution; a migration between signing and execution only forces a new approval.
- Ruled out: a module path without signatures: getModules is empty at the block.
- Ruled out: breaks by itself: another copy's replayed execTransaction fails under EIP-8151 with an ordinary signer and no migration; that is the separate issue sender-gas-limits|0x02479bfc (wave 1) for the reviewer to link, not cited here as this notice's effect.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
