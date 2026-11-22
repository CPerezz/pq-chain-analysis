---
id: walletsimple-4a2d57d6-fixed-ecdsa-signers
format: 2
title: Wallet funds can be taken by forging two of its fixed ECDSA signer keys
status: confirmed
severity: MEDIUM
justification: Two exposed signer keys would let a quantum attacker move all funds; signers are fixed, so the owners
  must move them.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  name: WalletSimple
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 21510198
  basis: held
activity:
  txs_90d: 109
impact: funds-loss
action: Have two signers co-sign moving everything to a wallet that accepts post-quantum signers; this wallet's
  signers cannot change.
evidence_level: source
checks:
- id: onlysigner
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 137
  has: require(isSigner(msg.sender), 'Non-signer in onlySigner method');
  says: the sending functions require the caller to be a signer
  for:
  - justification
  - what
- id: recover
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 438
  has: address otherSigner = recoverAddressFromSignature(operationHash, signature);
  says: verifyMultiSig takes the co-signer from the signature
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 546
  has: return ecrecover(operationHash, v, r, s);
  says: the co-signer is recovered with ecrecover
  for:
  - evidence-1
  - what
- id: cosigner
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 449
  has: require(isSigner(otherSigner), 'Invalid signer');
  says: the recovered address must be one of the signers
  for:
  - evidence-1
  - justification
  - what
- id: not-sender
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 451
  has: require(otherSigner != msg.sender, 'Signers cannot be equal');
  says: the co-signer must differ from the sender
  for:
  - evidence-1
  - what
- id: call-out
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 210
  has: '(bool success, ) = toAddress.call{ value: value }(data);'
  says: after the check, sendMultiSig makes any call with any value the two signers chose
  for:
  - action
  - what
- id: init
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  lines:
  - 77
  - 86
  has: signers[allowedSigners[i]] = true;
  says: init writes the three signers and marks the wallet initialized
  for:
  - action
  - evidence-2
  - justification
  - what
- id: uninit
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 145
  has: require(!initialized, 'Contract already initialized');
  says: init runs only once
  for:
  - evidence-2
  - what
- id: fixed-comment
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 73
  has: Signers CANNOT be changed once they are set
  says: the source states that signers cannot be changed
  for:
  - action
  - what
- id: initialized
  call: '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  fn: initialized()(bool)
  is: true
  says: this wallet has run init
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-a
  call: '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  fn: isSigner(address)(bool)
  args:
  - '0x3a1ec84c16a1ff604f0d97e1004068e3814b1586'
  is: true
  says: 0x3a1e…1586, the sending key, is a signer
  for:
  - evidence-3
  - what
- id: signer-b
  call: '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  fn: isSigner(address)(bool)
  args:
  - '0x7dcde223106a59a2021358fd27b952fc8390e997'
  is: true
  says: 0x7dcd…e997 is a signer
  for:
  - notes
- id: signer-c
  call: '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  fn: isSigner(address)(bool)
  args:
  - '0xfdaf5437240bfee9f630917e9bac716dc3e822f6'
  is: true
  says: 0xfdaf…22f6, the co-signing key, is a signer
  for:
  - evidence-3
  - what
- id: code-a
  code: '0x3a1ec84c16a1ff604f0d97e1004068e3814b1586'
  is: empty
  says: the sending key's account has no code
  for:
  - notes
- id: code-b
  code: '0x7dcde223106a59a2021358fd27b952fc8390e997'
  is: empty
  says: the third signer's account has no code
  for:
  - notes
- id: code-c
  code: '0xfdaf5437240bfee9f630917e9bac716dc3e822f6'
  is: empty
  says: the co-signing key's account has no code
  for:
  - notes
- id: nonce-b
  nonce: '0x7dcde223106a59a2021358fd27b952fc8390e997'
  is: 0
  says: the third signer has never sent a transaction
  for:
  - notes
- id: sender-nonce
  nonce: '0x3a1ec84c16a1ff604f0d97e1004068e3814b1586'
  min: 165690
  says: the sending key has signed 165,690 transactions, so its public key is on chain
  for:
  - evidence-3
  - justification
  - what
- id: cosig-tx
  tx: '0x0bafdeb1c44700061d38f3c8d17c5ae47816b94791fc46b5bb538bfdc8eba8d7'
  to: '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  ok: true
  says: a sendMultiSigToken to this wallet that succeeded, with a co-signature in its calldata
  for:
  - evidence-3
  - what
