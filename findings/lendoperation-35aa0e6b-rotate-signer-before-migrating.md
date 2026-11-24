---
id: lendoperation-35aa0e6b-rotate-signer-before-migrating
format: 2
title: Token whitelist signer must be replaced before its account moves to real code
status: confirmed
severity: INFORMATIONAL
justification: Works until the backend key's account moves to real code; the owner can set a new key or whitelist
  users directly.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  name: LendOperation
  code: verified
  code_url: https://etherscan.io/address/0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be#code
  copies: 3
  family: a6797cf5464c80027d30f28c5686ffa4
  upgradeable: 'no'
  admin: '0xbfbaff7afe2bea4fd130c4965b6eb28bd1da4061'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Call updateBackendSigner with a new key before moving the current backend signer's account to real code.
evidence_level: source
checks:
- id: whitelist-sig
  source: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  file: src/opLend.sol
  lines:
  - 56
  - 60
  has: bool isSignatureValid = verifySignature(user, nonce, signature);
  says: whitelistUser, open to any caller, whitelists the user only if the signature verifies
  for:
  - evidence-1
  - what
- id: recover
  source: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  file: src/opLend.sol
  line: 98
  has: return ecrecover(ethSignedMessageHash, v, r, s);
  says: the signer is recovered with the ecrecover precompile
  for:
  - evidence-1
  - what
- id: compare
  source: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  file: src/opLend.sol
  line: 74
  has: bool isValid = recovered == backendSigner;
  says: the recovered address must equal the stored backend signer; there is no other path
  for:
  - evidence-1
  - justification
  - what
- id: rotate
  source: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  file: src/opLend.sol
  lines:
  - 52
  - 54
  has: backendSigner = newSigner;
  says: updateBackendSigner, onlyOwner, overwrites the stored signer
  for:
  - action
  - evidence-3
  - justification
  - what
- id: admin-list
  source: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  file: src/opLend.sol
  lines:
  - 62
  - 64
  has: function whitelistUserAdmin(address user, bool state) public onlyOwner {
  says: the owner can whitelist a user without a signature
  for:
  - evidence-3
  - justification
- id: transfer-gate
  source: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  file: src/opLend.sol
  lines:
  - 104
  - 105
  has: require(whitelisted[to] == true, "Destination address is not whitelisted");
  says: a transfer needs both the sender and the receiver whitelisted
  for:
  - what
- id: signer
  storage: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  slot: '0xa'
  is: '0x000000000000000000000000499603a70dc410c50a435d0cd40c656bef4685fd'
  says: backendSigner (slot 10) is 0x499603a70dc410c50a435d0cd40c656bef4685fd
  for:
  - action
  - evidence-2
- id: signer-code
  code: '0x499603a70dc410c50a435d0cd40c656bef4685fd'
  is: empty
  says: the backend signer's account has no code at the block
  for:
  - evidence-2
- id: owner
  call: '0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be'
  fn: owner()(address)
  is: '0xbfbaff7afe2bea4fd130c4965b6eb28bd1da4061'
  says: the owner that can replace the signer is set, not renounced
  for:
  - action
  - evidence-3
  - justification
  - what
- id: owner-code
  code: '0xbfbaff7afe2bea4fd130c4965b6eb28bd1da4061'
  is: contract
  bytes: 8643
  says: the owner is a contract of 8,643 bytes
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
- who: r-35aa0e6b, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Wording pass (''real code''); a fresh refuter agrees on every part; Claude read the changed sentences.
    Kept as before.'
related: []
---

## What happens

This token moves only between whitelisted addresses, and anyone can whitelist a user with an ECDSA signature from one stored backend key. If that key's account moves to real code, signed whitelisting stops until the owner sets a new key.

## Evidence

- The [verified source](https://etherscan.io/address/0x35aa0e6b72a57965eef2dde4025f2bc73fd3d6be#code) whitelists a user only when the recovered ECDSA signer equals the stored backend key.
- The [stored key](https://etherscan.io/address/0x499603a70dc410c50a435d0cd40c656bef4685fd) is an account without code today.
- The [owner](https://etherscan.io/address/0xbfbaff7afe2bea4fd130c4965b6eb28bd1da4061) can replace the key with updateBackendSigner and can whitelist users directly.

## Reviewer notes

### Mechanism

whitelistUser (src/opLend.sol, lines 56-60) is open to any caller. It calls verifySignature (66-81), which hashes (this contract, chain id, user, nonce) with the Ethereum signed-message prefix, recovers the signer with the ecrecover builtin (line 98, all gas forwarded) and requires recovered == backendSigner (line 74); on success the nonce is marked used and whitelisted[user] is set. The whitelist gates transfer, transferFrom, send and _debit. backendSigner is an internal variable at storage slot 10 (slots 0-5 Ownable and ERC20, 6 peers, 7 preCrime or enforcedOptions, 8 the other, 9 msgInspector); it holds 0x4996...85fd, which has no code and nonce 0 at the block. updateBackendSigner (52-54, onlyOwner) overwrites it. The owner, 0xbfba...4061, is an 8,643-byte contract that I did not identify (it reverts on getOwners and getThreshold, so it is not a Safe). The owner can also whitelist without a signature: whitelistUserAdmin (62-64), and mint and _credit whitelist the receiver. The signature is checked once and its result is stored, so nothing is rechecked later.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for a signer with code: the only check is recovered == backendSigner (line 74); no isValidSignature anywhere in the source.
- Ruled out: an unused implementation: the tool found no proxy slots and no delegate-call; this address has its own owner, signer, name (opLEND-2) and a total supply of 272,311,001,453 units.
- Ruled out: an unset or contract key: slot 10 holds 0x4996...85fd, with empty code and nonce 0 at the block (a key that never sent a transaction is presumed live).
- Ruled out: a setter nobody can call: updateBackendSigner is onlyOwner and owner() is a contract with code, not zero or renounced; what that contract is, I did not establish.
- Ruled out: a closed path: the contract has no pause and no flag that disables whitelistUser.
- Ruled out: a direct path for the user: a user cannot whitelist itself without the signature; only the owner can (whitelistUserAdmin, mint) or an incoming cross-chain credit.
- Ruled out: a later recheck: the whitelist flag is stored on success and the nonce marked used; the signature is not read again.
- Ruled out: a fixed gas amount: the recovery is the Solidity ecrecover builtin, no constant gas; the scanner found no gas constant.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
