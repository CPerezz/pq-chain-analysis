---
id: generalinstantpaymentlsd-07c78007-signer
format: 2
title: Galxe GeneralInstantPaymentLSD trusts an ECDSA signer a quantum attacker forges
status: confirmed
severity: MEDIUM
justification: Deposit authorisations rest on one ECDSA key; the owner can only rotate it, so Galxe must redeploy
  (MEDIUM).
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x07c78007ddcffa630fd908a815165e5b0af0c4f2'
  name: GeneralInstantPaymentLSD
  project: galxe
  code: verified
  code_url: https://etherscan.io/address/0x07c78007ddcffa630fd908a815165e5b0af0c4f2#code
  copies: 1
  upgradeable: 'no'
  admin: '0x73eb342ebc92a4b77942b6cab927ad5faed595be'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Redeploy with a post-quantum signer check, such as an ERC-7913 verifier for an ML-DSA or hash-based backend
  key.
evidence_level: source
checks:
- id: c1
  source: '0x07c78007ddcffa630fd908a815165e5b0af0c4f2'
  file: '@openzeppelin-v5/contracts/utils/cryptography/ECDSA.sol'
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile.
  for:
  - evidence-1
  - what
- id: c2
  source: '0x07c78007ddcffa630fd908a815165e5b0af0c4f2'
  file: contracts/GeneralInstantPayment/GeneralInstantPaymentLSD.sol
  line: 581
  has: return ECDSA.recover(_hash, _signature) == signer;
  says: _verify accepts a signature when ECDSA recovers the stored signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c6
  source: '0x07c78007ddcffa630fd908a815165e5b0af0c4f2'
  file: contracts/GeneralInstantPayment/GeneralInstantPaymentLSD.sol
  line: 132
  has: function setSigner(address _signer) external onlyOwner {
  says: setSigner, owner-only, only replaces the signer address.
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
- study: top-callers-classification
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

GeneralInstantPaymentLSD accepts deposits only with a signature from Galxe's backend signer, checked by ECDSA recovery. A quantum attacker who recovers that key can forge deposit authorisations; the owner can only swap in another ECDSA signer.

## Evidence

- [_verify](https://etherscan.io/address/0x07c78007ddcffa630fd908a815165e5b0af0c4f2#code) returns true when ECDSA.recover of the hash equals the stored signer.
- [setSigner](https://etherscan.io/address/0x07c78007ddcffa630fd908a815165e5b0af0c4f2#code) is owner-only and stores a new signer address, still checked with ECDSA.

## Reviewer notes

### Mechanism

The deposit entry points hash the deposit parameters with EIP-712 (_hashDeposit, l.584-610, typed Deposit(user, depositToken, depositAmount, taskId, taskFee, permit, messageFee)) and require _verify (l.580-582): ECDSA.recover(_hash, _signature) == signer, which uses ecrecover (ECDSA.sol l.142). The deposit is then pulled from msg.sender via _transfer/_transferByPermit (l.549-578) and forwarded to the saving contracts. setSigner (l.132-137, onlyOwner) only replaces the ECDSA signer address, so a key recovered by a quantum computer remains forgeable after rotation to any other ECDSA key.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Forged authorisations move only the caller's own deposit; deposits pull funds from msg.sender.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
