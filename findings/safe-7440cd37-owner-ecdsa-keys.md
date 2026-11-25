---
id: safe-7440cd37-owner-ecdsa-keys
format: 2
title: This Safe's three owners are ECDSA keys a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Two forged owner keys move all its ETH; the fix needs the owners to swap their keys for post-quantum
  signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  name: Safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 39700320
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Use swapOwner to replace each ECDSA owner with a post-quantum signer contract that answers isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x7440cd37c794c4bcf1748915098280706c9b6099'
  is: '22000000000000000000000'
  says: the Safe holds 22,000 ETH
  for:
  - what
- id: threshold
  call: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  fn: getThreshold()(uint256)
  is: 2
  says: two owner approvals execute a transaction
  for:
  - justification
  - what
- id: owners
  call: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  fn: getOwners()(address[])
  is:
  - '0xb11ec9a19d440e63407d10a5bd6655b1bb497b7e'
  - '0x614dd2d230be276af5532105901e63accc9a7fbd'
  - '0xcb1085e1b8d8b08a637d50ef601bd2781e6792a0'
  says: the Safe has three owners
  for:
  - justification
  - what
- id: owner1-code
  code: '0xb11ec9a19d440e63407d10a5bd6655b1bb497b7e'
  is: empty
  says: owner 0xb11ec9a1 is a plain account with no code
  for:
  - what
- id: owner2-code
  code: '0x614dd2d230be276af5532105901e63accc9a7fbd'
  is: empty
  says: owner 0x614dd2d2 is a plain account with no code
  for:
  - what
- id: owner3-code
  code: '0xcb1085e1b8d8b08a637d50ef601bd2781e6792a0'
  is: empty
  says: owner 0xcb1085e1 is a plain account with no code
  for:
  - what
- id: version
  call: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  fn: VERSION()(string)
  is: 1.4.1
  says: the Safe runs version 1.4.1
  for:
  - evidence-3
- id: singleton
  storage: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  slot: '0x0'
  is: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  says: slot 0 holds the Safe 1.4.1 singleton the proxy delegates to
  for:
  - evidence-3
- id: safe-nonce
  call: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  fn: nonce()(uint256)
  is: 1
  says: the Safe has executed one transaction
  for:
  - evidence-2
- id: first-tx
  tx: '0xa73ac089553a64154ac348c77800b729a8363a5b5d80662a094f8a5e93cca26c'
  to: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  ok: true
  says: the transaction that executed the Safe's nonce 0 went to this Safe and succeeded
  for:
  - evidence-2
  - what
- id: sigs-accepted
  call: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  fn: checkNSignatures(bytes32,bytes,bytes,uint256)()
  args:
  - '0xeba0a5355df159ff5cd1033a14f5224b5f03d3c5d544df970ed45bf44f0622a1'
  - '0x190142f1ec829268999902fea55073305c672d4d12939c12c2a922434dae7f20fbb0f6abf44fc0193525c99f593c66b9fbbfcbfcaa4b5e7b9989351d456f67a432d3'
  - '0xd22ba3fc2a8c66d505ae5fd8681874fe827961aa68d98924e2e8907cbc06e90d284edee486ab95ac5959a9f9bf867412cfe8dc011c62f5294600a01785c805031cd24feb6369778461ae261031e836e9f6ce3155703a43977df1789a0e346628682f9ec618d86582c8eaf436d7e8a82c6bb278858640957efb55ab7d8214dffde21c'
  - 2
  is: []
  says: the two signatures of the Safe's only transaction still recover to two current owners
  for:
  - evidence-2
  - what
- id: checked
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 172
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures before it executes
  for:
  - what
- id: exec
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 203
  has: success = execute(to, value, data, operation,
  says: execTransaction then executes any call with any value
  for:
  - justification
  - what
- id: ecdsa
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: an ordinary signature slot is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: owner-match
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 331
  has: owners[currentOwner] != address(0)
  says: the recovered address only has to be a current owner; the owner's account is not asked
  for:
  - evidence-1
  - justification
  - what
- id: legacy-1271
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 315
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: a contract owner is asked through isValidSignature(bytes,bytes)
  for:
  - action
  - evidence-3
- id: legacy-magic
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the answer expected is the legacy magic 0x20c13b0b
  for:
  - action
  - evidence-3
- id: legacy-bytecode
  bytecode: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  has: 6320c13b0b
  says: the singleton pushes the legacy selector 0x20c13b0b
  for:
  - action
  - evidence-3
- id: no-final-1271
  bytecode: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  has: 1626ba7e
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton
  for:
  - action
  - evidence-3
- id: swap
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/OwnerManager.sol
  line: 99
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner) public authorized
  says: swapOwner replaces an owner, through a call by the Safe itself
  for:
  - action
  - justification
