---
id: walletsimple-d07c7fd3-wallet-ecdsa-signers
format: 2
title: Multisig wallet with fixed ECDSA signers can be drained by a quantum attacker
status: confirmed
severity: MEDIUM
justification: Two signers can move the funds to a new wallet, but the signers and the code cannot change, so the
  funds must move.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd07c7fd3598750fd770c20e89ae005f65f189fe4'
  name: WalletSimple
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 18520321
  basis: held
activity: {}
impact: funds-loss
action: Have two of the signers move the funds to a wallet whose signers can be replaced with post-quantum keys.
evidence_level: source
checks:
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xd07c7fd3598750fd770c20e89ae005f65f189fe4'
  is: '10200005000000000000000'
  says: the wallet holds 10,200.005 ETH
  for:
  - what
- id: onlysigner
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 137
  has: require(isSigner(msg.sender), 'Non-signer in onlySigner method');
  says: the sender of a send must be a signer
  for:
  - action
  - evidence-1
  - what
- id: recover
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 438
  has: address otherSigner = recoverAddressFromSignature(operationHash, signature);
  says: the second signer is recovered from the signature
  for:
  - evidence-1
  - what
- id: ecrecover
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 546
  has: return ecrecover(operationHash, v, r, s);
  says: the recovery is ecrecover
  for:
  - evidence-1
  - what
- id: issigner
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  lines:
  - 449
  - 451
  has: require(isSigner(otherSigner), 'Invalid signer');
  says: the recovered address must be a signer other than the sender
  for:
  - evidence-1
  - what
- id: send
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  lines:
  - 201
  - 211
  has: '(bool success, ) = toAddress.call{ value: value }(data);'
  says: after verifyMultiSig, sendMultiSig sends any value and call to any address
  for:
  - action
  - what
