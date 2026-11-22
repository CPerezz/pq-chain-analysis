---
id: vestingearndrop-d86193d0-signer
format: 2
title: Galxe VestingEarndrop accepts ECDSA signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: One ECDSA signer key guards pooled earndrop tokens; setSigner only swaps ECDSA keys, so Galxe must
  redeploy.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  name: VestingEarndrop
  project: galxe
  code: verified
  code_url: https://etherscan.io/address/0xd86193d0aefb386a4f8a6f1d024592f851c579f9#code
  copies: 1
  upgradeable: 'no'
  admin: '0x62e3bab5d52ae8551468e3dca23375629eab86e4'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Redeploy VestingEarndrop with a post-quantum signer check, such as an ML-DSA or hash-based backend key verifier.
evidence_level: source
checks:
- id: c1
  source: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  file: src/VestingEarndrop/VestingEarndrop.sol
  line: 384
  has: return ECDSA.recover(_hash, _signature) == signer;
  says: Signature check is ECDSA recovery compared to signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - evidence-1
  - what
- id: c3
  source: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  file: src/VestingEarndrop/VestingEarndrop.sol
  line: 93
  has: function setSigner(address _signer) external onlyOwner {
  says: Owner can only set a new signer address.
  for:
  - action
  - evidence-3
  - justification
- id: s-pull
  source: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  file: src/VestingEarndrop/VestingEarndrop.sol
  has: IERC20(tokenAddress).safeTransferFrom(msg.sender, address(this), totalAmount);
  line: 172
  says: Activation pulls the creator's tokens into the contract.
  for:
  - what
- id: s-pay
  source: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  file: src/VestingEarndrop/VestingEarndrop.sol
  has: IERC20(token).safeTransfer(recipient, amount);
  line: 333
  says: Payouts come from the contract's own token balance.
  for:
  - evidence-2
  - what
- id: s-act
  source: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  file: src/VestingEarndrop/VestingEarndrop.sol
  has: bool isVerified = _verifySignature(
  line: 151
  says: Activation requires a signer signature.
  for:
  - what
- id: s-claimsig
  source: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  file: src/VestingEarndrop/VestingEarndrop.sol
  has: bool isVerified = _verifySignature(_hashEarndropClaim(earndropId, params.leafIndex, msg.value), _signature);
  line: 230
  says: Claims require a signer signature.
  for:
  - what
- id: s-nocap
  source: '0xd86193d0aefb386a4f8a6f1d024592f851c579f9'
  file: src/VestingEarndrop/VestingEarndrop.sol
  has: earndrop.claimedAmount += params.amount;
  line: 243
  says: claimedAmount grows without a cap at totalAmount.
  for:
  - evidence-2
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

VestingEarndrop holds earndrop creators' tokens and pays claims from that pool. Activation and claims need a signature that ECDSA recovers to Galxe's signer key. A quantum attacker who derives that key can approve a fake earndrop and claim other earndrops' pooled tokens.

## Evidence

- [_verifySignature](https://etherscan.io/address/0xd86193d0aefb386a4f8a6f1d024592f851c579f9#code) accepts a signature if ECDSA recovers the stored signer.
- [claimEarndrop](https://etherscan.io/address/0xd86193d0aefb386a4f8a6f1d024592f851c579f9#code) adds to claimedAmount without capping it at totalAmount, then pays from the contract balance.
- [setSigner](https://etherscan.io/address/0xd86193d0aefb386a4f8a6f1d024592f851c579f9#code) lets the owner only replace the signer address.

## Reviewer notes

### Mechanism

activateEarndrop (l.107-176) checks _verifySignature over the earndrop parameters and msg.sender (l.151-153). It then pulls totalAmount from the creator into the contract (l.172). claimEarndrop (l.214-256) and multiClaimEarndrop (l.258-309) require a signer signature over (earndropId, leafIndex, value) (l.230, l.275) and a Merkle proof against the earndrop's own root. They add params.amount to claimedAmount with no check against totalAmount (l.243, l.296) and pay through _processTransfer from the contract's pooled balance of that token (l.253, l.298, l.333). _verifySignature is ECDSA.recover(_hash, _signature) == signer (l.384). With the signer key, an attacker activates an earndrop with a small totalAmount and a Merkle root listing large amounts in the same token. After the stage starts, the attacker claims and drains other creators' deposits of that token. setSigner (l.93, onlyOwner) only rotates the ECDSA address.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; the owner can only rotate the ECDSA signer.
- Ruled out: A forged claim signature alone pays nothing without a matching Merkle root.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
