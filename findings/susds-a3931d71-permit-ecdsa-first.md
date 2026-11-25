---
id: susds-a3931d71-permit-ecdsa-first
format: 2
title: sUSDS still accepts a holder's old ECDSA key after it moves to post-quantum
status: confirmed
severity: MEDIUM
justification: Holders' shares stay forgeable after they migrate in place; the fix is a governance upgrade.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa3931d71877c0e7a3148cb7eb4463524fec27fbd'
  name: SUsds
  code: verified
  code_url: https://etherscan.io/address/0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0#code
  proxy_of: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 3682774103
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the implementation to ask an owner that has code through ERC-1271 only, and use ECDSA only for owners
  with no code.
evidence_level: source
checks:
- id: len65
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  line: 415
  has: if (signature.length == 65) {
  says: the ECDSA branch is taken for every 65-byte signature
  for:
  - evidence-1
  - what
- id: ecdsa-first
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  lines:
  - 424
  - 426
  has: if (signer == ecrecover(digest, v, r, s)) { return true; }
  says: a signature that recovers to the owner is accepted at once
  for:
  - action
  - evidence-1
  - justification
  - what
- id: erc1271-after
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  lines:
  - 429
  - 431
  has: if (signer.code.length > 0) { (bool success, bytes memory result) = signer.staticcall(
  says: ERC-1271 is asked only after the ECDSA branch did not return
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-check
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  line: 466
  has: require(_isValidSignature(owner, digest, signature), "SUsds/invalid-permit");
  says: permit requires _isValidSignature for the owner
  for:
  - evidence-1
  - what
- id: permit-sets
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  line: 468
  has: allowance[owner][spender] = value;
  says: a valid permit sets the spender's allowance over the owner's shares
  for:
  - what
- id: transferfrom-allowance
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  lines:
  - 253
  - 259
  has: uint256 allowed = allowance[from][msg.sender];
  says: transferFrom moves the owner's shares against the allowance
  for:
  - what
- id: burn-allowance
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  lines:
  - 302
  - 308
  has: uint256 allowed = allowance[owner][msg.sender];
  says: withdraw and redeem burn the owner's shares against the allowance and pay USDS to the receiver
  for:
  - what
- id: mint
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  lines:
  - 287
  - 290
  has: balanceOf[receiver] = balanceOf[receiver] + shares;
  says: deposited USDS is credited as shares to the depositor's receiver
  for:
  - evidence-2
  - whose
- id: usds-held
  call: '0xdc035d45d973e3ec169d2276ddab16f1e407384f'
  fn: balanceOf(address)(uint256)
  args:
  - '0xa3931d71877c0e7a3148cb7eb4463524fec27fbd'
  is: '3682835265665998289416471080'
  says: the vault holds about 3.68 billion USDS
  for:
  - evidence-2
  - whose
- id: auth
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  line: 104
  has: require(wards[msg.sender] == 1, "SUsds/not-authorized");
  says: auth admits only wards
  for:
  - evidence-3
- id: upgrade-auth
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: src/SUsds.sol
  line: 132
  has: function _authorizeUpgrade(address newImplementation) internal override auth {}
  says: upgrades are allowed to wards
  for:
  - action
  - evidence-3
  - justification
- id: uups
  source: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  file: UUPSUpgradeable.sol
  lines:
  - 92
  - 93
  has: function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy
    { _authorizeUpgrade(newImplementation);
  says: upgradeToAndCall replaces the implementation after _authorizeUpgrade
  for:
  - action
  - evidence-3
  - justification
- id: impl-slot
  storage: '0xa3931d71877c0e7a3148cb7eb4463524fec27fbd'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0'
  says: the proxy runs the SUsds implementation read here
  for:
  - notes
- id: ward-pause
  call: '0xa3931d71877c0e7a3148cb7eb4463524fec27fbd'
  fn: wards(address)(uint256)
  args:
  - '0xbe8e3e3618f7474f8cb1d074a26affef007e98fb'
  is: 1
  says: Sky's pause proxy is a ward
  for:
  - action
  - evidence-3
  - justification
- id: pause-owner
  call: '0xbe8e3e3618f7474f8cb1d074a26affef007e98fb'
  fn: owner()(address)
  is: '0xbe286431454714f511008713973d3b053a2d38f3'
  says: the pause proxy is owned by DSPause
  for:
  - evidence-3
- id: pause-delay
  call: '0xbe286431454714f511008713973d3b053a2d38f3'
  fn: delay()(uint256)
  is: 172800
  says: DSPause delays every action by 48 hours
  for:
  - evidence-3
- id: pause-authority
  call: '0xbe286431454714f511008713973d3b053a2d38f3'
  fn: authority()(address)
  is: '0x929d9a1435662357f54adcf64dcee4d6b867a6f9'
  says: DSPause takes its authority from the Chief (governance vote)
  for:
  - notes
- id: spbeam-ward
  call: '0xa3931d71877c0e7a3148cb7eb4463524fec27fbd'
  fn: wards(address)(uint256)
  args:
  - '0x36b072ed8afe665e3aa6daba79decbec63752b22'
  is: 1
  says: SPBEAM is also a ward
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
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-2
reviews:
- who: r-a3931d71, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-2): sUSDS''s _isValidSignature returns on an ECDSA match before
    it reaches ERC-1271, so a holder that migrates in place stays forgeable; the fix (ERC-1271 only for owners with
    code) is a ward-gated UUPS upgrade through Sky''s 48-hour pause proxy. Token supply affected (upper bound) $3.68B.
    Both refuters agree; Claude read the sheet.'
related: []
---

## What happens

sUSDS lets a holder approve a spender by signature; the spender can then move or redeem the holder's shares. It tries the old ECDSA key before asking the holder's account, so an address that moves to post-quantum signing in place can still be forged with that key.

## Evidence

- [permit](https://etherscan.io/address/0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0#code) accepts a signature that recovers to the owner before it asks the owner's contract (ERC-1271).
- The [vault](https://etherscan.io/address/0xa3931d71877c0e7a3148cb7eb4463524fec27fbd) holds about 3.68 billion USDS against its holders' shares.
- Sky's [pause proxy](https://etherscan.io/address/0xbe8e3e3618f7474f8cb1d074a26affef007e98fb), owned by a timelock with a 48-hour delay, is a ward and can upgrade the code.

## Reviewer notes

### Mechanism

The address is an ERC-1967 proxy (implementation slot = 0x4e7991e5...61e0, SUsds). permit(owner, spender, value, deadline, bytes) builds the EIP-712 digest and requires _isValidSignature(owner, digest, signature) (line 466), then sets allowance[owner][spender] (line 468); the (v, r, s) overload packs and forwards. _isValidSignature (lines 410-437): for a 65-byte signature it returns true when ecrecover(digest, v, r, s) equals the owner (lines 415-426); only otherwise, when the owner has code, it asks isValidSignature (ERC-1271) with the full bytes. So an owner whose address takes code (an EIP-7702 delegation or an in-place post-quantum account) is still accepted with its old secp256k1 key, which a quantum computer can recover from any signature it published. The allowance lets the spender transferFrom (line 254) or withdraw/redeem through _burn (lines 302-308) the owner's shares. Upgrades: upgradeToAndCall (UUPSUpgradeable lines 92-93) calls _authorizeUpgrade, which is gated by auth = wards[msg.sender] == 1 (lines 104, 132). wards(pause proxy 0xbe8e...98fb) = 1; the pause proxy's owner() is DSPause 0xbe28...38f3, whose authority() is the Chief 0x929d...a6f9 and delay() is 172,800 s. Rated by the quantum-exposure table: users' own funds stay forgeable after migrating, fixable by a contract upgrade through a governance vote (MEDIUM). EIP-8151 is not assumed by this category.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path that protects migrated holders: it exists (lines 429-436) but is reached only after the ECDSA branch failed, so a forged ECDSA signature never reaches it.
- Ruled out: a direct path that makes permit unnecessary: approve (lines 274-280) exists, but it does not stop anyone from submitting a forged permit; the risk is forgery, not a lost shortcut.
- Ruled out: unused implementation: this address is the proxy in use; its implementation slot holds 0x4e7991e5...61e0 at the block, and the study's two-week window shows 42 recoveries of 27 distinct signers here.
- Ruled out: the EIP-8151 replay of 0xfed7d7c4...9401339 is not cited: its root call (selector 0x6d7b7040) is a router call whose other steps I could not read, and they may check the same signer (for example a USDS permit).
- Ruled out: SPBEAM 0x36b072ed...2b22 is also a ward (wards = 1); I did not read whether its code can call upgradeToAndCall, and the rating does not depend on it.
- Ruled out: USDS 0xdc035d45...384f has the same signature order and was on the old card; it is its own row and is not described here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