- id: cosig-recover
  call: '0x0000000000000000000000000000000000000001'
  data: '0x6905c3e2a662cf1f45d7d6ee6811989c0cf82014a4737bc7b41d568f9fcd3ac3000000000000000000000000000000000000000000000000000000000000001ce04968a8ed22d4584fe9698b58bcfe3bff612b7c66727cb5db75fc69d171b2c028bfaa2ba5d185035d17abafafd48301943beac744492e80a5277390701d3b73'
  is: '0x000000000000000000000000fdaf5437240bfee9f630917e9bac716dc3e822f6'
  says: the co-signature in that transaction's calldata, over its operation hash (sequence id 1,181), recovers to
    signer 0xfdaf…22f6
  for:
  - evidence-3
  - justification
  - what
- id: clone
  bytecode: '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  has: 363d3d373d3d3d363d73e5dcdc13b628c2df813db1080367e929c1507ca05af43d82803e903d91602b57fd5bf3
  says: the wallet is an EIP-1167 clone whose implementation is fixed in its code
  for:
  - action
  - evidence-2
  - what
- id: no-upgrade
  selector: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  fn: upgradeTo(address)
  absent: true
  says: the implementation has no upgrade function
  for:
  - action
  - evidence-2
  - what
- id: safe-mode
  call: '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  fn: safeMode()(bool)
  is: false
  says: safe mode is off at the block
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd'
  is: 2930000100000000000000
  says: the wallet holds 2,930 ETH
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
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (source read, one real transaction replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

This 2-of-3 wallet moves its funds when one signer sends the call and a second signer's ECDSA signature checks out. The sending key and a co-signing key have both signed on chain, so a quantum computer that recovers them can move everything it holds. Its signers and its code cannot change.

## Evidence

- [verifyMultiSig](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) recovers the co-signer with ecrecover and requires a signer other than the sender.
- `init` sets three signers once and this [wallet](https://etherscan.io/address/0x4a2d57d669f2194fa7b5df619cba9f33ccea26bd#code) has run it; it is a fixed clone of code with no upgrade function.
- The sending key has sent 165,690 transactions, and [a co-signed send](https://etherscan.io/tx/0x0bafdeb1c44700061d38f3c8d17c5ae47816b94791fc46b5bb538bfdc8eba8d7) carries a second signer's signature.

## Reviewer notes

### Mechanism

The address is a 45-byte EIP-1167 clone of WalletSimple 0xe5dc…7ca0 (target fixed in its code). sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig (lines 431-454): otherSigner = recoverAddressFromSignature(operationHash, signature), ending in a plain ecrecover (line 546); it requires isSigner(otherSigner) and otherSigner != msg.sender, then the caller makes an arbitrary call with value (line 210) or a token transfer (line 328). signers is a mapping written only in init (line 82), onlyUninitialized, which sets initialized = true; initialized() is true here. Signers at block 26,438,999 (isSigner true, no code): 0x3a1e…1586 (sender, nonce 165,690; also created the wallet through factory 0xa719…1555 in tx 0x7ac89b38…, whose calldata lists exactly these three), 0xfdaf…22f6 (co-signer: its signature in tx 0x0bafdeb1…, sequence id 1,181, recovers to it through the precompile at the block), 0x7dcd…e997 (nonce 0, never seen recovered). A quantum attacker who recovers the keys of 0x3a1e…1586 and 0xfdaf…22f6 sends from the first with a forged co-signature of the second. Rating, quantum-exposure table: impact funds-loss; nobody can change the verification, so the fix is the owners moving the funds, one wallet's own owner group acting: MEDIUM (step 3). The old HIGH counted 23 wallets' owner groups together, which the rubric forbids.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a contract-signature path for code at a signer: verifyMultiSig passes the ecrecover result straight to isSigner; no code-size branch, no ERC-1271 call in the file.
- Ruled out: an unused implementation: initialized() true, three signers set, 109 calls in 90 days, a co-signed send at block 26,355,012.
- Ruled out: key state: all three signers have no code; the third, 0x7dcd…e997, has nonce 0 and was never seen recovered, so it may be unexposed, but the attack does not need it.
- Ruled out: a setter or upgrade: signers is assigned only inside init, guarded by onlyUninitialized; the implementation has no upgradeTo selector or DELEGATECALL.
- Ruled out: safe mode: off at the block; it only restricts sends to signer addresses, and an attacker holding the sending key is a signer.
- Ruled out: a closed path: not paused, safe mode off, 2,930 ETH held and co-signed sends in November 2026.
- Ruled out: a direct path without a co-signature: none moves the wallet's own funds; the flush functions only make forwarders flush tokens.
- Ruled out: whose money: the owners behind the signer keys are not identified on chain or in source, so whose is left empty.
- Ruled out: EIP-8151 here: the recovery gets all gas; the only family replay is of a different clone and is not cited; a migration notice could sit beside this card.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