- id: swap-set
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/base/OwnerManager.sol
  lines:
  - 107
  - 109
  has: owners[prevOwner] = newOwner;
  says: swapOwner puts the new owner in the old one's place and removes the old one
  for:
  - action
- id: self-call
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/common/SelfAuthorized.sol
  line: 10
  has: require(msg.sender == address(this), "GS031");
  says: owner changes need a Safe transaction, so two owners approve them
  for:
  - action
  - justification
- id: no-modules
  call: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module can execute without owner signatures
  for:
  - notes
- id: no-guard
  storage: '0x7440cd37c794c4bcf1748915098280706c9b6099'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
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
- who: r-7440cd37, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: A Safe proxy on the 1.4.1 singleton, 2 of 3 owners, holding 22,000 ETH; no module, no guard; it has
    executed one transaction, which carries two owners'' ECDSA signatures. MEDIUM, PQ-12: two forged owner keys
    move the ETH; the plain-ECDSA branch checks only owner membership and the contract path is asked only when the
    submitter chooses it, so the fix is swapOwner to signer contracts answering the legacy isValidSignature(bytes,bytes).
    Author A-7440cd37; refuter R-7440cd37 recomputed the transaction hash, recovered both owner keys itself and
    agreed with no objection; the reader changed nothing.'
related: []
---

## What happens

This Safe holds 22,000 ETH and runs any transaction that two of its three owners sign. All three owners are ECDSA keys, and two of them have signed on-chain. A quantum attacker who recovers those two keys can move the ETH, even after an owner moves its own account to post-quantum authorisation.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) counts an owner when an ECDSA signature recovers to its address; it never asks the owner's account.
- The Safe's [one executed transaction](https://etherscan.io/tx/0xa73ac089553a64154ac348c77800b729a8363a5b5d80662a094f8a5e93cca26c) carries two owners' ECDSA signatures; the Safe still accepts them.
- Its [code](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) asks a contract owner through isValidSignature(bytes,bytes), not the final isValidSignature(bytes32,bytes).

## Reviewer notes

### Mechanism

SafeProxy delegates to the Safe 1.4.1 singleton in slot 0. execTransaction (Safe.sol 139-221) hashes the transaction with the nonce, calls checkSignatures (line 172), which requires threshold-many slots in checkNSignatures (274-334), then executes any call or delegatecall (line 203). Per slot: v==0 calls the owner's legacy isValidSignature(bytes,bytes) and expects 0x20c13b0b (315); v==1 accepts an owner that is the sender or called approveHash (321); v>30 and otherwise ecrecover (325, 329). The recovered address only has to be a current owner in ascending order (331); the owner's account is never consulted. Threshold 2; owners 0xb11ec9a1, 0x614dd2d2, 0xcb1085e1, all plain accounts with no code. Transaction 0xa73ac089 (nonce 0, sent by 0xb11ec9a1) carries two v=28 signatures; checkNSignatures re-run at the block with that transaction's hash, encoded data and signatures passes, so the two signers are current owners and their public keys are on-chain. A CRQC that derives those two keys signs any execTransaction (transfer, swapOwner, a delegatecall that rewrites slot 0). Owners change only through a self-call (SelfAuthorized line 10), so the fix is two owners approving swapOwner (OwnerManager 99-112) to post-quantum signer contracts that answer the legacy interface; this singleton has no call to isValidSignature(bytes32,bytes).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path that would protect these owners: the contract path (v==0) is used only when the signer chooses it; an attacker sends v=27/28 and the Safe recovers the address without asking the account (lines 286-331). All three owners have no code at the block.
- Ruled out: other ways in or out: no module is enabled (getModulesPaginated returns none) and no guard is set (guard slot is zero); the approved-hash path (line 321) needs an owner's own transaction, which for these plain accounts is also an ECDSA signature.
- Ruled out: implementation-only code: this address is a proxy with its own state (threshold 2, three owners, nonce 1, 22,000 ETH).
- Ruled out: a singleton swap as the fix: a delegatecall migration that changes slot 0 keeps the same owners and their ECDSA path.
- Ruled out: the family replay 0x09827fd9…: it is another Safe's transaction on the same singleton, not this address; not cited.
- Ruled out: EIP-8151: an owner whose account takes real code would lose only its ECDSA signature and could still approve on-chain; that migration notice is a separate root issue, not folded in here.
- Ruled out: the third owner 0x614dd2d2 has nonce 0 and does not sign that transaction; whether its public key is public elsewhere was not checked, and the threshold is met by the other two.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
