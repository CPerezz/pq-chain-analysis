---
id: safel2-f4ac5a5d-signed-shortcut-lost
format: 2
title: Safe owner whose account takes real code loses its ECDSA confirmation
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks until an owner's account takes code; it can confirm by call, approveHash, or legacy
  isValidSignature.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  name: SafeL2
  code: verified
  code_url: https://etherscan.io/address/0x29fcb43b46531bca003ddc8fcb67ffe91900c762#code
  proxy_of: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  copies: 39586
  family: 9a69c84f36e5dc4b8bd01609501dd9e6
value:
  usd: 3699375
  basis: held
activity: {}
impact: liveness
action: Confirm by a call, approveHash or legacy isValidSignature once an owner has code; a new owner 3 is not locked
  unless a new guard is set.
evidence_level: source
checks:
- id: ecdsa
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: an ECDSA signature is recovered with ecrecover, with no check of the signer's code
  for:
  - evidence-1
  - justification
  - what
- id: isowner
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/Safe.sol
  line: 331
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  says: each confirming address must be a stored owner, in ascending order
  for:
  - evidence-1
- id: approved
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/Safe.sol
  line: 321
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "GS025");
  says: with v=1 an owner counts when it sends the transaction or has approved its hash, without ecrecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approvehash
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/Safe.sol
  lines:
  - 342
  - 346
  has: approvedHashes[msg.sender][hashToApprove] = 1;
  says: approveHash lets an owner approve a hash by its own call
  for:
  - action
  - evidence-1
  - justification
  - what
- id: legacy
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/Safe.sol
  line: 315
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  says: with v=0 the owner is asked through isValidSignature, without ecrecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: legacysel
  selector: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  fn: isValidSignature(bytes,bytes)
  says: the singleton asks the legacy isValidSignature(bytes,bytes), selector 0x20c13b0b
  for:
  - action
  - justification
- id: finalsel
  selector: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the singleton never asks the final ERC-1271 isValidSignature(bytes32,bytes)
  for:
  - notes
- id: version
  call: '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  fn: VERSION()(string)
  is: 1.4.1
  says: the wallet runs Safe 1.4.1
  for:
  - justification
