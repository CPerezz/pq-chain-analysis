---
id: walletsimple-100ae042-fixed-ecdsa-signers
format: 2
title: Wallet's fixed ECDSA signer keys can be forged to take its funds
status: confirmed
severity: MEDIUM
justification: Forging two signer keys takes the funds; the fix is two signers moving them to a new wallet, as the
  code cannot change.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  name: WalletSimple
  code: verified
  code_url: https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code
  proxy_of: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  copies: 1
  upgradeable: 'no'
value:
  usd: 33208972
  basis: held
activity:
  txs_90d: 8311
impact: funds-loss
action: Move the funds, with two of the three signers, to a wallet that can take post-quantum signers; this wallet's
  signers cannot change.
evidence_level: source
checks:
- id: onlysigner
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 310
  has: require(isSigner(msg.sender), 'Non-signer in onlySigner method');
  says: the send functions require the transaction's sender to be a signer
  for:
  - action
  - evidence-1
  - justification
  - what
- id: recover
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 599
  has: return ecrecover(operationHash, v, r, s);
  says: the second signer is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: cosigner
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  lines:
  - 545
  - 547
  has: require(isSigner(otherSigner), 'Invalid signer'); require(otherSigner != msg.sender, 'Signers cannot be equal');
  says: the recovered address must be a signer other than the sender
  for:
  - action
  - evidence-1
  - justification
  - what
- id: eth-path
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  lines:
  - 373
  - 382
  has: 'address otherSigner = verifyMultiSig( toAddress, operationHash, signature, expireTime, sequenceId ); //
    Success, send the transaction (bool success, ) = toAddress.call{ value: value }(data);'
  says: sendMultiSig makes the call with value after verifyMultiSig passes
  for:
  - justification
  - what
- id: token-path
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  lines:
  - 498
  - 500
  has: verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId); TransferHelper.safeTransfer(tokenContractAddress,
    toAddress, value);
  says: sendMultiSigToken transfers tokens after verifyMultiSig passes
  for:
  - justification
  - what
