---
id: thusdminter-2c2347f3-entry-by-own-signature-only
format: 2
title: thUSD minter refuses orders from signers whose accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a whitelisted signer moves its account to real code before placing its orders.
category: migration-notice
pattern: PQ-21
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  name: ThUSDMinter
  label: 'deployed by Theo: Deployer 2'
  code: verified
  code_url: https://etherscan.io/address/0x2c2347f3cf2275bda88a7a222f08f888e0972f64#code
  copies: 4
  family: 08afd64d025ab92fb11835c87a329638
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell whitelisted users that their orders stop if their account takes real code; an EIP-7702 delegation still
  works.
evidence_level: source
checks:
- id: recover
  source: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  file: contracts/thusd/ThUSDMinter.sol
  line: 207
  has: address recovered = ECDSA.recover(orderHash, signature);
  says: the order's signature is recovered with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: match
  source: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  file: contracts/thusd/ThUSDMinter.sol
  line: 208
  has: if (recovered != order.signer) revert InvalidSignature();
  says: the recovered address must equal the signer named in the order
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ecdsa-lib
  source: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  file: lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: the library calls the ecrecover precompile, with no ERC-1271 branch
  for:
  - action
  - what
- id: whitelist
  source: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  file: contracts/thusd/ThUSDMinter.sol
  line: 214
  has: whitelist.onlyWhitelisted(order.signer);
  says: the order's signer must be whitelisted
  for:
  - action
  - justification
  - what
- id: pull
  source: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  file: contracts/thusd/ThUSDMinter.sol
  line: 221
  has: safeTransferFrom(order.signer, mintDestination, order.collateral_amount);
  says: a mint pulls the collateral from the order's signer
  for:
  - what
  - whose
- id: burn
  source: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  file: contracts/thusd/ThUSDMinter.sol
  line: 98
  has: ThUSD(thusd).burnFrom(order.signer, order.thusd_amount);
  says: a redeem burns the order signer's thUSD
  for:
  - what
  - whose
- id: mint-role
  source: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  file: contracts/thusd/ThUSDMinter.sol
  line: 74
  has: function mint(Order calldata order, bytes calldata signature) external nonReentrant whenNotPaused onlyRole(MINTER_ROLE)
    {
  says: mint takes a signed order and only the minter role can call it
  for:
  - what
- id: redeem-role
  source: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  file: contracts/thusd/ThUSDMinter.sol
  line: 89
  has: function redeem(Order calldata order, bytes calldata signature) external nonReentrant whenNotPaused onlyRole(MINTER_ROLE)
    {
  says: redeem takes a signed order and only the minter role can call it
  for:
  - what
- id: token-minter
  call: '0x2332e0df18ad299847b71ed6b8ebd74341359e2c'
  fn: minter()(address)
  is: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  says: the thUSD token names this contract as its minter
  for:
  - evidence-2
  - what
- id: not-paused
  call: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  fn: paused()(bool)
  is: false
  says: the minter is not paused
  for:
  - evidence-2
- id: usdc
  call: '0x2c2347f3cf2275bda88a7a222f08f888e0972f64'
  fn: supportedAssets(address)(bool)
  args:
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is: true
  says: USDC is accepted as collateral
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-2c2347f3, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree (refuter read all 4 copies and their thUSD tokens). Sheet read by Claude.
    ThUSDMinter: each order needs its whitelisted signer''s ECDSA signature; nothing held is locked (thUSD is a
    plain transferable ERC-20). INFORMATIONAL; a candidate while MINTER_ROLE''s holder is not established.'
related: []
---

## What happens

This contract mints and redeems thUSD on orders that an operator with the minter role submits. Each order needs an ECDSA signature of its whitelisted signer, who pays the collateral or the thUSD. A signer whose account takes real code can no longer place orders.

## Evidence

- [The order check](https://etherscan.io/address/0x2c2347f3cf2275bda88a7a222f08f888e0972f64#code) recovers the signature with ECDSA and reverts unless it equals the order's signer.
- [thUSD](https://etherscan.io/address/0x2332e0df18ad299847b71ed6b8ebd74341359e2c) names this contract as its minter; the contract is not paused and accepts USDC.

## Reviewer notes

### Mechanism

mint() and redeem() (lines 74 and 89) are callable only by MINTER_ROLE and call _validateOrder. _validateOrder hashes the order with EIP-712, recovers it with OpenZeppelin ECDSA.recover (line 207, a plain ecrecover with all gas, ECDSA.sol line 148), reverts unless the recovered address equals order.signer (line 208), then requires the signer and recipient to be whitelisted (lines 214-217). mint pulls the collateral from order.signer (line 221); redeem burns order.signer's thUSD (line 98). No ERC-1271 or code-size branch exists, and no function mints or redeems without a signed order. At block 26,438,999 this address is thUSD 0x2332...9e2c's minter(), paused() is false, USDC is a supported asset, maxMintPerBlock is 1e12 and maxRedeemPerBlock 2e11; DEFAULT_ADMIN_ROLE is held by 0x82263f75...9072, which also owns the thUSD token.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: erc1271: OpenZeppelin ECDSA.recover only, compared with order.signer (lines 207-208); no ERC-1271 path.
- Ruled out: direct-path: mint/redeem are the only paths to ThUSD.mint and burnFrom here, both require a signed order; the recipient is not signature-checked, so a code account can still receive thUSD minted on another signer's order.
- Ruled out: own-signature-only-exit (PQ-16) considered for redeem: ThUSD.sol in this verified bundle is a plain ERC20 without a transfer gate, so the holder can still move thUSD by direct calls; redeem is not the only way out. Kept PQ-21.
- Ruled out: rechecked-later: the signature is checked once at execution; a failed check reverts and moves nothing, so nobody who relied on it loses.
- Ruled out: gas/breaks-by-itself: ECDSA.recover forwards all gas to the precompile; nothing fails with nobody migrating.
- Ruled out: path-closed / unused-implementation: not a proxy, not paused, minter of thUSD 0x2332...9e2c, USDC supported, nonzero per-block caps.
- Ruled out: copies: 0x2d99ac80..., 0x625c9780..., 0xfa964ad3... each point at a different thUSD token and are not paused; the 11 window recoveries in the study data are at copy 0x2d99ac80..., none at this address.
- Ruled out: old row: rated LOW and claimed 'executed', but the dossier lists no replays; re-rated INFORMATIONAL (migration notice) at source level.

### Questions

- Which account holds MINTER_ROLE on this address at block 26,438,999? AccessControl is not enumerable and no log scan was allowed; the token owner 0x82263f75...9072 and mint destination 0xec417ccb...3c2f do not hold it.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