- id: init
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 77
  has: function init(address[] calldata allowedSigners) external onlyUninitialized {
  says: init sets the signers and can run only before initialization
  for:
  - action
  - evidence-2
  - justification
  - what
- id: written
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 82
  has: signers[allowedSigners[i]] = true;
  says: the only write to the signers mapping, inside init
  for:
  - action
  - evidence-2
  - justification
  - what
- id: initialized
  call: '0xd07c7fd3598750fd770c20e89ae005f65f189fe4'
  fn: initialized()(bool)
  is: 'true'
  says: the wallet is initialized, so init cannot run again
  for:
  - evidence-2
  - justification
- id: clone
  bytecode: '0xd07c7fd3598750fd770c20e89ae005f65f189fe4'
  has: 73e5dcdc13b628c2df813db1080367e929c1507ca05af4
  says: the wallet delegates to a fixed WalletSimple address written in its code
  for:
  - evidence-2
  - justification
- id: noupgrade
  selector: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  fn: upgradeTo(address)
  absent: true
  says: the implementation has no upgradeTo
  for:
  - evidence-2
  - justification
- id: noupgrade2
  selector: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: the implementation has no upgradeToAndCall
  for:
  - evidence-2
  - justification
- id: s1
  call: '0xd07c7fd3598750fd770c20e89ae005f65f189fe4'
  fn: isSigner(address)(bool)
  args:
  - '0xe8412e6f428f4142b78858db78e9eccce95d58e9'
  is: 'true'
  says: 0xe8412e6f... is a signer
  for:
  - what
- id: s2
  call: '0xd07c7fd3598750fd770c20e89ae005f65f189fe4'
  fn: isSigner(address)(bool)
  args:
  - '0x2c97ccca80373bee7fd9e8004a9206f3a7dd856e'
  is: 'true'
  says: 0x2c97ccca... is a signer
  for:
  - what
- id: s3
  call: '0xd07c7fd3598750fd770c20e89ae005f65f189fe4'
  fn: isSigner(address)(bool)
  args:
  - '0x7de549d09ca9189560e000cb816979676b686850'
  is: 'true'
  says: 0x7de549d0... is a signer
  for:
  - what
- id: c1
  code: '0xe8412e6f428f4142b78858db78e9eccce95d58e9'
  is: empty
  says: signer 0xe8412e6f... has no code
  for:
  - what
- id: c2
  code: '0x2c97ccca80373bee7fd9e8004a9206f3a7dd856e'
  is: empty
  says: signer 0x2c97ccca... has no code
  for:
  - what
- id: c3
  code: '0x7de549d09ca9189560e000cb816979676b686850'
  is: empty
  says: signer 0x7de549d0... has no code
  for:
  - what
- id: n3
  nonce: '0xe8412e6f428f4142b78858db78e9eccce95d58e9'
  min: 36096
  says: signer 0xe8412e6f... has sent at least 36,096 transactions, so its public key is public
  for:
  - evidence-3
  - what
- id: realtx
  tx: '0x228aead99c8e99eecc420a646c7e1c147668b9cee117bf9a35cd6e33f5383a5d'
  to: '0xd07c7fd3598750fd770c20e89ae005f65f189fe4'
  ok: true
  says: a successful send (sendMultiSigToken) from signer 0xe8412e6f... in which co-signer 0x2c97ccca... was recovered
  for:
  - evidence-3
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
  pattern: PQ-12
reviews:
- who: r-d07c7fd3, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Second refuter (D-028) agrees on every part. Both refuters agree; Claude read the sheet. MEDIUM,
    kept as before; whose money is not established.'
related: []
---

## What happens

This 2-of-3 wallet holds 10,200 ETH. To move funds, one signer sends the transaction and a second signer's ECDSA signature is checked. The three signers are plain keys set once, and two have exposed their public keys on chain. A quantum attacker who derives those two keys can send everything out.

## Evidence

- The [verified source](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) recovers the co-signer with ecrecover and requires it in the signer set; the sender must be a signer too.
- Signers are written only once, at [setup](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code); the wallet is a fixed clone of that code, which has no upgrade function.
- [A real send](https://etherscan.io/tx/0x228aead99c8e99eecc420a646c7e1c147668b9cee117bf9a35cd6e33f5383a5d) by one signer carries another signer's signature, from which its public key can be computed.

## Reviewer notes

### Mechanism

The address is a 45-byte EIP-1167 clone of WalletSimple 0xe5dcdc13..., fixed in its code. sendMultiSig, sendMultiSigBatch and sendMultiSigToken are onlySigner (msg.sender must be a signer, line 137) and call verifyMultiSig, which recovers otherSigner with ecrecover (lines 438, 546), requires isSigner(otherSigner) and otherSigner != msg.sender (lines 449-451), then sends ETH, a call or a token transfer. The signers mapping is written only in init (line 82), which is onlyUninitialized and needs exactly three signers; initialized() is true. No function removes or adds a signer. Signers at the block: 0xe8412e6f... (EOA, nonce 36,096: sends the transactions), 0x2c97ccca... (EOA, nonce 0, recovered as co-signer in real sends, e.g. tx 0x228aead9... sendMultiSigToken), 0x7de549d0... (EOA, nonce 0, no signature seen). Two keys are therefore exposed, and a CRQC holder with both can call sendMultiSig to itself. activateSafeMode does not help: safe mode allows sends to signer addresses, which the attacker controls. Rating (quantum-exposure rubric): step 1 funds can be taken; step 2 the fix is the wallet's signers (two of three) moving the funds to a new wallet, since signers and code cannot change; step 3 that is 'a new deployment that users move to / owners migrating' = MEDIUM. The old finding rated HIGH across 23 wallets ('many independent parties'); this row is one wallet with one signer group.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for a signer with code: verifyMultiSig and recoverAddressFromSignature have none (lines 431-454, 513-547).
- Ruled out: unused implementation: this address is an initialized clone holding 10,200 ETH with real sends, not the implementation.
- Ruled out: unset or contract keys: isSigner is true for all three addresses and each has empty code at the block (no EIP-7702 delegation).
- Ruled out: a signer setter or upgrade: signers are written only at line 82 inside init, which is onlyUninitialized; the clone target is fixed and the implementation has no upgradeTo or upgradeToAndCall selector.
- Ruled out: a closed path: safeMode is false at the block, and safe mode would still allow sends to a signer address the attacker controls.
- Ruled out: EIP-8151 side: a signer that moves its account to real code can no longer co-sign, and if all three do, nothing can leave; that is a separate migration notice (fixed wallet signers), not folded here. The dossier's replay is of another wallet and is not cited.
- Ruled out: project: the verified source does not name BitGo, so no project is stated.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
