---
id: airdropvault-ea9f5cc5-zkp-airdrop-supervisor-signer
format: 2
title: zkPass ZKP airdrop vault pays claims signed by a quantum-forgeable ECDSA key
status: confirmed
severity: MEDIUM
justification: A forged supervisor signature releases vault ZKP; only the admin's upgrade to a new verifier fixes
  it, so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xea9f5cc526ad14cf34d6055fb16a43d3cd293712'
  name: AirdropVault
  project: zkpass
  code: verified
  code_url: https://etherscan.io/address/0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2#code
  proxy_of: '0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2'
  copies: 1
  upgradeable: 'yes'
  admin: '0xf827bebef3815781995c548560d48d53b1a929d8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade claims to a Merkle root or a post-quantum supervisor verifier, and move admin and supervisor roles
  to post-quantum accounts.
evidence_level: source
checks:
- id: c1
  source: '0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2'
  file: src/AirdropVault.sol
  line: 472
  has: (address signer, ECDSA.RecoverError error, ) = digest.tryRecover(
  says: The claim signature is recovered with ECDSA tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 190
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: s481
  source: '0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2'
  file: src/AirdropVault.sol
  has: return hasRole(SUPERVISOR_ROLE, signer);
  line: 481
  says: The recovered signer must hold SUPERVISOR_ROLE.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: s444
  source: '0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2'
  file: src/AirdropVault.sol
  has: zkpToken.safeTransfer(_recipient, _amount);
  line: 444
  says: The claim transfers ZKP to the recipient.
  for:
  - evidence-3
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
  who: Review00 (Blockscout verified source of the implementation; proxy slots, roles, vault state and event logs)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The vault pays ZKP airdrop claims to a recipient when ECDSA recovers a SUPERVISOR_ROLE holder from the claim's EIP-712 signature. A quantum attacker who derives a supervisor's key can sign claims for any recipient and amount and drain whatever the vault holds while claims are open.

## Evidence

- [verifySupervisorSignature](https://etherscan.io/address/0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2#code) recovers the signer with ECDSA tryRecover and accepts it if it holds SUPERVISOR_ROLE.
- [tryRecover](https://etherscan.io/address/0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2#code) obtains the signer from the ecrecover precompile.
- [processClaim](https://etherscan.io/address/0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2#code) transfers ZKP to the recipient after the signature check passes.

## Reviewer notes

### Mechanism

claim(recipient, amount, orderId, signature) (line 348) and supervisor-only delegateClaim (line 364) call processClaim (line 408). It checks tgeBlock <= block.number < claimDeadLineBlock, an unused orderId and totalAmount. It then requires verifySupervisorSignature (line 460), which builds the EIP-712 digest of (recipient, amount, orderId) (lines 466-470), calls ECDSA.tryRecover (line 472, ecrecover at ECDSA.sol line 190), requires NoError (line 477) and returns hasRole(SUPERVISOR_ROLE, signer) (line 481). On success it transfers ZKP with zkpToken.safeTransfer (line 444). The supervisor is an EOA, so its secp256k1 key can be derived from its public key by a quantum attacker. The admin (DEFAULT_ADMIN_ROLE) controls supervisors, the deadline and emergencyWithdraw, and upgrades go through the ProxyAdmin. At review the vault is paused, past its deadline and empty, so a forged claim pays out only if the admin refills it, unpauses it and moves the deadline.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Rotating the supervisor ECDSA key does not remove the exposure.
- Ruled out: No Ethereum protocol change is needed.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
