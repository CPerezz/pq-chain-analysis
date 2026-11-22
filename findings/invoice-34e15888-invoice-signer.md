---
id: invoice-34e15888-invoice-signer
format: 2
title: BitPay Invoice trusts one ECDSA quote key a quantum attacker could forge
status: confirmed
severity: LOW
justification: One ECDSA key signs quotes and owns withdraw; the path is dormant, so LOW; BitPay fixes it by a new
  deployment.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x34e158883efc81c5d92fde785fba48db738711ee'
  name: Invoice
  project: bitpay
  code: verified
  code_url: https://etherscan.io/address/0x34e158883efc81c5d92fde785fba48db738711ee#code
  copies: 1
  upgradeable: 'no'
  admin: '0x2730ef3c0c180e7f7bcfca249c757421b208e333'
value:
  usd: 13
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Retire the contract, or deploy a replacement verifying quotes via ERC-1271 or a post-quantum scheme with
  a post-quantum owner.
evidence_level: source
checks:
- id: c2
  source: '0x34e158883efc81c5d92fde785fba48db738711ee'
  file: Invoice.sol
  line: 59
  has: require(ecrecover(payloadHash, v, r, s) == quoteSigner, "Signature mismatch for quote");
  says: validatePayment requires the quote to ECDSA-recover to quoteSigner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x34e158883efc81c5d92fde785fba48db738711ee'
  file: Invoice.sol
  line: 102
  has: function setSigner(address newQuoteSigner) public isAdmin {
  says: owner can replace the quote signer
  for:
  - action
  - evidence-3
  - justification
  - what
- id: p1
  source: '0x34e158883efc81c5d92fde785fba48db738711ee'
  file: Invoice.sol
  has: require(token.safeTransferFrom(msg.sender, address(this), value), "Transfer must succeed");
  line: 81
  says: pay pulls the payer's tokens into the contract
  for:
  - what
- id: w1
  source: '0x34e158883efc81c5d92fde785fba48db738711ee'
  file: Invoice.sol
  has: function withdraw(address tokenContract) public isAdmin {
  line: 92
  says: withdraw is owner-only
  for:
  - evidence-2
  - justification
  - what
- id: m1
  source: '0x34e158883efc81c5d92fde785fba48db738711ee'
  file: Invoice.sol
  has: require(msg.sender == owner, "Must be the contract owner");
  line: 88
  says: isAdmin checks the caller is the owner
  for:
  - evidence-2
- id: a1
  source: '0x34e158883efc81c5d92fde785fba48db738711ee'
  file: Invoice.sol
  has: function setAdmin(address newAdmin) public isAdmin {
  line: 105
  says: owner can transfer ownership
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
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The contract takes ETH or token payments for BitPay invoices and marks an invoice paid only with a quote that ECDSA recovers to quoteSigner. A quantum attacker who recovers the signer key forges quotes; holding the owner key, it calls withdraw, setSigner and setAdmin.

## Evidence

- [validatePayment](https://etherscan.io/address/0x34e158883efc81c5d92fde785fba48db738711ee#code) requires ecrecover of the quote hash to equal quoteSigner.
- [withdraw](https://etherscan.io/address/0x34e158883efc81c5d92fde785fba48db738711ee#code) is guarded by isAdmin, which checks msg.sender against the owner.
- [setSigner](https://etherscan.io/address/0x34e158883efc81c5d92fde785fba48db738711ee#code) lets the owner replace the quote signer.

## Reviewer notes

### Mechanism

pay (lines 64-85) calls validatePayment (lines 42-61), which requires an unpaid payload (53), an unexpired quote (54), a hash match (58) and ecrecover(prefixed keccak(value, gasPrice, expiration, payload, tokenContract)) == quoteSigner (59). Then the token is pulled with safeTransferFrom (81) or msg.value is used, isPaid[payload] is set (83) and PaymentAccepted emitted. isValidPayment (38) has the same check as a view. withdraw (92-100) sends the contract's whole ETH or token balance to owner under the isAdmin modifier (88). setSigner (102) and setAdmin (105) are also owner-only. On-chain, owner() equals quoteSigner(), an EOA, so one ECDSA key controls both quotes and funds. The contract was swept and its signer reset in July 2026 and is dormant.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A forged quote moves only the payer's own funds into the contract; it cannot take third-party funds.
- Ruled out: Not upgradeable; only signer and owner are configurable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
