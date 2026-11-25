---
id: gnosissafe-245cc372-owner-ecdsa-keys
format: 2
title: A quantum computer that derives 4 of 8 owner keys can empty this Safe
status: confirmed
severity: MEDIUM
justification: Four derived owner keys move all funds; the fix needs several owners to swap in post-quantum signers.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x245cc372c84b3645bf0ffe6538620b04a217988b'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 1365811
  basis: held
activity:
  txs_90d: 238
impact: funds-loss
action: Swap each EOA owner for a new post-quantum signer contract that answers isValidSignature(bytes,bytes) with
  0x20c13b0b.
evidence_level: source
checks:
- id: singleton
  storage: '0x245cc372c84b3645bf0ffe6538620b04a217988b'
  slot: 0
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: the proxy runs the Safe 1.3.0 singleton
  for:
  - notes
- id: version
  call: '0x245cc372c84b3645bf0ffe6538620b04a217988b'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe reports version 1.3.0
  for:
  - notes
- id: owners
  call: '0x245cc372c84b3645bf0ffe6538620b04a217988b'
  fn: getOwners()(address[])
  is:
  - '0xb7eb90494b0312407afb40f2b5f203a038e9d1e8'
  - '0x680ff9bd827abe38212fc7d447fb8545eea47ff3'
  - '0xf0be8f756389c2d22dd644cc9a3c979f568f3454'
  - '0x746c8c5edb4f568f3d88e3db2adefe0dfe9a1c02'
  - '0x7f7500fe67f6992549376ed9c89360a236468508'
  - '0xcb4524b63f2c532ff52fcbbbcd3c137d32c1d966'
  - '0xd8eb6d9b93b6cbb39abf62b719bbcccd2b16f56b'
  - '0x131bd1a2827cceb2945b2e3b91ee1bf736ccbf80'
  says: the Safe has these eight owners
  for:
  - evidence-2
  - what
- id: threshold
  call: '0x245cc372c84b3645bf0ffe6538620b04a217988b'
  fn: getThreshold()(uint256)
  is: 4
  says: four owner approvals are needed
  for:
  - evidence-2
  - justification
  - what
- id: modules
  call: '0x245cc372c84b3645bf0ffe6538620b04a217988b'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 20
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled, so no module can move funds without owner approvals
  for:
  - evidence-2
- id: guard
  storage: '0x245cc372c84b3645bf0ffe6538620b04a217988b'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
- id: code-b7eb90
  code: '0xb7eb90494b0312407afb40f2b5f203a038e9d1e8'
  is: empty
  says: 'owner 0xb7eb9049 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-680ff9
  code: '0x680ff9bd827abe38212fc7d447fb8545eea47ff3'
  is: empty
  says: 'owner 0x680ff9bd has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-f0be8f
  code: '0xf0be8f756389c2d22dd644cc9a3c979f568f3454'
  is: empty
  says: 'owner 0xf0be8f75 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-746c8c
  code: '0x746c8c5edb4f568f3d88e3db2adefe0dfe9a1c02'
  is: empty
  says: 'owner 0x746c8c5e has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-7f7500
  code: '0x7f7500fe67f6992549376ed9c89360a236468508'
  is: empty
  says: 'owner 0x7f7500fe has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-cb4524
  code: '0xcb4524b63f2c532ff52fcbbbcd3c137d32c1d966'
  is: empty
  says: 'owner 0xcb4524b6 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-d8eb6d
  code: '0xd8eb6d9b93b6cbb39abf62b719bbcccd2b16f56b'
  is: empty
  says: 'owner 0xd8eb6d9b has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: code-131bd1
  code: '0x131bd1a2827cceb2945b2e3b91ee1bf736ccbf80'
  is: empty
  says: 'owner 0x131bd1a2 has no code and no delegation: a plain ECDSA key'
  for:
  - evidence-2
  - what
