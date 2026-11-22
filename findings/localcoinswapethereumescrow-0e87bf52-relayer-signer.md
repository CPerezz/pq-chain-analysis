---
id: localcoinswapethereumescrow-0e87bf52-relayer-signer
format: 2
title: LocalCoinSwap ETH escrow trusts ECDSA a quantum attacker could forge
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
  address: '0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd'
  name: LocalCoinSwapEthereumEscrow
  project: localcoinswap
  code: verified
  code_url: https://etherscan.io/address/0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd#code
  copies: 1
  upgradeable: 'no'
  admin: '0x7ab685a614d0aac012e85f778fcc36913f3b2271'
value:
  usd: 31014
  basis: held
activity:
  txs_90d: 1
impact: funds-loss
action: Deploy an escrow that verifies trader signatures via ERC-1271 or a post-quantum scheme and stop inviting
  trades here.
evidence_level: source
checks:
- id: c1
  source: '0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd'
  file: contracts/localcoinswap/EthereumEscrow.sol
  line: 445
  has: return ecrecover(_prefixedHash, _v, _r, _s);
  says: Signature recovery is plain ecrecover over the prefixed hash.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd'
  file: contracts/localcoinswap/EthereumEscrow.sol
  has: return recoverAddress(_hash, _v, _r, _s);
  line: 417
  says: Relayed instruction signer is recovered from a hash of trade ID, instruction and gas price.
  for:
  - evidence-1
  - justification
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

This escrow holds a seller's ETH for a P2P trade and accepts relayed instructions signed with ECDSA. A buyer who recovers the seller's key with a quantum computer can sign a release and receive the escrowed ETH without paying.

## Evidence

- [getRelayedSender](https://etherscan.io/address/0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd#code) hashes the trade ID, instruction byte and maximum gas price and recovers the signer.
- [recoverAddress](https://etherscan.io/address/0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd#code) returns the ecrecover result over the prefixed hash.

## Reviewer notes

### Mechanism

relay/batchRelay call getRelayedSender (lines ~405-418), which builds keccak256(tradeID, instructionByte, maximumGasPrice) and calls recoverAddress (lines 437-446), which applies the Ethereum signed-message prefix and returns ecrecover (line 445). If the recovered address is the seller and the instruction is RELEASE_ESCROW, doRelease pays the escrow minus fees to the trade's buyer. resolveDispute requires msg.sender == arbitrator plus an ecrecover signature from buyer or seller, so the arbitrator EOA's key also lets a buyer get open escrows paid to themselves. The relayer's invitation signature only gates createEscrow funded by msg.sender, so forging it takes nothing.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Forging the relayer's invitation signature moves no funds: escrows are funded by the caller.
- Ruled out: Direct release and buyerCancel check msg.sender, not signatures.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
