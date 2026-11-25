---
id: gnosissafe-ee136c03-owner-ecdsa-keys
format: 2
title: A quantum computer could forge the owner keys that move this Safe's funds
status: confirmed
severity: MEDIUM
justification: Four forged owner keys move everything; the owners can fix it by swapping in post-quantum signer
  contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xee136c0389733849dd710ac7104e92c6bf497574'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 113823150
  basis: held
activity: {}
impact: funds-loss
action: Swap each owner with swapOwner for a post-quantum signer contract that answers Safe 1.3.0's legacy isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a default owner signature is recovered with ECDSA
  for:
  - evidence-1
  - what
- id: ethsign
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: an eth_sign owner signature is recovered with ECDSA too
  for:
  - notes
- id: is-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: each recovered address must be a distinct owner
  for:
  - evidence-1
  - what
- id: contract-sig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: an owner that is a contract is asked through isValidSignature, not ecrecover
  for:
  - action
  - evidence-1
  - justification
- id: approved
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: an owner can also approve by sending the transaction or calling approveHash
  for:
  - notes
- id: exec
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 143
  - 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction runs any call once checkSignatures passes
  for:
  - justification
  - what
- id: exec-call
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: 'success = execute(to, value, data, operation, gasPrice == 0 ? (gasleft() - 2500) : safeTxGas);'
  says: the approved call is executed with the Safe's funds (value, data, operation chosen by the signers)
  for:
  - justification
  - what
- id: threshold-src
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 230
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: threshold-many signatures are required
  for:
  - evidence-1
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 108
  has: owners[newOwner] = owners[oldOwner];
  says: swapOwner replaces an owner with a new address
  for:
  - action
  - justification
- id: selfauth
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: owner changes are only possible by the Safe calling itself, i.e. through an approved Safe transaction
  for:
  - action
  - justification
- id: owners
  call: '0xee136c0389733849dd710ac7104e92c6bf497574'
  fn: getOwners()(address[])
  is:
  - '0xc9180ff81675b86a73a02e61233e6145658f4488'
  - '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  - '0x84fd60540cab330011812cb5e342a6db45095fa1'
  - '0x859003b39a165bb775b04657826c397ad84fe208'
  - '0xec224d0dc9d80c1f6d5a486efe2667f040834130'
  - '0x42c979dbbd691fda334807fd4c3ffe67ea3df9aa'
  - '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  says: the Safe has these 7 owners
  for:
  - evidence-2
  - what
- id: threshold
  call: '0xee136c0389733849dd710ac7104e92c6bf497574'
  fn: getThreshold()(uint256)
  is: 4
  says: 4 owner signatures are required
  for:
  - evidence-1
  - evidence-2
  - justification
  - what
- id: modules
  call: '0xee136c0389733849dd710ac7104e92c6bf497574'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled, so no path executes without owner signatures
  for:
  - evidence-2
  - what
- id: guard
  storage: '0xee136c0389733849dd710ac7104e92c6bf497574'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
- id: singleton
  storage: '0xee136c0389733849dd710ac7104e92c6bf497574'
  slot: '0x0'
  is: '0x000000000000000000000000d9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: the proxy runs the Safe 1.3.0 singleton
  for:
  - notes
- id: version
  call: '0xee136c0389733849dd710ac7104e92c6bf497574'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe answers version 1.3.0
  for:
  - action
- id: safe-nonce
  call: '0xee136c0389733849dd710ac7104e92c6bf497574'
  fn: nonce()(uint256)
  is: 17
  says: the Safe has executed 17 owner-approved transactions, so it is in use
  for:
  - notes
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xee136c0389733849dd710ac7104e92c6bf497574'
  is: 14963600033510441822369
  says: the Safe holds about 14,963.6 ETH
  for:
  - notes
- id: code-1
  code: '0xc9180ff81675b86a73a02e61233e6145658f4488'
  is: empty
  says: 'owner 0xc9180ff81675b86a73a02e61233e6145658f4488 has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-2
  code: '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  is: empty
  says: 'owner 0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-3
  code: '0x84fd60540cab330011812cb5e342a6db45095fa1'
  is: empty
  says: 'owner 0x84fd60540cab330011812cb5e342a6db45095fa1 has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-4
  code: '0x859003b39a165bb775b04657826c397ad84fe208'
  is: empty
  says: 'owner 0x859003b39a165bb775b04657826c397ad84fe208 has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-5
  code: '0xec224d0dc9d80c1f6d5a486efe2667f040834130'
  is: empty
  says: 'owner 0xec224d0dc9d80c1f6d5a486efe2667f040834130 has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-6
  code: '0x42c979dbbd691fda334807fd4c3ffe67ea3df9aa'
  is: empty
  says: 'owner 0x42c979dbbd691fda334807fd4c3ffe67ea3df9aa has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-7
  code: '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  is: empty
  says: 'owner 0x27619cacedcd18a08a1cdcb206a6f14196210fce has no code: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: nonce-1
  nonce: '0xc9180ff81675b86a73a02e61233e6145658f4488'
  is: 54
  says: owner 0xc9180ff81675b86a73a02e61233e6145658f4488 has sent transactions, which publish its public key
  for:
  - evidence-2
  - what
