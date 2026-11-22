---
id: contract-9ba0cf15-signer-key
format: 2
title: Unidentified market-maker vault signs any order for a quantum-forged signer key
status: candidate
severity: MEDIUM
justification: A forged signer key lets venues pull vault funds; only the owner can fix it, by deploying a new vault.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31'
  code: decompiled
  code_url: code/0xdca3eba4af34dc721459027718f7301433a6da2943a10164593af2afbacfde72.sol
  copies: 1
  upgradeable: 'no'
  admin: '0xc493f943a1fd910d01dcabea86e61415ce43e787'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Keep the vault empty, revoke venue approvals, and deploy a vault whose isValidSignature verifies a post-quantum
  signer.
evidence_level: bytecode
checks:
- id: sel-isvalid
  selector: '0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31'
  fn: isValidSignature(bytes32,bytes)
  says: The vault exposes the ERC-1271 signature check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-taker
  selector: '0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31'
  fn: takerInteraction((uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256),bytes,bytes32,address,uint256,uint256,uint256,bytes)
  says: The vault has the 1inch LOP v4 taker hook.
  for:
  - evidence-2
  - what
- id: sel-reactor
  selector: '0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31'
  fn: reactor()
  says: The vault stores a UniswapX reactor address.
  for:
  - evidence-2
  - what
- id: sel-setowner
  selector: '0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31'
  fn: setOwner(address)
  says: The vault has a single owner who controls its configuration.
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review08 (bytecode, token flows, deployer siblings, on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This vault is the maker on RFQ and limit orders across trading venues and approves orders through isValidSignature. A quantum attacker who recovers a signer key could make it approve orders that hand its tokens to the attacker.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31#code) is in the bytecode, the ERC-1271 hook venues call on the order maker.
- [takerInteraction and reactor](https://etherscan.io/address/0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31#code) wire the vault into limit-order and UniswapX order flow.

## Reviewer notes

### Mechanism

Unverified bytecode. Venues (1inch LOP via takerInteraction, UniswapX reactor, CoW, AirSwap swapERC20) call isValidSignature(bytes32,bytes) on the vault as maker. Decompiled 0x1626ba7e requires a 65-byte signature, low s and v checks ('Liq: invalid signature ...'), recovers an address, and returns the magic value 0x1626ba7e if it equals the owner slot or is flagged in a signer mapping set by an onlyOwner setter. The venue then pulls vault tokens through approvals. Kev's finding traces ecrecover precompile calls to this contract. Rotating ECDSA signers does not help; the owner is an ECDSA EOA, so the fix is a new deployment.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The vault is not upgradeable; the fix is a new deployment.
- Ruled out: Funds were withdrawn on 2026-05-07; current exposure is small.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
