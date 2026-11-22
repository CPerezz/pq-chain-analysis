---
id: augustusrfq-e92b5866-velora-augustus-rfq-maker-sig
format: 2
title: Velora AugustusRFQ lets a migrated maker's old ECDSA key sign orders
status: confirmed
severity: HIGH
justification: Makers' approvals stay forgeable after migration; the contract has no admin, so only makers can protect
  themselves.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe92b586627cca7a83dc919cc7127196d70f55a06'
  name: AugustusRFQ
  project: paraswap
  code: verified
  code_url: https://etherscan.io/address/0xe92b586627cca7a83dc919cc7127196d70f55a06#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10997
impact: funds-loss
action: Revoke maker approvals to AugustusRFQ before converting an address, and route makers to a code-first settlement
  contract.
evidence_level: source
checks:
- id: c1
  source: '0xe92b586627cca7a83dc919cc7127196d70f55a06'
  file: contracts/AugustusRFQ.sol
  line: 640
  has: require(SignatureChecker.isValidSignatureNow(maker, orderHash, signature), "Invalid Signature");
  says: _checkOrder requires SignatureChecker.isValidSignatureNow for the maker.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xe92b586627cca7a83dc919cc7127196d70f55a06'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 173
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover recovers the signer via ecrecover.
  for:
  - evidence-3
  - what
- id: c5
  source: '0xe92b586627cca7a83dc919cc7127196d70f55a06'
  file: '@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol'
  line: 26
  has: (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
  says: isValidSignatureNow first runs ECDSA.tryRecover.
  for:
  - evidence-2
  - justification
  - what
- id: c6
  source: '0xe92b586627cca7a83dc919cc7127196d70f55a06'
  file: '@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol'
  line: 27
  has: if (error == ECDSA.RecoverError.NoError && recovered == signer) {
  says: A matching ECDSA recovery is accepted before ERC-1271.
  for:
  - action
  - evidence-2
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: eip-8151-impact
  who: Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

AugustusRFQ accepts a maker order if ECDSA recovers the maker, trying ERC-1271 only after. A quantum attacker with a maker's old ECDSA key can sign orders spending its approved tokens, even after the address gets post-quantum code.

## Evidence

- [_checkOrder](https://etherscan.io/address/0xe92b586627cca7a83dc919cc7127196d70f55a06#code) requires isValidSignatureNow(maker, orderHash, signature) on an order's first fill.
- [isValidSignatureNow](https://etherscan.io/address/0xe92b586627cca7a83dc919cc7127196d70f55a06#code) returns true when ECDSA.tryRecover yields the maker, before any ERC-1271 call.
- [tryRecover](https://etherscan.io/address/0xe92b586627cca7a83dc919cc7127196d70f55a06#code) recovers the signer with ecrecover.

## Reviewer notes

### Mechanism

All fill functions (fillOrder, partialFillOrder*, fillOrderWithTarget*, batch and NFT variants) hash the Order with EIP-712 and call _checkOrder. On the first fill of an order hash (remainingAmount == UNFILLED_ORDER), line 640 requires SignatureChecker.isValidSignatureNow(maker, orderHash, signature). OZ 4.4.0 SignatureChecker line 26 calls ECDSA.tryRecover, which uses ecrecover (ECDSA.sol line 173). Line 27 returns true if the recovered address equals the maker, so the ERC-1271 call only happens when that fails. A maker address with a known ECDSA key that later gets post-quantum code still passes on the ECDSA branch. The contract then transfers makerAsset from the maker through its approval. A forged order with taker = 0 and a near-zero takerAmount drains the approved balance. The contract has no proxy or owner, so the check cannot be changed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Takers are not exposed: the taker side is msg.sender.
- Ruled out: Pure contract makers are reached only through ERC-1271.
- Ruled out: The contract itself holds only dust.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
