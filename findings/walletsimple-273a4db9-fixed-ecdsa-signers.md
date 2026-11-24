---
id: walletsimple-273a4db9-fixed-ecdsa-signers
format: 2
title: Multisig wallet trusts three fixed ECDSA signer keys to move its funds
status: confirmed
severity: MEDIUM
justification: Two forged signer keys can empty it; the signers and the code cannot change, so the fix is moving
  the funds out.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  name: WalletSimple
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 37025289
  basis: held
activity:
  txs_90d: 120
impact: funds-loss
action: Move the funds to a new wallet whose signers can use post-quantum keys; this wallet's three signers cannot
  be replaced.
evidence_level: source
checks:
- id: clone
  code: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  is: contract
  bytes: 45
  says: the address is a 45-byte clone
  for:
  - evidence-2
- id: clone-target
  bytecode: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  has: 363d3d373d3d3d363d73e5dcdc13b628c2df813db1080367e929c1507ca05af4
  says: the clone delegates every call to the wallet code at 0xe5dcdc13, fixed in its own code
  for:
  - action
  - evidence-2
  - justification
  - what
- id: no-upgrade
  selector: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  fn: upgradeTo(address)
  absent: true
  says: the wallet code has no upgrade function
  for:
  - action
  - justification
  - what
- id: no-upgrade-call
  selector: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: the wallet code has no upgradeToAndCall function
  for:
  - justification
  - what
- id: onlysigner
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: require(isSigner(msg.sender), 'Non-signer in onlySigner method');
  says: the sender of a transfer must be a listed signer
  line: 137
  for:
  - evidence-1
  - evidence-3
  - what
- id: send-eth
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: '(bool success, ) = toAddress.call{ value: value }(data);'
  says: sendMultiSig verifies the co-signer, then sends ETH or makes any call from the wallet
  lines:
  - 201
  - 211
  for:
  - action
  - what
- id: token
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: TransferHelper.safeTransfer(tokenContractAddress, toAddress, value);
  says: sendMultiSigToken verifies the co-signer, then transfers tokens
  lines:
  - 326
  - 328
  for:
  - action
  - what
- id: recover
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: address otherSigner = recoverAddressFromSignature(operationHash, signature);
  says: the co-signer is the address recovered from the signature
  line: 438
  for:
  - evidence-1
  - justification
  - what
- id: cosigner-listed
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: require(isSigner(otherSigner), 'Invalid signer');
  says: the recovered co-signer must be a listed signer
  line: 449
  for:
  - evidence-1
  - what
- id: distinct
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: require(otherSigner != msg.sender, 'Signers cannot be equal');
  says: 'the co-signer must differ from the sender: two signer keys move funds'
  line: 451
  for:
  - evidence-1
  - evidence-3
  - justification
  - what
- id: ecrecover
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: return ecrecover(operationHash, v, r, s);
  says: the signature is checked with ecrecover (ECDSA)
  line: 546
  for:
  - evidence-1
  - what
- id: three
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: require(allowedSigners.length == 3, 'Invalid number of signers');
  says: init takes exactly three signers
  line: 78
  for:
  - evidence-2
  - what
- id: once
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  has: Signers CANNOT be changed once they are set
  says: init sets the signers, and the code states they cannot be changed
  lines:
  - 73
  - 82
  for:
  - action
  - evidence-2
  - justification
  - what
- id: initialized
  call: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  fn: initialized()(bool)
  is: true
  says: this wallet has been initialized
  for:
  - evidence-2
  - what
- id: init-closed
  call: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  fn: init(address[])
  args:
  - - '0x1111111111111111111111111111111111111111'
    - '0x1111111111111111111111111111111111111111'
    - '0x1111111111111111111111111111111111111111'
  from: '0x1111111111111111111111111111111111111111'
  reverts_with: Contract already initialized
  says: init cannot run again, so the signers cannot be set anew
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-a
  call: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  fn: isSigner(address)(bool)
  args:
  - '0x3a1ec84c16a1ff604f0d97e1004068e3814b1586'
  is: true
  says: 0x3a1ec84c is a signer
  for:
  - what
- id: signer-b
  call: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  fn: isSigner(address)(bool)
  args:
  - '0xa4f3f34c5c77153125dfb1a190897e9d4b9ebd7d'
  is: true
  says: 0xa4f3f34c is a signer
  for:
  - what
- id: signer-c
  call: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  fn: isSigner(address)(bool)
  args:
  - '0xecfe7d4068400cb544779059a08a1926083ce7de'
  is: true
  says: 0xecfe7d40 is a signer
  for:
  - what
- id: eoa-a
  code: '0x3a1ec84c16a1ff604f0d97e1004068e3814b1586'
  is: empty
  says: signer 0x3a1ec84c has no code
  for:
  - what
- id: eoa-b
  code: '0xa4f3f34c5c77153125dfb1a190897e9d4b9ebd7d'
  is: empty
  says: signer 0xa4f3f34c has no code
  for:
  - what
- id: eoa-c
  code: '0xecfe7d4068400cb544779059a08a1926083ce7de'
  is: empty
  says: signer 0xecfe7d40 has no code
  for:
  - what
- id: sender-nonce
  nonce: '0x3a1ec84c16a1ff604f0d97e1004068e3814b1586'
  min: 165000
  says: signer 0x3a1ec84c has sent more than 165,000 transactions, so its public key is on-chain
  for:
  - what
