---
id: cloneablewallet-01e0237f-rotate-signer-before-migrating
format: 2
title: Wallet keys stop signing once their accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a key's account takes real code; it rotates first, or still acts by sending if its
  cosigner signs.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x01e0237fddb7e169dcc34c724d4ef09cd7c2eff8'
  name: CloneableWallet
  label: 'deployed by Portto: Hot Wallet'
  code: verified
  code_url: https://etherscan.io/address/0xf946bcea25f1102314fe0a65d94a2f729418aef1#code
  proxy_of: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  copies: 1371
  family: 74ac18cec1fce043cede46c59c144b01
  upgradeable: 'no'
value:
  usd: 632
  basis: held
activity: {}
impact: liveness
action: Replace a key or cosigner via setAuthorized through the wallet, or emergencyRecovery, before its account
  takes real code.
evidence_level: source
checks:
- id: inv2
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: address signer = ecrecover(operationHash, v[0], r[0], s[0]);
  says: invoke2 recovers the signer and the cosigner from two ECDSA signatures
  lines:
  - 938
  - 939
  for:
  - evidence-1
  - justification
  - what
- id: inv2auth
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: require(requiredCosigner == signer || requiredCosigner == cosigner, "Invalid authorization.");
  says: invoke2 runs only when the recovered pair matches the stored authorization
  line: 956
  for:
  - evidence-1
  - what
- id: sendsigner
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: require(requiredCosigner == cosigner || requiredCosigner == msg.sender, "Invalid authorization.");
  says: invoke1SignerSends takes the authorized key from the caller and recovers only the cosigner
  lines:
  - 901
  - 905
  for:
  - evidence-1
  - justification
  - what
- id: sendcosigner
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: require(requiredCosigner == signer || requiredCosigner == msg.sender, "Invalid authorization.");
  says: invoke1CosignerSends recovers only the authorized key and takes the cosigner from the caller
  lines:
  - 845
  - 861
  for:
  - evidence-1
  - justification
  - what
