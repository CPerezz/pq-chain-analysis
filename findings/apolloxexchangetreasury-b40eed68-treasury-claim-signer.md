---
id: apolloxexchangetreasury-b40eed68-treasury-claim-signer
format: 2
title: Aster treasury pays claims signed by one quantum-breakable ECDSA key
status: confirmed
severity: MEDIUM
justification: One ECDSA key authorises all payouts; Aster's Safe must fix it by a new deployment; the balance is
  material.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  name: ApolloxExchangeTreasury
  project: aster
  code: verified
  code_url: https://etherscan.io/address/0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786#code
  copies: 1
  upgradeable: 'no'
  admin: '0x9b7c0a5829ab078c219f2f751a2ab46ab911bbec'
value:
  usd: 110119
  basis: held
activity:
  txs_90d: 1313
impact: funds-loss
action: Deploy a treasury that verifies claims with a post-quantum scheme, then move the balance out and pause this
  one.
evidence_level: source
checks:
- id: c1
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: /Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol
  line: 89
  has: return ECDSA.recover(hash, signature);
  says: source recovers the signer with ECDSA
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 169
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover precompile
  for:
  - what
- id: claim-open
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: /Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol
  has: function claim(bytes calldata message, bytes calldata signature) external notPaused {
  line: 73
  says: claim is external with only a pause check
  for:
  - what
- id: claim-check
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: /Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol
  has: require(signer == truthHolder, "only accept truthHolder signed message");
  line: 75
  says: claim requires the truthHolder signature
  for:
  - evidence-1
  - justification
  - what
- id: claim-decode
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: /Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol
  has: abi.decode(message, (uint256, address, bool, address, uint256, uint256));
  line: 77
  says: recipient and amount come from the signed message
  for:
  - what
- id: claim-transfer
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: /Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol
  has: _transfer(to, isETH, currency, amount);
  line: 83
  says: claim pays the signed amount to the signed recipient
  for:
  - evidence-3
  - what
- id: change-th
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: /Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol
  has: function _changeTruthHolder(address newTruthHolder) external onlyOwner {
  line: 102
  says: only the owner can change the signer, to another address
  for:
  - justification
- id: xfer-cp
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: /Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol
  has: function transferToCounterParty(bool isETH, address currency, uint amount) external onlyOperator {
  line: 68
  says: the operator can move funds to the counterparty
  for:
  - action
- id: pause
  source: '0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786'
  file: /Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol
  has: function _pause() external onlyOwner {
  line: 92
  says: the owner can pause claims
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
  who: Review10 (source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The treasury pays out ETH or tokens to anyone presenting a message signed by the truthHolder key, checked with ECDSA recovery. A quantum attacker who recovers that key from its public signatures can sign claims that send the treasury's balance to themselves.

## Evidence

- [claim](https://etherscan.io/address/0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786#code) accepts a message only if the recovered signer equals truthHolder.
- [source](https://etherscan.io/address/0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786#code) recovers the signer with ECDSA over the hashed message.
- [claim](https://etherscan.io/address/0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786#code) transfers the signed amount to the signed recipient.

## Reviewer notes

### Mechanism

claim(message, signature) (line 73) has only the notPaused modifier, so any caller can submit it. Line 74 calls source(), which at line 88 hashes the message with the eth_sign prefix and at line 89 calls ECDSA.recover, ending in ecrecover (ECDSA.sol line 169). Line 75 requires the result to equal truthHolder. Line 77 decodes (id, to, isETH, currency, amount, deadline); lines 78-80 check the id is unused, the currency is supported (or ETH) and the deadline; line 83 _transfer sends amount to `to`. With truthHolder's key recovered from public claim signatures, an attacker signs fresh ids for the full balance. _changeTruthHolder (line 102, onlyOwner) can only swap to another ECDSA address; the contract has no other verifier and no upgrade path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy or upgrade function in the source.
- Ruled out: Rotating truthHolder keeps ECDSA verification.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