- id: nonsigner-send
  call: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  fn: sendMultiSig(address,uint256,bytes,uint256,uint256,bytes)
  args:
  - '0x1111111111111111111111111111111111111111'
  - '1'
  - 0x
  - '9999999999'
  - '189'
  - '0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x1111111111111111111111111111111111111111'
  reverts_with: Non-signer in onlySigner method
  says: a transfer sent by a non-signer is refused
  for:
  - what
- id: signer-badsig
  call: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  fn: sendMultiSig(address,uint256,bytes,uint256,uint256,bytes)
  args:
  - '0x1111111111111111111111111111111111111111'
  - '1'
  - 0x
  - '9999999999'
  - '189'
  - '0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x3a1ec84c16a1ff604f0d97e1004068e3814b1586'
  reverts_with: Invalid signer
  says: a transfer sent by a signer without a valid co-signer's ECDSA signature is refused
  for:
  - evidence-1
  - what
- id: no-1271
  bytecode: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  has: 1626ba7e
  absent: true
  says: the wallet code holds no ERC-1271 isValidSignature selector (0x1626ba7e)
  for:
  - evidence-1
- id: no-1271-legacy
  bytecode: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  has: 20c13b0b
  absent: true
  says: the wallet code holds no legacy isValidSignature selector (0x20c13b0b)
  for:
  - evidence-1
- id: cosign-tx
  tx: '0xe296dfca1f59c9705595ff392e8157a987cf46793dc2228ee374b08044fe1edc'
  to: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  ok: true
  says: 'a sendMultiSig of this wallet succeeded at block 26,356,037: one signer sent it, another''s ECDSA signature
    is in its input'
  for:
  - evidence-3
  - what
- id: safe-mode-off
  call: '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  fn: safeMode()(bool)
  is: false
  says: 'safe mode is off: transfers to any address are open'
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x273a4db9f7cb388ec216df8c347f0529b22f4bd8'
  is: '20517627010001000000005'
  says: the wallet holds 20,517.63 ETH
  for:
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
reviews:
- who: r-273a4db9, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 're-rated: A fixed 2-of-3 WalletSimple clone (verified source) holding 20,517.63 ETH: one-time init, no
    rotation, no upgrade, no ERC-1271 path, safe mode off. MEDIUM, PQ-12 (was HIGH for 23 wallets together): two
    recovered signer keys empty it; the fix is the signers moving the funds to a new wallet. Two signers'' keys
    are public on-chain; the third has sent no transaction and is not shown to have co-signed, so the card claims
    two. Author A-273a4db9; refuter R-273a4db9 recomputed the operation hash of the cited transfer, recovered the
    co-signer itself and agreed with no objection; the reader changed nothing. The project and whose funds stay
    empty: nothing checkable names BitGo.'
related: []
---

## What happens

This wallet moves its ETH and tokens when one of its three signers sends the transfer and a second signer signs it with ECDSA. The signers were set once and cannot be replaced. A quantum attacker who derives two signers' private keys can empty it; two of the keys have already signed on-chain.

## Evidence

- [sendMultiSig](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) needs a signer as sender and a second signer recovered with ecrecover; no contract signature counts.
- [This wallet](https://etherscan.io/address/0x273a4db9f7cb388ec216df8c347f0529b22f4bd8) is a fixed clone of that code; init took three signers and refuses to run again.
- [A transfer from this wallet](https://etherscan.io/tx/0xe296dfca1f59c9705595ff392e8157a987cf46793dc2228ee374b08044fe1edc) was sent by one signer and carries another signer's ECDSA signature.

## Reviewer notes

### Mechanism

The address is a 45-byte EIP-1167 clone of 0xe5dcdc13 (WalletSimple, verified). sendMultiSig, sendMultiSigBatch and sendMultiSigToken are onlySigner (line 137) and call verifyMultiSig (lines 431-454): otherSigner = ecrecover of the operation hash (all gas, line 546), then safe mode, expiry, sequence window, isSigner(otherSigner) and otherSigner != msg.sender; then the call, ETH batch or token transfer runs. signers is written only in init (line 82): exactly three non-zero addresses, onlyUninitialized; this wallet is initialized and init reverts. No function changes a signer, the clone target is fixed and the wallet code has no upgrade function. Signers at the block, all without code: 0x3a1ec84c (nonce 165,690, sender of the cited transfer), 0xecfe7d40 (its co-signer per the Transacted event, nonce 0), 0xa4f3f34c (nonce 0). A quantum attacker takes the sender's key from its transactions and the co-signer's from its signature in calldata, then sends sendMultiSig to itself.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: the wallet code holds neither 0x1626ba7e nor 0x20c13b0b; verifyMultiSig has no code-size branch.
- Ruled out: an unused implementation: an initialized clone holding 20,517.63 ETH, with a successful sendMultiSig at block 26,356,037.
- Ruled out: replacing signers or upgrading: init reverts 'Contract already initialized'; the clone target is a constant; no upgradeTo or upgradeToAndCall.
- Ruled out: a way out without the co-signer: every outflow goes through verifyMultiSig; flush functions pull tokens in; safe mode (off) only limits recipients to signers.
- Ruled out: the old HIGH counted 23 wallets; as one wallet the fix is two signers moving the funds to a new wallet: MEDIUM.
- Ruled out: project bitgo: neither the verified source nor the chain names BitGo, so it is left out.
- Ruled out: an EIP-8151 regression: the recovery gets all gas; the family's replay (tx 0x5cdbc775…, another wallet) succeeds under EIP-8151 alone.
- Ruled out: the third signer 0xa4f3f34c has sent nothing and is not shown to have co-signed, so the card claims two exposed keys.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
