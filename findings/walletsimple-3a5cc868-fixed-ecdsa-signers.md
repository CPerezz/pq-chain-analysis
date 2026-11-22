---
id: walletsimple-3a5cc868-fixed-ecdsa-signers
format: 2
title: A quantum attacker with two signer keys can empty this 2-of-3 wallet
status: confirmed
severity: MEDIUM
justification: Two recovered keys move everything, and signers and code cannot change; the signers can move the
  funds to a new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  name: WalletSimple
  label: 'BitGo: MultiSig 2'
  code: verified
  code_url: https://etherscan.io/address/0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 49387710
  basis: held
activity:
  txs_90d: 62669
impact: funds-loss
action: Have two signers move all funds to a wallet that accepts post-quantum signers; this wallet's signers cannot
  be replaced.
evidence_level: source
checks:
- id: onlysigner
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  lines:
  - 85
  - 90
  has: if (!isSigner(msg.sender)) {
  says: a call from an address that is not a signer is refused
  for:
  - evidence-1
  - justification
  - what
- id: recover
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  line: 265
  has: return ecrecover(operationHash, v, r, s);
  says: the second signer is recovered from its signature with ecrecover
  for:
  - evidence-1
  - what
- id: verify-call
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  line: 204
  has: var otherSigner = recoverAddressFromSignature(operationHash, signature);
  says: the co-signer is taken from the signature passed in the call
  for:
  - evidence-1
  - evidence-2
  - what
- id: cosigner
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  line: 220
  has: if (!isSigner(otherSigner)) {
  says: the recovered address must be one of the stored signers
  for:
  - evidence-1
  - justification
  - what
- id: notself
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  line: 224
  has: if (otherSigner == msg.sender) {
  says: the co-signer must differ from the signer who sends
  for:
  - evidence-1
  - justification
  - what
- id: eth
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  lines:
  - 132
  - 135
  has: var otherSigner = verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId); // Success,
    send the transaction if (!(toAddress.call.value(value)(data))) {
  says: after the check, sendMultiSig makes any call with any ETH amount to any address
  for:
  - action
  - justification
  - what
- id: token
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  lines:
  - 164
  - 167
  has: verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId); ERC20Interface instance = ERC20Interface(tokenContractAddress);
    if (!instance.transfer(toAddress, value)) {
  says: after the same check, sendMultiSigToken transfers any amount of a token to any address
  for:
  - action
  - evidence-2
  - justification
  - what
- id: three
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  line: 60
  has: if (allowedSigners.length != 3) {
  says: the wallet is created with exactly three signers
  for:
  - what
- id: constructor
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  lines:
  - 59
  - 64
  has: signers = allowedSigners;
  says: the constructor stores the signers; no other line of the source writes them
  for:
  - action
  - evidence-1
  - justification
  - what
- id: fixed-comment
  source: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  file: WalletSimple.sol
  line: 55
  has: Signers CANNOT be changed once they are set
  says: the authors state that the signers cannot be changed
  for:
  - action
  - evidence-1
  - justification
  - what
- id: signer0
  call: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  fn: signers(uint256)(address)
  args:
  - 0
  is: '0xd9d77776248c884fb1363e8b8defab6183789680'
  says: first signer, the co-signer whose signatures the wallet recovers
  for:
  - evidence-3
  - what
- id: signer1
  call: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  fn: signers(uint256)(address)
  args:
  - 1
  is: '0x3290e22e5512889766b2606d8727902e36dccf9b'
  says: second signer
  for:
  - evidence-3
  - what
- id: signer2
  call: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  fn: signers(uint256)(address)
  args:
  - 2
  is: '0xb02c6c40a798184d5e012fbb1dc698977671f8fc'
  says: third signer, the address that sends the wallet's transactions
  for:
  - evidence-2
  - evidence-3
  - what
- id: signer3
  call: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  fn: signers(uint256)(address)
  args:
  - 3
  reverts: true
  says: there is no fourth signer
  for:
  - evidence-3
  - what
- id: code0
  code: '0xd9d77776248c884fb1363e8b8defab6183789680'
  is: empty
  says: the first signer has no code
  for:
  - evidence-3
  - what
- id: code1
  code: '0x3290e22e5512889766b2606d8727902e36dccf9b'
  is: empty
  says: the second signer has no code
  for:
  - evidence-3
  - what
- id: code2
  code: '0xb02c6c40a798184d5e012fbb1dc698977671f8fc'
  is: empty
  says: the third signer has no code
  for:
  - evidence-3
  - what
- id: sender-nonce
  nonce: '0xb02c6c40a798184d5e012fbb1dc698977671f8fc'
  is: 556533
  says: the sending signer has sent 556,533 transactions, each signed with its key
  for:
  - evidence-2
  - what
- id: cosigned-tx
  tx: '0xf33e03d5de385ba7bd69c3662a546e5eba093498129af081a3d6372e292c047d'
  to: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  ok: true
  says: a co-signed token transfer called straight to the wallet succeeded, its co-signature in the calldata
  for:
  - evidence-2
  - what
- id: safemode
  call: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  fn: safeMode()(bool)
  is: false
  says: safe mode is off, so the wallet can pay any address
  for:
  - action
  - justification
- id: no-proxy
  storage: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - evidence-3
  - justification
  - what
- id: no-upgrade
  selector: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - evidence-3
  - justification
  - what
- id: replay-tx
  tx: '0x62ce379835317ff07e25b3bce006b6d64b4ae6caf3d450647ab0ce3595bf122a'
  to: '0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597'
  ok: true
  says: the replayed transfer was called straight to the wallet and succeeded
  for:
  - notes
- id: replay-8151
  replay: '0x62ce379835317ff07e25b3bce006b6d64b4ae6caf3d450647ab0ce3595bf122a'
  run: eip8151
  ok: true
  says: under EIP-8151 alone the transfer still succeeds
  for:
  - notes
- id: replay-code
  replay: '0x62ce379835317ff07e25b3bce006b6d64b4ae6caf3d450647ab0ce3595bf122a'
  run: eip8151_signer_code
  ok: false
  says: with real code at the co-signer, the transfer reverts
  for:
  - notes
- id: replay-7702
  replay: '0x62ce379835317ff07e25b3bce006b6d64b4ae6caf3d450647ab0ce3595bf122a'
  run: eip8151_signer_delegated
  ok: true
  says: with a 7702 delegation at the co-signer, the transfer succeeds
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

This 2-of-3 wallet moves ETH and tokens when one signer sends the call and another signer's ECDSA signature checks out. Its three signers, all accounts without code, are fixed at creation, and its code cannot change. A quantum attacker who recovers two signers' keys can empty it.

## Evidence

- The [verified source](https://etherscan.io/address/0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597#code) lets a signer send only with a second signer's signature, checked by `ecrecover`; the three signers are set once, at creation.
- The [sending signer](https://etherscan.io/address/0xb02c6c40a798184d5e012fbb1dc698977671f8fc) has sent 556,533 transactions, and each [transfer](https://etherscan.io/tx/0xf33e03d5de385ba7bd69c3662a546e5eba093498129af081a3d6372e292c047d) carries a co-signer's signature, so both public keys can be derived from the chain.
- The [contract](https://etherscan.io/address/0x3a5cc8689d1b0cef2c317bc5c0ad6ce88b27d597#readContract) has no proxy and no upgrade function, and its three signers are accounts without code.

## Reviewer notes

### Mechanism

sendMultiSig (121-140) and sendMultiSigToken (153-170) are onlySigner (85-90) and call verifyMultiSig (196-230), which recovers otherSigner with ecrecover over the operation hash (recoverAddressFromSignature, 246-266), checks safe mode, expiry and the sequence window, then requires isSigner(otherSigner) and otherSigner != msg.sender (220-227); sendMultiSig then calls any address with value (135), sendMultiSigToken transfers the token (167). signers is written only in the constructor (64), exactly three (60). No proxy, no upgrade function. Signers at the block: 0xd9d7...9680 (nonce 0, the co-signer in the dossier's traced recoveries), 0x3290...cf9b (nonce 0), 0xb02c...f8fc (sends the wallet's transactions, nonce 556,533); none has code. A CRQC holder derives 0xb02c's public key from its transactions and 0xd9d7's from co-signatures in calldata, recovers both keys, sends as 0xb02c and co-signs as 0xd9d7. safeMode is off; on, it still allows sends to signer addresses, which such an attacker controls.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path or a code-size branch: none; verifyMultiSig only compares ecrecover's address with the stored signers (204, 220-227, 265).
- Ruled out: an unused implementation: no; this address sets its own signers in its constructor and is not a proxy or clone; tx 0xf33e...047d (block 26,344,009) is a co-signed sendMultiSigToken straight to it, signature recovering locally to 0xd9d7...9680.
- Ruled out: a way to replace signers: signers is written only at line 64; flushForwarderTokens only pulls forwarder tokens in, it does not touch signers.
- Ruled out: safe mode as a defence: off at the block; even on, it still pays signer addresses, which an attacker holding a signer key controls.
- Ruled out: in-place migration as the fix: the action is moving funds out, not waiting on all three signers to migrate.
- Ruled out: replay of tx 0x62ce...122a: succeeds under EIP-8151 alone, reverts with real code at the co-signer, succeeds with a 7702 delegation there; a migration notice for the study, not this card.
- Ruled out: rating as the old 23-wallet group (HIGH): rated alone, this wallet's own signers can move its funds (MEDIUM).
- Ruled out: whose money: BitGo's public tag names it a multisig; nothing shows if it holds BitGo's or customers' funds, so whose is left empty; project left empty, not shown in the verified source.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
