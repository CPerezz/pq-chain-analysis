---
id: kyberswaprfq-7a819fa4-order-sig-ecdsa-first
format: 2
title: KyberSwap RFQ lets a quantum attacker forge orders of makers who migrated
status: confirmed
severity: MEDIUM
justification: Old ECDSA keys still fill migrated makers' orders; contract is not upgradeable, so KyberSwap must
  redeploy (MEDIUM).
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7a819fa46734a49d0112796f9377e024c350fb26'
  name: KyberSwapRFQ
  project: kyberswap
  code: verified
  code_url: https://etherscan.io/address/0x7a819fa46734a49d0112796f9377e024c350fb26#code
  copies: 1
  upgradeable: 'no'
  admin: '0xbe2f0354d970265bfc36d383af77f72736b81b54'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 18681
impact: funds-loss
action: Deploy an RFQ contract that checks maker code first and passes signatures of any length to ERC-1271.
evidence_level: source
checks:
- id: c1
  source: '0x7a819fa46734a49d0112796f9377e024c350fb26'
  file: contracts/rfq/KyberSwapRFQ.sol
  line: 200
  has: (address recoveredSigner, ) = ECDSA.tryRecover(orderHash, signature);
  says: _validate runs ECDSA.tryRecover on the maker's signature first
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x7a819fa46734a49d0112796f9377e024c350fb26'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses ecrecover
  for:
  - what
- id: c3
  source: '0x7a819fa46734a49d0112796f9377e024c350fb26'
  file: contracts/rfq/KyberSwapRFQ.sol
  has: if (recoveredSigner != signer) {
  line: 202
  says: ERC-1271 is consulted only when ECDSA recovery does not match the maker
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x7a819fa46734a49d0112796f9377e024c350fb26'
  file: contracts/rfq/KyberSwapRFQ.sol
  has: 'require(recoveredSigner != address(0), ''KS_RFQ: invalid signer'');'
  line: 201
  says: reverts when ECDSA recovery fails
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c5
  source: '0x7a819fa46734a49d0112796f9377e024c350fb26'
  file: contracts/rfq/KyberSwapRFQ.sol
  has: IERC20(order.makerAsset).safeTransferFrom(maker, target, makingAmount);
  line: 178
  says: maker's tokens are pulled to the taker's target
  for:
  - evidence-3
  - what
- id: c6
  source: '0x7a819fa46734a49d0112796f9377e024c350fb26'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  has: return (address(0), RecoverError.InvalidSignatureLength);
  line: 70
  says: signatures that are not 65 bytes recover to address zero
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
  who: Review13 (re-read verified source on Sourcify; storage, owner and maker reads)
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
  pattern: PQ-2
reviews: []
related: []
---

## What happens

KyberSwapRFQ fills signed maker orders, pulling the maker's approved tokens to the taker. An order passes if ECDSA recovers the maker; ERC-1271 runs only otherwise, so a quantum attacker with a migrated maker's old key fills its orders at any price. Non-65-byte signatures are rejected.

## Evidence

- [_validate](https://etherscan.io/address/0x7a819fa46734a49d0112796f9377e024c350fb26#code) runs ECDSA recovery first and calls the maker's ERC-1271 check only if the recovered address differs.
- [_validate](https://etherscan.io/address/0x7a819fa46734a49d0112796f9377e024c350fb26#code) reverts when recovery returns no address, which happens for any signature not 65 bytes long.
- [fillOrderRFQTo](https://etherscan.io/address/0x7a819fa46734a49d0112796f9377e024c350fb26#code) transfers the maker's makerAsset to the target after validation.

## Reviewer notes

### Mechanism

fillOrderRFQTo (line 116) hashes the order and calls _validate(maker, orderHash, signature) at line 170. _validate (lines 195-211) calls ECDSA.tryRecover (line 200). For any signature not 65 bytes, tryRecover returns address(0) (ECDSA.sol lines 56-70). Otherwise it uses ecrecover (line 139). Line 201 requires a non-zero recovered address, so non-65-byte signatures revert before ERC-1271 is reached. isValidSignature is called only if the recovered address differs from the maker (line 202). If the old ECDSA key recovers to the maker's address, the order is accepted even if that address now carries post-quantum authorisation. Line 178 then calls safeTransferFrom(maker, target, makingAmount), so the attacker sets the price in the forged order. The contract is not a proxy.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract makers whose address has no ECDSA key are not forgeable through ecrecover in this contract.
- Ruled out: The contract holds about no funds itself; exposure is makers' approvals.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