- id: sent-680ff9
  nonce: '0x680ff9bd827abe38212fc7d447fb8545eea47ff3'
  min: 1
  says: owner 0x680ff9bd has sent transactions (98 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-7f7500
  nonce: '0x7f7500fe67f6992549376ed9c89360a236468508'
  min: 1
  says: owner 0x7f7500fe has sent transactions (5 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-cb4524
  nonce: '0xcb4524b63f2c532ff52fcbbbcd3c137d32c1d966'
  min: 1
  says: owner 0xcb4524b6 has sent transactions (707 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-d8eb6d
  nonce: '0xd8eb6d9b93b6cbb39abf62b719bbcccd2b16f56b'
  min: 1
  says: owner 0xd8eb6d9b has sent transactions (33 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: sent-131bd1
  nonce: '0x131bd1a2827cceb2945b2e3b91ee1bf736ccbf80'
  min: 1
  says: owner 0x131bd1a2 has sent transactions (44 at the block), so its public key is on-chain
  for:
  - evidence-2
  - what
- id: exec-sig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' approvals of the transaction hash
  for:
  - what
- id: exec-op
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: success = execute(to, value, data, operation,
  says: execTransaction then performs any call or delegatecall the owners approved, with any value
  for:
  - justification
  - upgradeable
  - what
- id: delegatecall
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/Executor.sol
  line: 18
  has: success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
  says: an approved transaction can delegatecall code that rewrites the Safe's storage, including its singleton
  for:
  - upgradeable
- id: use-threshold
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  lines:
  - 227
  - 230
  has: checkNSignatures(dataHash, data, signatures, _threshold);
  says: the number of approvals required is the stored threshold
  for:
  - what
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a signature with v 27 or 28 is recovered with ecrecover over the transaction hash
  for:
  - evidence-1
  - justification
  - what
- id: ecdsa-ethsign
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: a signature with v above 30 is recovered with ecrecover over the eth_sign hash
  for:
  - evidence-1
- id: owner-match
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: the recovered address counts if it is an owner; the Safe never asks that address anything
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 291
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: the other way an owner approves is a transaction from its own account (sender or approveHash)
  for:
  - evidence-1
  - what
- id: contract-sig
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: an owner with code is asked through isValidSignature(bytes,bytes) with the full signature
  for:
  - action
  - evidence-3
- id: magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the answer it expects is the legacy magic value 0x20c13b0b
  for:
  - action
  - evidence-3
- id: sel-legacy
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's code holds the legacy selector 0x20c13b0b
  for:
  - action
- id: sel-final
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is absent from the singleton
  for:
  - action
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 106
  - 107
  has: owners[newOwner] = owners[oldOwner]; owners[prevOwner] = newOwner;
  says: swapOwner puts a new owner in place of an old one
  for:
  - action
  - evidence-3
  - justification
- id: swap-auth
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 98
  has: ) public authorized {
  says: swapOwner is restricted by the authorized modifier
  for:
  - action
  - evidence-3
  - justification
- id: self
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: authorized means only the Safe itself, through an approved execTransaction
  for:
  - action
  - evidence-3
  - justification
- id: recent-tx
  tx: '0x2f92f80f436bc735a913eea4393bbda883087fae696e3f06c823da3c6d4f825a'
  to: '0x245cc372c84b3645bf0ffe6538620b04a217988b'
  ok: true
  says: 'a recent execTransaction on this Safe succeeded: the Safe is in use'
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
- who: r-245cc372, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe 1.3.0 proxy, 4 of 8 owners, none with code, no module; about 1.37M USD at the address (the
    first study''s 58.2M was not this address''s own). MEDIUM, PQ-12: four forged owner keys move everything; owners
    can be swapped for signer contracts answering the legacy isValidSignature(bytes,bytes). Author A-245cc372; refuter
    R-245cc372 agreed with no objection and noted that the card undercounted exposure. The reader recovered the
    four approvals of transaction 0x2f92f80f itself (three ECDSA signatures: 0x680ff9bd, 0xb7eb9049, 0xf0be8f75;
    one approval by the sender) and corrected the card: seven of the eight public keys are on-chain, not five. Whose
    funds and activity stay as the tool states them.'
related: []
---

## What happens

This Safe runs any transaction that 4 of its 8 owners approve, and all 8 owners are plain ECDSA keys. Seven of their public keys are on-chain: five sent transactions, two more signed a Safe transaction. A quantum computer could derive four of those keys and sign away everything the Safe holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) counts an owner without code by ecrecover, or by an approval sent from that owner's account.
- [This Safe](https://etherscan.io/address/0x245cc372c84b3645bf0ffe6538620b04a217988b#code) needs 4 of its 8 owners; none has code, five have sent transactions, two more signed [this one](https://etherscan.io/tx/0x2f92f80f436bc735a913eea4393bbda883087fae696e3f06c823da3c6d4f825a), and no module is enabled.
- [swapOwner](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) replaces an owner when the Safe calls itself; owners with code are asked via isValidSignature(bytes,bytes).

## Reviewer notes

### Mechanism

The proxy delegates to the Safe 1.3.0 singleton (slot 0; VERSION 1.3.0). execTransaction hashes the transaction with the nonce, calls checkSignatures, which requires the stored threshold (4) of approvals in checkNSignatures, then executes any call or delegatecall with any value. checkNSignatures reads one 65-byte slot per approval: v 0 asks the owner contract isValidSignature(bytes,bytes) for magic 0x20c13b0b with the full signature; v 1 accepts an owner that is the sender or called approveHash; v above 30 recovers the eth_sign hash; otherwise ecrecover over the hash. The recovered or named address must be an owner, ascending. The v byte is chosen by whoever submits, so an EOA owner is counted by ecrecover even if its account later gets code; the Safe never asks it. All 8 owners have no code; 5 have sent transactions, so their public keys are known. With 4 derived keys a CRQC holder signs any transaction: transfers, swapOwner, or a delegatecall that rewrites the singleton. Owners change only through the Safe calling itself (swapOwner, addOwnerWithThreshold, removeOwner, changeThreshold: authorized = msg.sender == this), so the fix is the owners approving swaps of each EOA for a new post-quantum signer contract that answers the legacy interface; the final ERC-1271 selector is absent from this singleton. No module, no guard.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: the contract-signature path exists, but no owner has code, and the submitter picks v, so an EOA owner that later gets code in place is still counted by ecrecover.
- Ruled out: unused-implementation: this is a proxy in use (nonce 2000; recent execTransaction 0x2f92f80f succeeded), not the singleton.
- Ruled out: key-state: all 8 owners are set, have no code and no EIP-7702 delegation; 5 have sent transactions (nonces 5 to 707).
- Ruled out: setter/path-closed: swapOwner is authorized by self-call, reachable through execTransaction with 4 approvals; threshold is 4, not 0. Safe 1.3.0 has no changeMasterCopy; the singleton changes only by an approved delegatecall.
- Ruled out: other ways to move funds: no module enabled (getModulesPaginated empty), no guard; the fallback handler (0x2f55e8b2...) is reached by CALL from the Safe and cannot spend the Safe's balance itself.
- Ruled out: value: the header figure is what this address alone held at the block (about $1.37M, 2.00 ETH plus 11 tokens), not the first study's $58.2M; whose money it is (team treasury or customer funds) is not shown by any read, so whose is left empty.
- Ruled out: EIP-8151: the family's replays that fail under EIP-8151 alone (0x16a1d468..., 0x5b42f691...) are other Safes' transactions (to 0x237dee52..., 0x61a2c600...), not this one; nothing here is cited from them.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