- id: erc1271
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: if (address(authorizations[authVersion + uint256(signer)]) != cosigner) {
  says: isValidSignature approves a message for the wallet only from recovered signatures matching a stored pair
  lines:
  - 753
  - 774
  for:
  - what
- id: setauth
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: authorizations[authVersion + uint256(_authorizedAddress)] = _cosigner;
  says: setAuthorized adds, changes or removes an authorized key and its cosigner
  lines:
  - 618
  - 632
  for:
  - action
  - evidence-2
  - justification
  - what
- id: invoked
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: require(msg.sender == address(this), "must be called from `invoke()`");
  says: setAuthorized can only be called by the wallet itself, through one of its invoke functions
  line: 444
  for:
  - action
  - evidence-2
  - what
- id: recovery
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: authVersion += AUTH_VERSION_INCREMENTOR;
  says: emergencyRecovery, called by the recovery address, clears all keys and installs a new key pair
  lines:
  - 643
  - 653
  for:
  - action
  - evidence-2
  - what
- id: onlyrec
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: require(msg.sender == recoveryAddress, "sender must be recovery address");
  says: the recovery address acts by sending the call itself, with no signature
  line: 421
  for:
  - action
  - evidence-2
  - what
- id: inv0
  source: '0xf946bcea25f1102314fe0a65d94a2f729418aef1'
  file: CloneableWallet.sol
  has: require(address(authorizations[authVersion + uint256(msg.sender)]) == msg.sender, "Invalid authorization.");
  says: invoke0 lets a key with no cosigner act alone by sending, with no signature
  line: 816
  for:
  - what
- id: init
  call: '0x01e0237fddb7e169dcc34c724d4ef09cd7c2eff8'
  fn: initialized()(bool)
  is: true
  says: this wallet was initialized with its own keys
  for:
  - notes
- id: version
  call: '0x01e0237fddb7e169dcc34c724d4ef09cd7c2eff8'
  fn: authVersion()(uint256)
  is: '1461501637330902918203684832716283019655932542976'
  says: 'authVersion is still 1 << 160: no emergency recovery has run on this wallet'
  for:
  - notes
- id: recaddr
  call: '0x01e0237fddb7e169dcc34c724d4ef09cd7c2eff8'
  fn: recoveryAddress()(address)
  is: '0x25Ef0eA66a18C4E29fb843287C103d63B4F7bD4c'
  says: the recovery address set on this wallet
  for:
  - action
  - evidence-2
- id: reccode
  code: '0x25ef0ea66a18c4e29fb843287c103d63b4f7bd4c'
  is: empty
  says: 'the recovery address has no code: it is a plain key'
  for:
  - action
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-01e0237f, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Sent back once (the action could be stated; a key with real code acts only while its cosigner signs);
    the new card says both. A fresh refuter agrees; sheet read by Claude. Stays a candidate (current key pair and
    whose money not read).'
related: []
---

## What happens

The wallet moves funds when a key and its cosigner approve, each by an ECDSA signature or by sending the call itself. A key with real code stops signing, including message approvals; it is replaced through the wallet or by the recovery address.

## Evidence

- The [verified source](https://etherscan.io/address/0xf946bcea25f1102314fe0a65d94a2f729418aef1#code) checks the key and its cosigner by ECDSA against stored pairs; either one can send the call itself instead.
- Keys are replaced through the wallet itself, or by its [recovery address](https://etherscan.io/address/0x25ef0ea66a18c4e29fb843287c103d63b4f7bd4c), a plain key, which can reset them all.

## Reviewer notes

### Mechanism

The address is an EIP-1167 clone of CloneableWallet (Dapper wallet, version 1.1.0), initialized with its own state. Authorizations map an authorized key to its cosigner. invoke2 recovers both from ECDSA signatures; invoke1CosignerSends recovers the key and takes the cosigner from msg.sender; invoke1SignerSends takes the key from msg.sender and recovers the cosigner; invoke0 needs a key with no cosigner as msg.sender. isValidSignature (ERC-1271 for the wallet) recovers one or two signatures and checks the stored pair; it has no msg.sender alternative. Under EIP-8151 a key or cosigner whose account has real code no longer recovers: invoke2 and isValidSignature fail for it, and the one-signature paths work only if the migrated account itself sends the call. If both the key and its cosigner move to real code, only the recovery address can restore control. setAuthorized (onlyInvoked, so through an invoke) replaces a key or cosigner; emergencyRecovery/emergencyRecovery2 (msg.sender == recoveryAddress, no signature) clear all keys and set a new pair. At block 26,438,999: initialized, authVersion 1 << 160 (no recovery yet), recoveryAddress 0x25ef...bd4c with no code and nonce 0 (presumed live), 0.35 ETH held.

### Checks

- Header facts: this address alone, at block 26,438,999; 1,371 addresses run this code.
- Ruled out: erc1271: the wallet never asks its keys through ERC-1271; a key with real code is checked only by ecrecover or as msg.sender (lines 845-861, 895-905, 938-956).
- Ruled out: direct-path: a migrated key or cosigner can still act by sending the invoke call itself, but only while the other half of the pair still signs by ECDSA (or has no cosigner, via invoke0); if both take real code, only the recovery address restores the wallet.
- Ruled out: unused-implementation: this address is a clone with its own state, initialized() true and a recovery address set.
- Ruled out: breaks-by-itself: the recoveries use Solidity ecrecover with all remaining gas; the scan finds no constant gas (ec_gas_const null) and there are no replays or window recoveries for the family.
- Ruled out: rechecked-later: no signature is stored and checked again later; each invoke recovers and acts in one call.

### Questions

- Who holds this wallet's authorized key and cosigner (Portto's service or the wallet's user)? They are only in the wallet's events, which the gateway does not scan; whose stays unset until that is shown.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
