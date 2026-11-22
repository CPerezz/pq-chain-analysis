---
id: transitswaprouterv5-00000047-transit-fee-signer
format: 2
title: Transit Swap router accepts ECDSA fee discounts a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged fee signature only waives the caller's own swap fee; executor can repoint the signer, so LOW.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00000047bb99ea4d791bb749d970de71ee0b1a34'
  name: TransitSwapRouterV5
  project: transit-swap
  code: verified
  code_url: https://etherscan.io/address/0x00000047bb99ea4d791bb749d970de71ee0b1a34#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 321
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Keep the router paused or set the fee signer to an address with no key; verify fee discounts with a post-quantum
  signer in a new router.
evidence_level: source
checks:
- id: c1
  source: '0x00000047bb99ea4d791bb749d970de71ee0b1a34'
  file: BaseCore.sol
  line: 229
  has: address recovered = ecrecover(digest, v, r, s);
  says: verifySignature recovers the signer with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x00000047bb99ea4d791bb749d970de71ee0b1a34'
  file: BaseCore.sol
  line: 129
  has: require(verifySignature(tradeAmount, fee, signature), "Invalid signature fee");
  says: A below-rate fee requires a valid fee signature.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x00000047bb99ea4d791bb749d970de71ee0b1a34'
  file: BaseCore.sol
  line: 220
  has: function verifySignature(uint256 amount, uint256 fee, bytes calldata signature) internal view returns (bool)
    {
  says: verifySignature checks amount, fee and signature.
  for:
  - justification
- id: fee-bind
  source: '0x00000047bb99ea4d791bb749d970de71ee0b1a34'
  file: BaseCore.sol
  has: keccak256(abi.encode(CHECKFEE_TYPEHASH, msg.sender, amount, fee))
  line: 225
  says: the line or bytes the card cites
  for:
  - evidence-2
  - justification
  - what
- id: sig-cmp
  source: '0x00000047bb99ea4d791bb749d970de71ee0b1a34'
  file: BaseCore.sol
  has: return recovered == _fee_signer;
  line: 230
  says: the line or bytes the card cites
  for:
  - evidence-2
- id: set-signer
  source: '0x00000047bb99ea4d791bb749d970de71ee0b1a34'
  file: BaseCore.sol
  has: function changeTransitProxy(address aggregator, address signer) external onlyExecutor {
  line: 158
  says: the line or bytes the card cites
  for:
  - action
  - evidence-3
  - justification
- id: pause
  source: '0x00000047bb99ea4d791bb749d970de71ee0b1a34'
  file: BaseCore.sol
  has: function changePause(bool paused) external onlyExecutor {
  line: 197
  says: the line or bytes the card cites
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; executor, signer and pause reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The router charges a swap fee unless the trader presents a lower fee signed by the fee signer, checked with ECDSA. A quantum attacker who recovers the signer key can sign a zero fee for their own swaps; the signature binds the caller, amount and fee.

## Evidence

- [calculateTradeFee](https://etherscan.io/address/0x00000047bb99ea4d791bb749d970de71ee0b1a34#code) requires a valid signature when the requested fee is below the set rate.
- [verifySignature](https://etherscan.io/address/0x00000047bb99ea4d791bb749d970de71ee0b1a34#code) hashes the caller, amount and fee, then compares the ecrecover result with the fee signer.
- [changeTransitProxy](https://etherscan.io/address/0x00000047bb99ea4d791bb749d970de71ee0b1a34#code) lets the executor replace the fee signer.

## Reviewer notes

### Mechanism

Swap entries call BaseCore.calculateTradeFee (lines 121-132): if fee < amount*_aggregate_fee (or _cross_fee)/10000, line 129 requires verifySignature(tradeAmount, fee, signature). verifySignature (220-231) builds an EIP-712 digest of CHECKFEE_TYPEHASH with msg.sender, amount, fee (line 225), recovers with ecrecover (229) and compares to _fee_signer (230). The function returns tradeAmount - fee (131), so a forged signature only reduces the operator's fee on the attacker's own swap. _fee_signer is set by changeTransitProxy (158-168, onlyExecutor); changePause (197) pauses the router.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A forged fee signature does not move other users' tokens: the digest binds msg.sender.
- Ruled out: Tokens held by the router leave only via executor-only withdrawTokens.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
