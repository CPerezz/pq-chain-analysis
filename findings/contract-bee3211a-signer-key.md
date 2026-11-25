---
id: contract-bee3211a-signer-key
format: 2
title: Market maker accepts operator ECDSA signatures a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Operator ECDSA keys authorise trades of the inventory; the proxy admin owner can fix it with an upgrade.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbee3211ab312a8d065c4fef0247448e17a8da000'
  code: decompiled
  code_url: code/0x584580c37e7bc6056aded08ac4938178fbab186363d4c9c5a6455dedd8c47a29.sol
  proxy_of: '0xe89e1c84076dbd917f6d71608db579d3f4995487'
  copies: 1
  upgradeable: 'yes'
  admin: '0x29dfb2d5341fd10cb99f191970d8ac85948fbf44'
value:
  usd: 10419984
  basis: held
activity:
  txs_90d: 435657
impact: funds-loss
action: Upgrade the implementation to verify post-quantum operator signatures and move ownership to a post-quantum
  account.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xe89e1c84076dbd917f6d71608db579d3f4995487'
  has: 60015afa
  says: the implementation calls the ecrecover precompile
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-isvalidsig
  selector: '0xe89e1c84076dbd917f6d71608db579d3f4995487'
  fn: isValidSignature(bytes32,bytes)
  says: the implementation exposes ERC-1271 isValidSignature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-isoperator
  selector: '0xe89e1c84076dbd917f6d71608db579d3f4995487'
  fn: isOperator(address)
  says: the implementation keeps an operator set
  for:
  - evidence-2
  - justification
  - what
- id: sel-getallops
  selector: '0xe89e1c84076dbd917f6d71608db579d3f4995487'
  fn: getAllOperators()
  says: the operator set can be listed
  for:
  - evidence-2
- id: sel-emergency
  selector: '0xe89e1c84076dbd917f6d71608db579d3f4995487'
  fn: emergencyWithdraw(address,uint256)
  says: the owner can withdraw tokens directly
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review18 (implementation bytecode strings and selectors, operator and admin reads, sibling check)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This upgradeable market-maker contract accepts orders and operator requests authorised by an ECDSA signature from an operator key. A quantum attacker who recovers an operator key can sign orders that trade away the tokens the contract holds.

## Evidence

- The [implementation](https://etherscan.io/address/0xe89e1c84076dbd917f6d71608db579d3f4995487#code) calls the ecrecover precompile and exposes ERC-1271 isValidSignature.
- The [implementation](https://etherscan.io/address/0xe89e1c84076dbd917f6d71608db579d3f4995487#code) keeps an operator set queried through isOperator and getAllOperators.
- The owner key also controls funds through emergencyWithdraw in the [implementation](https://etherscan.io/address/0xe89e1c84076dbd917f6d71608db579d3f4995487#code).

## Reviewer notes

### Mechanism

The proxy delegates to the unverified implementation 0xe89e1c84. Its bytecode exposes isValidSignature(bytes32,bytes) (ERC-1271) and an operator set (isOperator, getAllOperators, operatorAt, "caller is not operator"), and calls ecrecover (offset 16284), consistent with OpenZeppelin ECDSA recovery. Per the census, an order whose maker is this contract is valid when the recovered signer is an operator, and a second path executes operator-signed requests against approved destinations. Operator EOAs have transacted on-chain, so their public keys are known; a quantum attacker who derives a private key can sign orders selling the inventory at their price. The owner EOA additionally controls emergencyWithdraw and adminExecute, a second ECDSA dependency. Which selector reaches ecrecover was not traced. The ProxyAdmin owner EOA can upgrade the verification; rotating operator EOAs does not help.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Rotating operator EOAs to new ECDSA keys does not remove the exposure.
- Ruled out: No protocol change is needed.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
