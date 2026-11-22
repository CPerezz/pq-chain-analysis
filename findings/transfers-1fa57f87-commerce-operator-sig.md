---
id: transfers-1fa57f87-commerce-operator-sig
format: 2
title: Coinbase Commerce Transfers relies on an ECDSA operator key for payment intents
status: confirmed
severity: LOW
justification: 'LOW: forged intents move no funds as payers fund them; PQ operator needs a new deployment by Coinbase.'
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1fa57f879417e029ef57d7ce915b0aa56a507c31'
  name: Transfers
  project: coinbase
  code: verified
  code_url: https://etherscan.io/address/0x1fa57f879417e029ef57d7ce915b0aa56a507c31#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8899cecfd929504414696c734eaf6300fdbb428c'
value:
  usd: 136
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Deploy a Transfers version that verifies operator intents via ERC-1271/ERC-7913, or pause this one.
evidence_level: source
checks:
- id: c2
  source: '0x1fa57f879417e029ef57d7ce915b0aa56a507c31'
  file: contracts/transfers/Transfers.sol
  line: 105
  has: address signer = ECDSA.recover(signedMessageHash, _intent.signature);
  says: validIntent recovers the intent signer with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c6
  source: '0x1fa57f879417e029ef57d7ce915b0aa56a507c31'
  file: contracts/transfers/Transfers.sol
  line: 809
  has: function pause() external onlyOwner {
  says: The owner can pause the contract.
  for:
  - action
  - evidence-3
  - justification
- id: chk-op
  source: '0x1fa57f879417e029ef57d7ce915b0aa56a507c31'
  file: contracts/transfers/Transfers.sol
  has: if (signer != _intent.operator) {
  line: 107
  says: Signer must equal the intent operator.
  for:
  - evidence-1
  - what
- id: chk-sender
  source: '0x1fa57f879417e029ef57d7ce915b0aa56a507c31'
  file: contracts/transfers/Transfers.sol
  has: sender,
  line: 91
  says: Intent hash binds the sender.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

Transfers processes a payment only when the intent's operator signature recovers via ECDSA to the named operator. A quantum attacker with the operator key can issue intents in Coinbase's name, but the intent is bound to the sender who funds it.

## Evidence

- [validIntent](https://etherscan.io/address/0x1fa57f879417e029ef57d7ce915b0aa56a507c31#code) recovers the signer with ECDSA and reverts unless it equals the intent's operator.
- [validIntent](https://etherscan.io/address/0x1fa57f879417e029ef57d7ce915b0aa56a507c31#code) hashes the sender into the signed intent.
- [pause](https://etherscan.io/address/0x1fa57f879417e029ef57d7ce915b0aa56a507c31#code) lets the owner stop payments.

## Reviewer notes

### Mechanism

Each payment function carries validIntent(intent, sender) (Transfers.sol lines 79-124): it keccak-hashes the intent fields with block.chainid, sender and address(this) (lines 80-94), applies the EIP-191 or a custom prefix (97-103), and requires ECDSA.recover(signedMessageHash, intent.signature) == intent.operator (105-109), then checks deadline, non-zero recipient and that the id is unprocessed. operatorIsRegistered (128-129) only requires a fee destination; registerOperator/registerOperatorWithFeeDestination (789-800) are permissionless. Sender is the msg.sender (or the permit payer in subsidizedTransferToken), who supplies the funds, so a forged operator signature yields intents the attacker must fund themselves; it can burn intent ids and emit Transferred events under Coinbase's operator id. An operator holding only a post-quantum key cannot sign intents, since there is no ERC-1271 path in validIntent.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Payer funds cannot be pulled with a forged operator signature: the intent is bound to the funding sender.
- Ruled out: Contract is not upgradeable; fix requires a new deployment.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
