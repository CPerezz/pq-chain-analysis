---
id: localcoinswapv2escrow-3bae89b2-relayer-signer
format: 2
title: LocalCoinSwap V2 escrow funds exposed to quantum-forged seller releases
status: confirmed
severity: MEDIUM
justification: Relayed releases trust ecrecover alone; the contract is fixed, but LocalCoinSwap can route new trades
  elsewhere.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2'
  name: LocalCoinSwapV2Escrow
  project: localcoinswap
  code: verified
  code_url: https://etherscan.io/address/0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2#code
  copies: 1
  upgradeable: 'no'
  admin: '0x7ab685a614d0aac012e85f778fcc36913f3b2271'
value:
  usd: 37810
  basis: held
activity:
  txs_90d: 9
impact: funds-loss
action: Deploy an escrow that checks trader instructions via ERC-1271 or a post-quantum scheme and stop inviting
  trades into this one.
evidence_level: source
checks:
- id: c1
  source: '0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2'
  file: contracts/localcoinswap/LocalCoinSwapV2.sol
  line: 397
  has: return ecrecover(_prefixedHash, _v, _r, _s);
  says: recoverAddress returns the ecrecover result
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2'
  file: contracts/localcoinswap/LocalCoinSwapV2.sol
  has: bytes32 _prefixedHash = keccak256(abi.encodePacked(_prefix, _h));
  line: 396
  says: the signed hash is wrapped in the Ethereum signed-message prefix
  for:
  - evidence-2
- id: c3
  source: '0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2'
  file: contracts/localcoinswap/LocalCoinSwapV2.sol
  has: return recoverAddress(_hash, _v, _r, _s);
  line: 410
  says: relayed instruction sender is taken from signature recovery
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2'
  file: contracts/localcoinswap/LocalCoinSwapV2.sol
  has: Token(_currency).safeTransfer(_to, _value - _totalFees);
  line: 368
  says: escrowed trader tokens are paid out to the recipient minus fees
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

This escrow holds a seller's stablecoins for a P2P trade and accepts relayed trade instructions when ecrecover returns a trader's address. A quantum attacker who recovers a seller's key can sign a release that pays the escrow to the trade's buyer.

## Evidence

- [getRelayedSender](https://etherscan.io/address/0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2#code) hashes the trade ID, instruction and gas cap and passes them to recoverAddress.
- [recoverAddress](https://etherscan.io/address/0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2#code) returns the ecrecover result over the prefixed hash.

## Reviewer notes

### Mechanism

relay/batchRelay call getRelayedSender (lines 400-411), which builds keccak256(tradeID, instructionByte, maximumGasPrice) and calls recoverAddress (389-398), returning ecrecover over the Ethereum-signed-message prefix (line 397). Per kev's finding, a seller signature with RELEASE_ESCROW runs doRelease, paying the escrow minus fees to the buyer via transferMinusFees (line 368), and resolveDispute accepts the arbitrator EOA (msg.sender) plus an ecrecover signature of buyer or seller. createEscrow checks recoverAddress(_invitationHash) == relayer (line 120), but funds come from the caller, so forging the invitation takes nothing.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Forging the relayer invitation only opens escrows with the caller's own funds.
- Ruled out: Contract is not upgradeable; fix needs a new deployment.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
