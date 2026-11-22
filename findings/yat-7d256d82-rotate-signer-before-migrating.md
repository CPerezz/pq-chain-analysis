---
id: yat-7d256d82-rotate-signer-before-migrating
format: 2
title: Yat's mint signer must be replaced before its account moves to real code
status: confirmed
severity: INFORMATIONAL
justification: Minting works until the signer's account takes real code; the owner can replace the key first with
  setSigner.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  name: YAT
  project: yat
  code: verified
  code_url: https://etherscan.io/address/0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2#code
  copies: 1
  upgradeable: 'no'
  admin: '0x2511df645f69290ecab08fa3947617fdee954066'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 293
  last: 2026-11-18
impact: liveness
action: Call setSigner with a new key before moving the current signer's account to real code.
evidence_level: source
checks:
- id: mint
  source: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  file: YAT.sol
  lines:
  - 129
  - 133
  has: require(_verifyMint(_token, _account, _expiry, _signature));
  says: mint reverts unless the mint signature verifies, then mints
  for:
  - evidence-1
  - justification
  - what
- id: verify-mint
  source: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  file: YAT.sol
  line: 590
  has: return _recoverSigner(_getEthSignedMessageHash(_hash), _signature) == signer();
  says: the recovered address must equal the stored signer
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  file: YAT.sol
  lines:
  - 583
  - 586
  has: return ecrecover(_ethSignedMessageHash, v, r, s);
  says: the signer is recovered with a bare ecrecover, with no branch for accounts with code
  for:
  - evidence-1
  - justification
  - what
- id: set-signer
  source: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  file: YAT.sol
  lines:
  - 120
  - 122
  has: info.signer = _signer;
  says: setSigner, restricted by _onlyOwner, overwrites the stored signer
  for:
  - action
  - evidence-3
  - justification
  - what
- id: only-owner
  source: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  file: YAT.sol
  lines:
  - 90
  - 93
  has: require(msg.sender == owner());
  says: _onlyOwner admits only the stored owner
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer
  call: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  fn: signer()(address)
  is: '0x87401fd9eb013d029d71ec057ef41ee70484e3c7'
  says: the stored mint signer at the block
  for:
  - evidence-2
  - what
- id: signer-code
  code: '0x87401fd9eb013d029d71ec057ef41ee70484e3c7'
  is: empty
  says: the signer's account has no code
  for:
  - evidence-2
- id: owner
  call: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  fn: owner()(address)
  is: '0x2511df645f69290ecab08fa3947617fdee954066'
  says: the owner that can call setSigner
  for:
  - action
  - evidence-3
  - justification
- id: owner-code
  code: '0x2511df645f69290ecab08fa3947617fdee954066'
  is: empty
  says: the owner is an account without code
  for:
  - evidence-3
  - justification
- id: supply
  call: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  fn: totalSupply()(uint256)
  is: 15210
  says: 15,210 tokens exist, so this address is in use itself
  for:
  - notes
- id: mint-internal
  source: '0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2'
  file: YAT.sol
  line: 462
  has: function _mint(string memory _token, address _account) internal {
  says: the minting routine is internal, reachable only through mint
  for:
  - evidence-1
  - what
- id: signer-nonce
  nonce: '0x87401fd9eb013d029d71ec057ef41ee70484e3c7'
  is: 0
  says: the signer has never sent a transaction; presumed live
  for:
  - notes
- id: owner-nonce
  nonce: '0x2511df645f69290ecab08fa3947617fdee954066'
  is: 4
  says: the owner account has sent 4 transactions
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This contract mints a Yat name token only when the request carries an ECDSA signature from one stored signer. If that signer's account moves to real code, no new token can be minted until the owner sets a new signer.

## Evidence

- In the [verified source](https://etherscan.io/address/0x7d256d82b32d8003d1ca1a1526ed211e6e0da9e2#code), mint requires a signature that recovers to the stored signer; there is no other way to mint.
- The [signer](https://etherscan.io/address/0x87401fd9eb013d029d71ec057ef41ee70484e3c7) is an account without code today.
- setSigner lets the [owner](https://etherscan.io/address/0x2511df645f69290ecab08fa3947617fdee954066), an account without code, replace the signer.

## Reviewer notes

### Mechanism

mint (YAT.sol, lines 129-133) requires block.timestamp < _expiry and _verifyMint, then calls _mint. _verifyMint (588-591) hashes ("yatNFT", token, account, expiry), and compares _recoverSigner's result with signer(), i.e. info.signer. _recoverSigner (583-586) is a bare ecrecover with no code-size or ERC-1271 branch. _mint is internal and mint is its only caller, so a signer whose account has code stops all minting (new names and re-mints of soft-burned ones). info.signer is written by the constructor (109) and by setSigner (120-122), guarded by _onlyOwner (90-93: msg.sender == owner()). At the block signer() is 0x8740…e3c7 (no code, nonce 0, presumed live) and owner() is 0x2511…4066 (no code, nonce 4). Second recovery, not this row's issue: updateRecord with a signature (167-170) accepts the token owner or its cosigner (596); the cosigner defaults to the global signer (281-283). The same act is open by a direct call (172, _onlyTokenOwnerOrCosigner), so that path is a lost shortcut, not a lock. The contract holds no ETH or priced tokens; transfers, burns and direct record updates need no signature.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: _recoverSigner (lines 583-586) is a bare ecrecover; the source has no isValidSignature and no code-size branch.
- Ruled out: unused-implementation / wrong-code: not a proxy (tool facts); totalSupply() is 15210 at the block, so this address is used itself.
- Ruled out: key-state: signer() returns 0x8740…e3c7, non-zero, no code at the block; it is the value _verifyMint compares with (line 590).
- Ruled out: setter: setSigner (120-122) writes info.signer, the value signer() returns (238-240); owner() is 0x2511…4066, a non-zero account without code and with nonce 4, so it can call.
- Ruled out: path-closed: mint has no pause or end switch; only a per-signature expiry (line 130).
- Ruled out: direct-path: _mint is internal (line 462) and its only call site is line 132, inside mint; there is no owner or direct mint.
- Ruled out: rechecked-later: the mint signature is consumed once in mint; nothing re-checks it later.
- Ruled out: children: the only contract deployed is Metadata (line 107), which holds no signature logic.
- Ruled out: gas: ecrecover is the Solidity builtin, which forwards all remaining gas; the scanner found no constant gas (ec_gas_const null).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
