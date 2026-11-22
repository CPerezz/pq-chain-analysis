---
id: generalinstantpaymentlsdtreasurer-5f17bf77-signer
format: 2
title: Galxe LSD Treasurer trusts an ECDSA signer that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Deposit approvals rest on one ECDSA key; the owner can only rotate it, so Galxe must redeploy with
  a post-quantum check.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5f17bf773aba7f0f877db4ac82861c198891d1f9'
  name: GeneralInstantPaymentLSDTreasurer
  project: galxe
  code: verified
  code_url: https://etherscan.io/address/0x5f17bf773aba7f0f877db4ac82861c198891d1f9#code
  copies: 1
  upgradeable: 'no'
  admin: '0x78a6c322fe2b4a8ae7124702d92d3bf954e75e94'
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
  source: '0x5f17bf773aba7f0f877db4ac82861c198891d1f9'
  file: '@openzeppelin-v5/contracts/utils/cryptography/ECDSA.sol'
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile.
  for:
  - evidence-1
  - what
- id: c2
  source: '0x5f17bf773aba7f0f877db4ac82861c198891d1f9'
  file: contracts/GeneralInstantPayment/GeneralInstantPaymentLSDTreasurer.sol
  line: 614
  has: return ECDSA.recover(_hash, _signature) == signer;
  says: _verify accepts only signatures that ECDSA-recover to signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c6
  source: '0x5f17bf773aba7f0f877db4ac82861c198891d1f9'
  file: contracts/GeneralInstantPayment/GeneralInstantPaymentLSDTreasurer.sol
  line: 133
  has: function setSigner(address _signer) external onlyOwner {
  says: The owner can only set a new signer address.
  for:
  - action
  - evidence-2
  - justification
- id: dep-type
  source: '0x5f17bf773aba7f0f877db4ac82861c198891d1f9'
  file: contracts/GeneralInstantPayment/GeneralInstantPaymentLSDTreasurer.sol
  has: '"Deposit(address user,address depositToken,uint256 depositAmount,uint256 taskId,uint256 taskFee,bytes32
    permit,uint256 messageFee,bytes32[] transferTokens)"'
  line: 633
  says: the line or bytes the card cites
  for:
  - what
- id: bt-from
  source: '0x5f17bf773aba7f0f877db4ac82861c198891d1f9'
  file: contracts/GeneralInstantPayment/GeneralInstantPaymentLSDTreasurer.sol
  has: IERC20(_token).safeTransferFrom(msg.sender, t.treasurer, t.transferAmount);
  line: 600
  says: the line or bytes the card cites
  for:
  - evidence-3
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

The contract accepts Galxe task deposits only with an EIP-712 Deposit approval that ECDSA recovers to Galxe's backend signer. A quantum attacker who derives that key can forge deposit approvals with any task and fee values. The deposit and treasurer transfers are pulled from the caller.

## Evidence

- [_verify](https://etherscan.io/address/0x5f17bf773aba7f0f877db4ac82861c198891d1f9#code) accepts a signature only if ECDSA recovers the stored signer.
- [setSigner](https://etherscan.io/address/0x5f17bf773aba7f0f877db4ac82861c198891d1f9#code) lets the owner swap the signer address, which stays an ECDSA key.
- [_batchTransfer](https://etherscan.io/address/0x5f17bf773aba7f0f877db4ac82861c198891d1f9#code) pays treasurers in tokens with safeTransferFrom from msg.sender.

## Reviewer notes

### Mechanism

Deposit entry points hash their parameters with _hashDeposit (l.617-646, EIP-712 Deposit typehash at l.633 covering user, token, amount, taskId, taskFee, permit, messageFee and transferTokens). They then call _verify (l.613-615), which does ECDSA.recover(_hash, _signature) == signer, and ECDSA.recover uses ecrecover (ECDSA.sol l.142). setSigner (l.133-138, onlyOwner) only replaces the ECDSA address. Token transfers to treasurers in _batchTransfer (l.593-603) use safeTransferFrom(msg.sender, ...). ETH transfers are bounded by checkIfNeedRefund (l.107-118), where refund = _sent - spent reverts on underflow. So a forged approval spends the caller's own funds, and its effect lands in Galxe's off-chain task accounting.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Forged approvals do not pull tokens from third parties: transfers come from msg.sender.
- Ruled out: Contract is not a proxy; signer replacement is the owner's only lever.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