- id: init
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  lines:
  - 251
  - 256
  has: function init(address[] calldata allowedSigners) external onlyUninitialized { require(allowedSigners.length
    == 3, 'Invalid number of signers');
  says: init sets exactly three signers and runs only before initialization
  for:
  - action
  - evidence-2
  - justification
  - what
- id: fixed-comment
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 247
  has: Signers CANNOT be changed once they are set
  says: 'the code''s own note: signers cannot be changed once set'
  for:
  - action
  - evidence-2
- id: initialized
  call: '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  fn: initialized()(bool)
  is: true
  says: init has run on this wallet, so it cannot run again
  for:
  - action
  - evidence-2
  - justification
  - what
- id: clone
  bytecode: '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  has: 363d3d373d3d3d363d73e8e847cf573fc8ed75621660a36affd18c543d7e5af4
  says: the wallet is an EIP-1167 clone whose target 0xe8e847cf is fixed in its code
  for:
  - action
  - evidence-2
  - justification
  - what
- id: noupgrade
  selector: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  fn: upgradeTo(address)
  absent: true
  says: the clone's target has no upgradeTo function
  for:
  - action
  - evidence-2
  - justification
  - what
- id: noupgrade2
  selector: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: the clone's target has no upgradeToAndCall function
  for:
  - evidence-2
  - what
- id: signer-a
  call: '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  fn: isSigner(address)(bool)
  args:
  - '0xc08fb884576cc89957e9058ef11587c468c2952f'
  is: true
  says: 0xc08fb884 is a signer
  for:
  - evidence-3
  - what
- id: signer-b
  call: '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  fn: isSigner(address)(bool)
  args:
  - '0x7f3296fec75a4d10adbafff0374f1c2c7258f877'
  is: true
  says: 0x7f3296fe is a signer
  for:
  - evidence-3
  - what
- id: signer-c
  call: '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  fn: isSigner(address)(bool)
  args:
  - '0x0e4d24afbdc8d7286a94eebc70732071b0ad75bb'
  is: true
  says: 0x0e4d24af is a signer; with the other two, the three that init set
  for:
  - what
- id: code-a
  code: '0xc08fb884576cc89957e9058ef11587c468c2952f'
  is: empty
  says: signer 0xc08fb884 has no code
  for:
  - what
- id: code-b
  code: '0x7f3296fec75a4d10adbafff0374f1c2c7258f877'
  is: empty
  says: signer 0x7f3296fe has no code
  for:
  - what
- id: code-c
  code: '0x0e4d24afbdc8d7286a94eebc70732071b0ad75bb'
  is: empty
  says: signer 0x0e4d24af has no code
  for:
  - what
- id: sender-nonce
  nonce: '0xc08fb884576cc89957e9058ef11587c468c2952f'
  is: 226833
  says: signer 0xc08fb884 has sent 226,833 transactions, so its public key is on chain
  for:
  - evidence-3
  - what
- id: exposed-tx
  tx: '0x3f3b56cc782d17b5a2e281269f6bc9d35f09622c5e544b699b1b2db884dd5799'
  to: '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  ok: true
  says: a successful sendMultiSigToken to this wallet, sent by 0xc08fb884, with a co-signature in its calldata
  for:
  - evidence-3
  - what
- id: exposed
  call: '0x0000000000000000000000000000000000000001'
  data: '0x1b582b2e5b61a901ef3ae42cfa4b002782f83f8067b7bcfc24c5ebd588c7c0e7000000000000000000000000000000000000000000000000000000000000001cf1179d3e706146eaa46bfab11106fd33e019bccf986c6452a057afd8bf11779445816c977bb800c8694c2ca651e04e35d01a2bd7e74274710fecc4a3959c8597'
  is: '0x0000000000000000000000007f3296fec75a4d10adbafff0374f1c2c7258f877'
  says: the co-signature in that calldata recovers to signer 0x7f3296fe, exposing that key
  for:
  - evidence-3
  - what
- id: safemode
  call: '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  fn: safeMode()(bool)
  is: false
  says: safe mode is off
  for:
  - notes
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x100ae042ef0ea159ecc3513e9a378ff21f3829ba'
  is: 5506579156873983428830
  says: the wallet holds 5,506.58 ETH
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
  pattern: PQ-12
reviews:
- who: r-100ae042, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 're-rated: A 2-of-3 WalletSimple clone (verified source) whose three signers are fixed, with no setter and
    no upgrade; two of its three keys have signed on-chain. MEDIUM, PQ-12 (the old file rated 23 wallets together
    as HIGH; a wallet is rated as one wallet): two recovered signer keys empty it, and its own signers can move
    the funds to a wallet that takes post-quantum signers. Author A-100ae042; refuter R-100ae042 agreed with no
    objection; the reader changed nothing. The refuter''s remark, that the header says activity is not established
    while the dossier counts 8,311 calling transactions in 90 days, is a gap of the renderer, not of this card.'
related: []
---

## What happens

This multisig pays out when one of its three signers sends the transaction and a second signer's ECDSA signature checks out. All three signers are ordinary key accounts, and two have signed on chain. A quantum attacker with those two keys can empty it; neither the signers nor the code can change.

## Evidence

- [verifyMultiSig](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code) recovers the second signer with ecrecover and requires it to be a signer other than the sender.
- [init](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code) sets the signers once and has run; this wallet is a fixed clone of code with no upgrade function.
- [A transaction](https://etherscan.io/tx/0x3f3b56cc782d17b5a2e281269f6bc9d35f09622c5e544b699b1b2db884dd5799) carries signer 0x7f3296fe's signature; the sending signer has sent 226,833 transactions.

## Reviewer notes

### Mechanism

sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner (msg.sender must be a signer, line 310) and call verifyMultiSig (lines 527-550), which takes otherSigner from recoverAddressFromSignature (plain ecrecover over a 65-byte signature, line 599), requires isSigner(otherSigner) and otherSigner != msg.sender (lines 545-547), then the ETH call (line 382), token transfer (line 500) or batch runs. No branch asks a signer contract (no ERC-1271). The signers mapping is written only in init (lines 251-258: exactly three, onlyUninitialized); initialized() is true at the block. The address is a 45-byte EIP-1167 clone with its target 0xe8e847cf fixed in its code; the target has no upgrade selector. Signers at the block: 0xc08fb884 (sends this wallet's transactions; nonce 226,833), 0x7f3296fe (the co-signer recovered in this wallet's transactions; its signature in tx 0x3f3b56cc recovers through the precompile at the block), 0x0e4d24af (nonce 0, not seen recovered). All three have no code. With the keys of 0xc08fb884 and 0x7f3296fe a quantum attacker sends sendMultiSig with a forged co-signature, a fresh sequence id (next is 19,689) and its own expiry. Safe mode (off at the block) would still let a signer address receive, so it does not stop that.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for a signer with code: recoverAddressFromSignature (lines 566-600) and verifyMultiSig (lines 527-550) have none.
- Ruled out: implementation never used alone: this address is an initialized clone in use (initialized() true; tx 0x3f3b56cc from signer 0xc08fb884 at block 26,344,390 succeeded).
- Ruled out: a way to replace signers or code: signers are written only in init (line 256), which is onlyUninitialized and has run; the clone target is fixed in the 45-byte code and has no upgradeTo or upgradeToAndCall selector.
- Ruled out: an outflow without the co-signature: every ETH, token and batch send goes through verifyMultiSig; flushForwarderTokens only pulls a forwarder's tokens into the wallet.
- Ruled out: safe mode as protection: safeMode() is false at the block, and in safe mode sends to a signer address still pass (line 537), which the attacker's sending key is.
- Ruled out: rating HIGH (old card): it rested on 23 wallets' owner groups together; one wallet is rated alone, and its fix (two of its own signers moving the funds to a new wallet) needs no protocol change, so MEDIUM by the exposure table.
- Ruled out: an EIP-8151 notice: under EIP-8151 a signer whose account takes real code can still send but no longer co-sign; that migration notice is a separate issue and is not folded into this card.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