- id: nonce-2
  nonce: '0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c'
  is: 55
  says: owner 0x7fd82ad94cf5d9d947beb7ce3328300aa34acb3c has sent transactions, which publish its public key
  for:
  - evidence-2
  - what
- id: nonce-3
  nonce: '0x84fd60540cab330011812cb5e342a6db45095fa1'
  is: 19
  says: owner 0x84fd60540cab330011812cb5e342a6db45095fa1 has sent transactions, which publish its public key
  for:
  - evidence-2
  - what
- id: nonce-7
  nonce: '0x27619cacedcd18a08a1cdcb206a6f14196210fce'
  is: 5
  says: owner 0x27619cacedcd18a08a1cdcb206a6f14196210fce has sent transactions, which publish its public key
  for:
  - evidence-2
  - what
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
- who: r-ee136c03, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): a 4-of-7 Safe 1.3.0 (about $113.8M) whose seven owners
    are plain ECDSA keys, four with exposed public keys (exactly the threshold); no module or guard. Fix: swapOwner
    to post-quantum signer contracts answering Safe 1.3.0''s legacy isValidSignature(bytes,bytes) (Claude''s action
    fix; two refuters agreed before it, a fresh one after). whose not established. Claude read the sheet.'
related: []
---

## What happens

This Safe runs any transaction, including moving all it holds, once 4 of its 7 owners approve it. All 7 owners are plain ECDSA keys, and 4 of them have sent transactions, which reveal their public keys. A quantum computer could recover those 4 keys and sign for them.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers owner signatures with ECDSA and needs 4 distinct owners; contract owners answer isValidSignature.
- [The Safe](https://etherscan.io/address/0xee136c0389733849dd710ac7104e92c6bf497574#readProxyContract) has threshold 4, 7 owners with no code, no modules; 4 owners have sent transactions.

## Reviewer notes

### Mechanism

The proxy delegates to the Safe 1.3.0 singleton (slot 0, VERSION 1.3.0). execTransaction (GnosisSafe.sol 143-145, 176) increments the nonce, calls checkSignatures and then executes the call or delegatecall the signers chose. checkSignatures requires threshold (4) signatures; checkNSignatures (240-304) accepts per slot: v==0 a contract owner's isValidSignature (285), v==1 an approved hash or msg.sender (291), v>30 ecrecover of the eth_sign hash (295), else ecrecover(dataHash) (299); each must be a distinct owner (301). All 7 owners have no code at the block, so each is satisfied by an ECDSA signature or a transaction it sends (also ECDSA). Owners 0xc9180ff8 (nonce 54), 0x7fd82ad9 (55), 0x84fd6054 (19) and 0x27619cac (5) have sent transactions, which publish their public keys: exactly the threshold. No module is enabled and no guard is set, so owner signatures are the only path. Fix without a protocol change: an approved Safe transaction calls swapOwner (OwnerManager 94-108, self-call only via SelfAuthorized line 8) to replace each EOA owner with a post-quantum signer contract, which the Safe then checks through isValidSignature only. Rated MEDIUM: fixable, but the fix is the owners migrating.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path that protects these owners: the isValidSignature branch serves only owners that are contracts; all 7 owners have no code (code checks).
- Ruled out: a path around owner signatures: no module is enabled and the guard slot is empty.
- Ruled out: the three owners with nonce 0 (0x859003b3, 0xec224d0d, 0x42c979db): their keys may be unexposed today, but the 4 others already meet the threshold; whether they signed Safe transactions off-chain was not checked.
- Ruled out: the family's replays (0xd34b6a89, 0x16a1d468, 0x5b42f691) are other Safes' transactions, not this address's; under EIP-8151 an owner that moves to real code loses its two ecrecover forms here but keeps approveHash and sending the transaction itself, so nothing breaks here with nobody migrating as far as the source shows (no replay of this Safe's own transactions exists).
- Ruled out: project: the row named safe, but Safe wrote the code and does not hold these keys; who runs this Safe is not shown, so project and whose are left empty.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
