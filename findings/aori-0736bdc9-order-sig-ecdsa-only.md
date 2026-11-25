---
id: aori-0736bdc9-order-sig-ecdsa-only
format: 2
title: Aori accepts ECDSA-only orders a quantum attacker could forge to drain users
status: confirmed
severity: MEDIUM
justification: Order logic is immutable and trusts ECDSA alone, so only a new Aori deployment with ERC-1271 checks
  fixes it.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0736bdc975af0675b9a045384efed91360d25479'
  name: Aori
  project: aori
  code: verified
  code_url: https://etherscan.io/address/0x0736bdc975af0675b9a045384efed91360d25479#code
  copies: 1
  upgradeable: 'no'
  admin: '0x941327e206b8d8cfe1014a8a95b05e1536dfd00d'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 8970
impact: funds-loss
action: Deploy a version that checks offerer code and calls ERC-1271 isValidSignature for contract accounts, and
  move solvers to it.
evidence_level: source
checks:
- id: c1
  source: '0x0736bdc975af0675b9a045384efed91360d25479'
  file: contracts/AoriUtils.sol
  line: 59
  has: address recovered = ECDSA.recover(digest, signature);
  says: validateDeposit recovers the order signer with ECDSA only.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x0736bdc975af0675b9a045384efed91360d25479'
  file: contracts/Aori.sol
  line: 116
  has: function pause() external onlyOwner {
  says: The owner can pause the contract.
  for:
  - evidence-2
- id: c60
  source: '0x0736bdc975af0675b9a045384efed91360d25479'
  file: contracts/AoriUtils.sol
  has: require(recovered == order.offerer, "InvalidSignature");
  line: 60
  says: Deposit requires the ECDSA-recovered signer to be the order's offerer.
  for:
  - evidence-1
  - justification
  - what
- id: c-transfer
  source: '0x0736bdc975af0675b9a045384efed91360d25479'
  file: contracts/AoriUtils.sol
  has: require(order.outputAmount > 0, "Invalid output amount");
  line: 30
  says: Output amount is only checked to be nonzero, so it is whatever the signer chose.
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
  who: Review13 (deployer trace, selector match against verified Aori, owner/pause reads; former finding unidentified-7dec965c-user-sig-ecdsa-only)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
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
  pattern: PQ-1
reviews: []
related: []
---

## What happens

Aori takes a user's ERC-20 deposit when a whitelisted solver submits an order whose EIP-712 signature ECDSA recovers to the offerer. A quantum attacker who recovers a user's key can sign an order paying the attacker, and a filling solver pulls that user's approved tokens.

## Evidence

- [validateDeposit](https://etherscan.io/address/0x0736bdc975af0675b9a045384efed91360d25479#code) recovers the signer with ECDSA and requires it to equal the offerer.
- [pause](https://etherscan.io/address/0x0736bdc975af0675b9a045384efed91360d25479#code) is owner-only, so the owner can stop deposits.

## Reviewer notes

### Mechanism

Aori.deposit(Order, bytes) and its hook variant (onlySolver, whenNotPaused) call AoriUtils.validateDeposit, which at line 59 runs ECDSA.recover(digest, signature) and at line 60 requires recovered == order.offerer. There is no isValidSignature call or account-code check. The deposit then transfers order.inputAmount of order.inputToken from the offerer via safeTransferFrom, so a forged order with an attacker-chosen recipient and outputAmount drains the offerer's allowance to Aori, including for users who moved to post-quantum authorisation. Post-quantum smart accounts cannot sign ERC-20 orders; depositNative needs no signature. The owner can pause() (Aori.sol line 116) to stop deposits; there is no upgrade path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy upgrade path: the code is not upgradeable.
- Ruled out: Contract's own holdings are about $0; exposure is users' allowances.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
