---
id: walletsimple-bd02c511-fixed-ecdsa-signers
format: 2
title: A 2-of-3 wallet with fixed ECDSA signers can be emptied by forged keys
status: confirmed
severity: MEDIUM
justification: Two forged signer keys empty the wallet; signers are fixed, so the owners must move the funds to
  a new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  name: WalletSimple
  code: verified
  code_url: https://etherscan.io/address/0xbd02c51150a4ab6ce97b9de2025644594f3e75b8#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 205899963
  basis: held
activity: {}
impact: funds-loss
action: Move the funds, with two of the three signers, to a wallet that accepts post-quantum signers; this one cannot
  change its signers.
evidence_level: source
checks:
- id: onlysigner-eth
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  lines:
  - 121
  - 128
  has: ) public onlySigner {
  says: sendMultiSig can be called only by a signer
  for:
  - action
  - evidence-1
  - what
- id: onlysigner-token
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  lines:
  - 153
  - 160
  has: ) public onlySigner {
  says: sendMultiSigToken can be called only by a signer
  for:
  - evidence-1
  - justification
  - what
- id: modifier
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  line: 86
  has: if (!isSigner(msg.sender)) {
  says: onlySigner reverts unless the sender is in the signer list
  for:
  - justification
  - what
- id: recover
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  line: 265
  has: return ecrecover(operationHash, v, r, s);
  says: the second signer is the address recovered from the signature with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: other-is-signer
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  line: 220
  has: if (!isSigner(otherSigner)) {
  says: the recovered address must be one of the stored signers
  for:
  - evidence-1
  - evidence-2
  - justification
  - what
- id: not-self
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  line: 224
  has: if (otherSigner == msg.sender) {
  says: the recovered signer must differ from the sender
  for:
  - evidence-1
  - evidence-2
  - what
- id: send-eth
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  line: 135
  has: toAddress.call.value(value)(data)
  says: sendMultiSig sends any amount with any data to any address
  for:
  - action
  - what
- id: send-token
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  line: 167
  has: instance.transfer(toAddress, value)
  says: sendMultiSigToken transfers any amount of a token to any address
  for:
  - what
- id: ctor
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  lines:
  - 59
  - 65
  has: signers = allowedSigners;
  says: the signer list is written in the constructor
  for:
  - action
  - evidence-3
  - justification
  - what
- id: fixed-comment
  source: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  file: WalletSimple.sol
  line: 55
  has: Signers CANNOT be changed once they are set
  says: the authors state the signers cannot be changed
  for:
  - action
  - evidence-3
  - what
- id: no-proxy
  storage: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-3
  - justification
  - what
- id: no-upgrade
  selector: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - evidence-3
  - justification
  - what
- id: signer-0
  call: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  fn: signers(uint256)(address)
  args:
  - 0
  is: '0xc6fc89ab8547c4d2902fc95ceb3c2b6ebe2ac091'
  says: the first signer
  for:
  - what
- id: signer-1
  call: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  fn: signers(uint256)(address)
  args:
  - 1
  is: '0xe764f73bbe0b762bf7a81c1a8d2f1f6dc98dfbdb'
  says: the second signer
  for:
  - what
- id: signer-2
  call: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  fn: signers(uint256)(address)
  args:
  - 2
  is: '0x9c58bcb0084a50950e24d072fef5200bab279a64'
  says: the third signer, the one that sends
  for:
  - evidence-2
  - what
- id: safemode-off
  call: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  fn: safeMode()(bool)
  is: false
  says: safe mode is off, so transfers can go to any address
  for:
  - what
- id: sender-nonce
  nonce: '0x9c58bcb0084a50950e24d072fef5200bab279a64'
  min: 144000
  says: the sending signer has sent many transactions, so its public key is on chain
  for:
  - evidence-2
  - what
- id: real-tx
  tx: '0x1681359aa9ab4af3bce08c345afe73556dc120de9a7d57a1a4776a986d426969'
  to: '0xbd02c51150a4ab6ce97b9de2025644594f3e75b8'
  ok: true
  says: a successful sendMultiSigToken to this wallet, whose calldata carries the co-signer's signature
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

This 2-of-3 wallet moves ETH or tokens when one signer sends the transaction and a second signer's ECDSA signature is recovered. Its three signers are set at creation and the code cannot change. A quantum attacker who derives two signers' keys from their signatures on chain can empty it.

## Evidence

- [sendMultiSig and sendMultiSigToken](https://etherscan.io/address/0xbd02c51150a4ab6ce97b9de2025644594f3e75b8#code) need a signer as sender and an ecrecover-checked second signer.
- [A token transfer](https://etherscan.io/tx/0x1681359aa9ab4af3bce08c345afe73556dc120de9a7d57a1a4776a986d426969), sent by one signer and co-signed by another, puts both signatures on chain.
- [The signers](https://etherscan.io/address/0xbd02c51150a4ab6ce97b9de2025644594f3e75b8#code) are written only by the constructor, and the address has no proxy slot or upgrade function.

## Reviewer notes

### Mechanism

sendMultiSig (lines 121-140) and sendMultiSigToken (lines 153-170) are onlySigner (lines 85-90: msg.sender must be in signers). Both call verifyMultiSig (lines 196-230), which takes otherSigner = recoverAddressFromSignature(operationHash, signature) (plain ecrecover, line 265), requires isSigner(otherSigner) (line 220) and otherSigner != msg.sender (line 224), checks safe mode, expiry and the sequence id, then the wallet sends value with arbitrary data (line 135) or calls token.transfer (line 167). The signers array is assigned only at line 64, in the constructor (exactly 3); no function writes it, and the code has no proxy slot, no upgrade function and no delegatecall. At block 26,438,999 the signers are 0xc6fc89ab... (nonce 0, the co-signer recovered in 1,008 window transactions), 0xe764f73b... (nonce 0) and 0x9c58bcb0... (nonce 144,806, the sender); all three have no code, and safeMode is false. A CRQC holder derives 0x9c58bcb0's key from its transaction signatures and 0xc6fc89ab's from its signatures in sendMultiSigToken calldata, then sends sendMultiSig from one with the other's signature to any address. Fix by the wallet's holders only: two signers co-sign moving the assets to a wallet whose signers can be post-quantum. Rated as one wallet: one owner group moving to a new deployment is MEDIUM (step 3); the old HIGH counted 23 wallets as a group, which the rubric forbids.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or contract-signer path: verifyMultiSig (lines 196-230) only compares the ecrecover result with the stored signers.
- Ruled out: a signer setter or upgrade: signers is written only at line 64 (constructor); EIP-1967 slot empty, no upgradeTo selector, no DELEGATECALL per the scaffold.
- Ruled out: safe mode as protection: safeMode() is false at the block; when on it only restricts recipients to signer addresses, which an attacker holding a signer key controls.
- Ruled out: the address being an unused implementation: it is a standalone wallet with constructor signers and 1,008 recoveries in the two-week window (last at block 26,438,970); no copies are listed.
- Ruled out: Forwarder.flushTokens and flushForwarderTokens: they only move tokens from forwarders into this wallet, not out.
- Ruled out: the EIP-8151 side (separate root issue, not folded in): under EIP-8151 a signer whose account takes real code can no longer be the recovered co-signer; the dossier's family replay on another copy (0x3a5cc868...) reverts only with real code at the co-signer and succeeds with a 7702 delegation or with nobody migrating.
- Ruled out: project bitgo: the verified source does not name BitGo, so no project is set.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