- id: swap
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/base/OwnerManager.sol
  lines:
  - 99
  - 112
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner) public authorized {
  says: swapOwner replaces one owner with another and is restricted by authorized
  for:
  - action
- id: selfcall
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/common/SelfAuthorized.sol
  line: 10
  has: require(msg.sender == address(this), "GS031");
  says: authorized functions run only as a call from the Safe itself, that is a transaction its owners confirmed
  for:
  - action
- id: setguard
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/base/GuardManager.sol
  lines:
  - 53
  - 63
  has: function setGuard(address guard) external authorized {
  says: a Safe transaction can replace the guard with setGuard
  for:
  - action
- id: guardcall
  source: '0x29fcb43b46531bca003ddc8fcb67ffe91900c762'
  file: contracts/Safe.sol
  lines:
  - 174
  - 177
  has: Guard(guard).checkTransaction(
  says: execTransaction calls the guard set in the guard slot before executing
  for:
  - what
- id: owners
  call: '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  fn: getOwners()(address[])
  is:
  - '0x04f8bdefc5cd23670827cc66829eb16301d7b6f2'
  - '0x68bc120208456e3d5970fe097f15a9dbe5c219ed'
  - '0x70c731e1939b13b4c949783a51a78eabe24dd403'
  says: the wallet has three owners
  for:
  - evidence-3
  - what
- id: threshold
  call: '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  fn: getThreshold()(uint256)
  is: 2
  says: two owners must confirm
  for:
  - evidence-3
  - what
- id: modules
  call: '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: the wallet has no modules
  for:
  - evidence-3
- id: code1
  code: '0x04f8bdefc5cd23670827cc66829eb16301d7b6f2'
  is: empty
  says: the first owner has no code
  for:
  - evidence-3
- id: code2
  code: '0x68bc120208456e3d5970fe097f15a9dbe5c219ed'
  is: empty
  says: the second owner has no code
  for:
  - evidence-3
- id: code3
  code: '0x70c731e1939b13b4c949783a51a78eabe24dd403'
  is: empty
  says: the third owner has no code
  for:
  - evidence-3
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  is: '2050014950000000000000'
  says: the wallet holds 2,050.01 ETH
  for:
  - evidence-3
- id: guard
  storage: '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: '0x000000000000000000000000a8dfb37ba1f98171ede39ac5c48ecb5bf23f78a4'
  says: the Safe's guard slot holds 0xa8df…78a4
  for:
  - evidence-2
  - what
- id: observer
  call: '0xa8dfb37ba1f98171ede39ac5c48ecb5bf23f78a4'
  fn: safeObserver(address)(address)
  args:
  - '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  is: '0x70c731e1939b13b4c949783a51a78eabe24dd403'
  says: the guard registers the third owner as this Safe's observer
  for:
  - action
  - evidence-2
  - what
- id: timelock
  call: '0xa8dfb37ba1f98171ede39ac5c48ecb5bf23f78a4'
  fn: safeTimelock(address)(uint256)
  args:
  - '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  is: 8760
  says: the observer's timelock is 8,760 hours
  for:
  - evidence-2
  - what
- id: lasttx
  call: '0xa8dfb37ba1f98171ede39ac5c48ecb5bf23f78a4'
  fn: safeLastTxTime(address)(uint256)
  args:
  - '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  is: 1776057995
  says: the Safe's last transaction was at time 1776057995, so the lock runs to 1807593995
  for:
  - evidence-2
  - what
- id: blocktime
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getCurrentBlockTimestamp()(uint256)
  is: 1794969479
  says: the block's time is 1794969479, before the lock ends
  for:
  - evidence-2
  - what
- id: observercheck
  source: '0xa8dfb37ba1f98171ede39ac5c48ecb5bf23f78a4'
  file: contracts/MixinSafeGuard.sol
  lines:
  - 87
  - 98
  has: if (currentSigner == observer) {
  says: the guard checks whether the first or second confirmation is the observer's
  for:
  - action
  - evidence-2
  - what
- id: lock
  source: '0xa8dfb37ba1f98171ede39ac5c48ecb5bf23f78a4'
  file: contracts/MixinSafeGuard.sol
  line: 97
  has: require(block.timestamp > lockTime, "Safe is locked");
  says: a transaction the observer confirmed reverts until the timelock has passed since the last one
  for:
  - evidence-2
  - what
- id: guardonce
  source: '0xa8dfb37ba1f98171ede39ac5c48ecb5bf23f78a4'
  file: contracts/MixinSafeGuard.sol
  lines:
  - 39
  - 43
  has: '"Safe is already guarded"'
  says: the observer is set once per Safe and has no setter
  for:
  - action
- id: nonce1
  nonce: '0x04f8bdefc5cd23670827cc66829eb16301d7b6f2'
  is: 0
  says: the first owner has sent no transaction
  for:
  - notes
- id: nonce2
  nonce: '0x68bc120208456e3d5970fe097f15a9dbe5c219ed'
  is: 0
  says: the second owner has sent no transaction
  for:
  - notes
- id: nonce3
  nonce: '0x70c731e1939b13b4c949783a51a78eabe24dd403'
  is: 0
  says: the third owner has sent no transaction
  for:
  - notes
- id: safenonce
  call: '0xf4ac5a5dc1543086347d28e757091ebd1b848cca'
  fn: nonce()(uint256)
  is: 2
  says: the Safe has executed two transactions
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-f4ac5a5d, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'moved: INFORMATIONAL (PQ-19): Safe owner whose account takes real code loses its ECDSA confirmation. Nothing
    breaks until an owner''s account takes code; it can confirm by call, approveHash, or legacy isValidSignature.
    Moved to signed-shortcut-lost (PQ-19). The first refuter''s objections (the observer guard, ''can no longer
    sign'', the action) were answered by the author''s rewrite, which a refuter then agreed with; Claude shortened
    the action as that refuter noted. Settled by Claude (D-029). Claude read the card and the answers.'
related: []
---

## What happens

Two of this Safe's three owners confirm each transaction; its guard blocks the third owner's confirmations until 8,760 hours after the last transaction, so today the other two move funds. An owner whose account takes real code loses its ECDSA signature; it can still confirm by a call.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x29fcb43b46531bca003ddc8fcb67ffe91900c762#code) recovers ECDSA with no code check; it also counts an owner's call, approveHash or isValidSignature(bytes,bytes).
- The [guard](https://etherscan.io/address/0xa8dfb37ba1f98171ede39ac5c48ecb5bf23f78a4#code) locks owner 0x70c7…d403 for 8,760 hours after the last transaction; it is locked at this block.
- The [wallet](https://etherscan.io/address/0xf4ac5a5dc1543086347d28e757091ebd1b848cca) has three owners without code, needs two, has no modules and holds 2,050 ETH.

## Reviewer notes

### Mechanism

Safe 1.4.1 proxy of the SafeL2 singleton. execTransaction runs checkNSignatures (Safe.sol 274-334) with threshold 2, then the guard (177). Per signature: v=0 asks the owner in r through legacy isValidSignature(bytes,bytes), magic 0x20c13b0b (315; the final ERC-1271 selector 0x1626ba7e is absent from the singleton); v=1 needs msg.sender == owner or approvedHashes (321, set by approveHash 342-346); otherwise ecrecover (325, 329) with no code branch; 331 requires a stored owner, ascending. Under EIP-8151 an owner with real code fails the ECDSA branch only. Guard 0xa8df…78a4 (MixinSafeGuard) reads signatures 0 and 1 (v=0/1 from r, else ecrecover); if either is the observer 0x70c7…d403 it requires block.timestamp > safeLastTxTime + 8,760 h (94-97); safeLastTxTime 1776057995 + 31,536,000 = 1807593995 > block time 1794969479, so the observer is locked; every execution resets the clock (102). guardSafe runs once per Safe (39-43), so swapOwner on the observer leaves the guard pointing at a non-owner: the new owner is unrestricted unless setGuard (authorized) installs a new guard. swapOwner/setGuard are authorized: a Safe transaction, today owners 0x04f8…f2 and 0x68bc…ed. The guard's comment calls the owners holder, MPC signer and observer; a comment does not show whose the ETH is, so whose is left empty.

### Checks

- Header facts: this address alone, at block 26,438,999; 39,586 addresses run this code.
- Ruled out: the old root issue (a key refused until replaced): an owner with real code loses only the ECDSA branch; a call, approveHash and legacy isValidSignature(bytes,bytes) remain (lines 315, 321, 342-346).
- Ruled out: an unused implementation: this proxy has its own state (three owners, threshold 2, nonce 2, 2,050 ETH).
- Ruled out: modules moving funds without signatures: getModulesPaginated(0x1, 10) returns none.
- Ruled out: the guard breaking under EIP-8151 by itself: for v=0 and v=1 it reads the owner from r; for ECDSA an empty recovery is not the observer, and the Safe's own check already refused that signature.
- Ruled out: the observer's lock lifting by itself soon: it resets on every execution and runs to 1807593995 (about April 2027) at the earliest.
- Ruled out: the family's two replays: 0xcca69e3d… is sent to 0xb9e4ae7f…4db1 and 0x77677bcf… to 0x9641d764…02e2, other wallets; none is cited. 0xcca69e3d… fails under EIP-8151 alone (kind tight): a sender gas limit lead for that wallet's row.
- Ruled out: a signature checked again later: confirmations are consumed in the same transaction (lines 170-172).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
