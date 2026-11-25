---
id: pendlelimitrouter-00000000-limit-order-sig
format: 2
title: Pendle Limit Router lets a quantum attacker forge makers' ECDSA order signatures
status: confirmed
severity: MEDIUM
justification: Order signatures are checked with ECDSA before ERC-1271; MEDIUM as one Safe-run proxy upgrade fixes
  it.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x000000000000c9b3e2c3ec88b1b4c0cd853f4321'
  name: PendleLimitRouter
  project: pendle
  code: verified
  code_url: https://etherscan.io/address/0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b#code
  proxy_of: '0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b'
  copies: 1
  upgradeable: 'yes'
  admin: '0xa28c08f165116587d4f3e708743b4dee155c5e64'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 33582
impact: funds-loss
action: Upgrade to a signature check that tries ERC-1271 for accounts with code before ECDSA, passing the full signature.
evidence_level: source
checks:
- id: c1
  source: '0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b'
  file: lib/pendle-core-v2/contracts/limit/LimitRouterBase.sol
  line: 297
  has: 'require(SignatureChecker.isValidSignatureNow(order.maker, orderHash, signature), "LOP: bad signature");'
  says: _checkSig verifies the maker's order signature via SignatureChecker
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c7
  source: '0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol
  line: 25
  has: (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
  says: SignatureChecker first runs ECDSA.tryRecover
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c8
  source: '0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol
  line: 27
  has: (error == ECDSA.RecoverError.NoError && recovered == signer) ||
  says: ECDSA match with the signer is accepted
  for:
  - evidence-2
  - justification
  - what
- id: trin
  source: '0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b'
  file: lib/pendle-core-v2/contracts/limit/LimitRouterBase.sol
  has: _transferIn(sharedToken, params[r].order.maker, params[r].makingAmount);
  line: 323
  says: fill pulls each maker's tokens into the router
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
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-2
reviews: []
related: []
---

## What happens

The router fills limit orders and accepts a maker's order signature if ECDSA recovers the maker's address, before any ERC-1271 check. A quantum attacker who derives a maker's old key signs orders at any rate and fills them, pulling the tokens that maker approved to the router.

## Evidence

- [_checkSig](https://etherscan.io/address/0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b#code) requires SignatureChecker.isValidSignatureNow(order.maker, orderHash, signature) for new orders.
- [SignatureChecker](https://etherscan.io/address/0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b#code) first runs ECDSA.tryRecover and accepts when the recovered address equals the signer.
- [Fill](https://etherscan.io/address/0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b#code) pulls each maker's tokens with _transferIn(sharedToken, maker, makingAmount).

## Reviewer notes

### Mechanism

fill -> _checkSig_updMakingAndStatus -> _checkSig (LimitRouterBase.sol 281-307): for an order with no stored status, line 297 calls OpenZeppelin 4.9 SignatureChecker.isValidSignatureNow(order.maker, orderHash, signature). That library (lines 24-27) returns true when ECDSA.tryRecover(hash, signature) == signer and only otherwise calls ERC-1271 isValidSignature on the maker. A maker that migrated in place to a post-quantum smart account keeps its old secp256k1 address, so a forged ECDSA signature still passes. _transferFromMakers_mintSy_updMakings then calls _transferIn(token, maker, makingAmount) (line 323), pulling the maker's approved SY/PT/YT or input token, and the maker is paid at the forged order's rate. The router is a TransparentUpgradeableProxy whose ProxyAdmin is owned by Pendle's 3-of-5 Safe, so an implementation upgrade removes the ECDSA-first path. Alternatives exist: preSignSingle/preSignBatch and ERC-1271 for makers with code.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Mint-SY operator signature check (MintSyHelper lines 71-72): both signers are zero on mainnet, so the option is disabled.
- Ruled out: Router balance: holds about nothing; exposure is makers' approvals.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
