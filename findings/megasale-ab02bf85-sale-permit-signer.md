---
id: megasale-ab02bf85-sale-permit-signer
format: 2
title: MegaETH token sale lets a forged Sonar permit admit any wallet to bid
status: confirmed
severity: LOW
justification: A forged permit only admits a bid the attacker pays for, and the auction is closed; admin keeps it
  shut.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xab02bf85a7a851b6a379ea3d5bd3b9b4f5dd8461'
  name: MegaSale
  project: megaeth
  code: verified
  code_url: https://etherscan.io/address/0xab02bf85a7a851b6a379ea3d5bd3b9b4f5dd8461#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 20
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Keep the sale in stage Done or revoke the permit-signer role; verify a post-quantum signer in future sales.
evidence_level: source
checks:
- id: c1
  source: '0xab02bf85a7a851b6a379ea3d5bd3b9b4f5dd8461'
  file: ../../../contracts/src/sales/permits/PurchasePermitWithAllocation.sol
  line: 28
  has: return ECDSA.recover(digest(permit), signature);
  says: recoverSigner uses ECDSA.recover over the permit digest
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xab02bf85a7a851b6a379ea3d5bd3b9b4f5dd8461'
  file: src/MegaSale.sol
  line: 456
  has: address recoveredSigner = PurchasePermitWithAllocationLib.recoverSigner(permit, signature);
  says: _validatePurchasePermit gets the permit signer from recoverSigner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c6
  source: '0xab02bf85a7a851b6a379ea3d5bd3b9b4f5dd8461'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: OpenZeppelin ECDSA calls the ecrecover precompile
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
  who: Review14 (MegaSale source, stage and role reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

MegaSale admits a bid only with a purchase permit whose ECDSA signature recovers to the permit-signer role holder. A quantum attacker who recovers that signer key could sign permits that let any wallet bid past KYC and allocation limits, paying its own USDT.

## Evidence

- [_validatePurchasePermit](https://etherscan.io/address/0xab02bf85a7a851b6a379ea3d5bd3b9b4f5dd8461#code) takes the permit signer from PurchasePermitWithAllocationLib.recoverSigner.
- [recoverSigner](https://etherscan.io/address/0xab02bf85a7a851b6a379ea3d5bd3b9b4f5dd8461#code) returns ECDSA.recover over the hashed permit.

## Reviewer notes

### Mechanism

replaceBidWithApproval (onlyStage Auction) calls _processBid, then _validatePurchasePermit (MegaSale.sol around lines 440-460). That function checks saleUUID, expiry and permit.wallet == msg.sender, then at line 456 calls PurchasePermitWithAllocationLib.recoverSigner. recoverSigner (PurchasePermitWithAllocation.sol line 28) returns ECDSA.recover(toEthSignedMessageHash(abi.encode(permit)), signature). The recovered address must hold PURCHASE_PERMIT_SIGNER_ROLE. The permit sets minAmount, maxAmount and reservedAmount. The bid's USDT is pulled from msg.sender, so a forged permit admits only a bid the attacker pays for. The sale is in stage Done, which closes the bid path. Reopening it needs the admin to call setManualStage(Auction).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Refunds and withdrawals do not use the permit signer
- Ruled out: Bids are paid from the bidder's own USDT, so other users' funds are not taken

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
