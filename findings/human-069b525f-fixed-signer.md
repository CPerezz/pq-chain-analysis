---
id: human-069b525f-fixed-signer
format: 2
title: Humans Of NFT coupons stop working if its signer account takes real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the coupon signer moves its account to real code; the key is fixed and the sale has
  not opened.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  name: Human
  code: verified
  code_url: https://etherscan.io/address/0x069b525f5e5f1a4de76be06d0febf5e24b09d609#code
  copies: 1
  upgradeable: 'no'
  admin: '0xeecc5388cb9a5c1ffe53f0a3dc19e968e9251e36'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Deploy a new contract with a new coupon signer before the current signer's account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 395
  has: address signer = ecrecover(digest, coupon.v, coupon.r, coupon.s);
  says: each coupon is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: match
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 397
  has: return signer == _adminSigner;
  says: a coupon is valid only when the recovered address is the admin signer
  for:
  - evidence-1
  - justification
  - what
- id: immutable
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 95
  has: address private immutable _adminSigner;
  says: the admin signer is immutable, so no function can change it
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ctor
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 126
  has: _adminSigner = adminSigner;
  says: the admin signer is set once, in the constructor
  for:
  - action
  - what
- id: admincomment
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 215
  has: '@dev mints genesis token IDs using verified coupons signed by an admin address'
  says: the coupons are signed by the contract's own admin address
  for:
  - action
- id: genesis
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 230
  has: require(_isVerifiedCoupon(digest, coupon), 'Invalid coupon');
  says: the genesis claim requires a valid coupon
  for:
  - what
- id: author
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 253
  has: require(_isVerifiedCoupon(digest, coupon), 'Invalid coupon');
  says: the author claim requires a valid coupon
  for:
  - what
- id: presale
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 283
  has: require(_isVerifiedCoupon(digest, coupon), 'Invalid coupon');
  says: the presale mint requires a valid coupon
  for:
  - what
- id: swap
  source: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  file: contracts/HumansERC721.sol
  line: 334
  has: require(_isVerifiedCoupon(digest, coupon), 'Invalid coupon');
  says: the ERC1155 genesis swap requires a valid coupon
  for:
  - what
- id: signerbytes
  bytecode: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  has: 7f000000000000000000000000c7eb865d2d4f6033cae0e81248173209a2e6843d
  says: the immutable admin signer pushed by the runtime code is 0xc7eb865d2d4f6033cae0e81248173209a2e6843d
  for:
  - evidence-2
- id: signercode
  code: '0xc7eb865d2d4f6033cae0e81248173209a2e6843d'
  is: empty
  says: the admin signer's account has no code
  for:
  - evidence-2
- id: phase
  call: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  fn: phase()(uint8)
  is: 0
  says: the sale phase is Locked
  for:
  - evidence-2
  - justification
  - what
- id: claim
  call: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  fn: claimActive()(bool)
  is: false
  says: the claim switch is off
  for:
  - evidence-2
- id: count
  call: '0x069b525f5e5f1a4de76be06d0febf5e24b09d609'
  fn: tokenCount()(uint256)
  is: 0
  says: no token has been minted by sale, presale, author claim or team reserve
  for:
  - evidence-2
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

This NFT contract mints presale, author and genesis tokens only with a coupon signed by one admin key set at deployment. If that key's account takes real code, every coupon fails and no function can replace the key. Its sale phase is still locked and no token has been sold.

## Evidence

- The [verified source](https://etherscan.io/address/0x069b525f5e5f1a4de76be06d0febf5e24b09d609#code) accepts a coupon only when ecrecover returns the immutable admin signer.
- The [signer](https://etherscan.io/address/0xc7eb865d2d4f6033cae0e81248173209a2e6843d) has no code; the sale phase is locked, claiming is off and the sale count is 0.

## Reviewer notes

### Mechanism

_isVerifiedCoupon (HumansERC721.sol, lines 389-398) recovers the coupon with the ecrecover builtin (all gas forwarded), rejects address(0) and returns signer == _adminSigner. _adminSigner is immutable (line 95), set in the constructor (line 126); it is 0xc7eb865d2d4f6033cae0e81248173209a2e6843d, embedded as a PUSH32 in the runtime code. Four paths require the coupon: claimReservedTokensByIds (genesis, line 230, gated by claimActive), claimAuthorTokens (line 253, gated by claimActive), mintPresale (line 283, phase PreSale) and onERC1155Received (line 334, the OpenSea-token swap for a genesis ID; not gated by claimActive). Reserved IDs 1-264 are minted only by _claimReservedToken, reached only from the two genesis paths, so they need a coupon. The public mint (lines 296-312, phase PublicSale) and devReserveTokens (owner, random IDs) need none. The contract is not upgradeable, so replacing the signer means a new deployment. At block 26,438,999: phase 0 (Locked), claimActive false, tokenCount 0, teamTokensMinted 0, ownerOf(1), ownerOf(2), ownerOf(229), ownerOf(264) revert as nonexistent; owner 0xeecc...1e36 is an account with no code and nonce 115, so it can still call enterPhase and activateClaiming. The signer has no code and nonce 0 (it signs off-chain; presumed live).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for a signer with code: _isVerifiedCoupon has none (lines 389-398).
- Ruled out: a fixed gas budget: the ecrecover builtin forwards all gas, so the gas price change alone breaks nothing; no separate rated issue.
- Ruled out: a setter or upgrade for the signer: _adminSigner is immutable and the contract is not a proxy.
- Ruled out: path closed for good: phase is Locked and claimActive false, but the owner (an account with no code, nonce 115) can call enterPhase and activateClaiming, and the ERC1155 swap path has no claimActive gate.
- Ruled out: a signature relied on later: coupons are checked once at mint; nothing re-checks them after others relied on them.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
