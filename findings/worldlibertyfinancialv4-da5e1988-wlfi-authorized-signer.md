---
id: worldlibertyfinancialv4-da5e1988-wlfi-authorized-signer
format: 2
title: WLFI token trusts one ECDSA voucher key a quantum attacker could recover
status: confirmed
severity: LOW
justification: A forged voucher only opens the caller's own allocation; World Liberty's Safe fixes it by upgrading
  the token.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xda5e1988097297dcdc1f90d4dfe7909e847cbef6'
  name: WorldLibertyFinancialV4
  project: world-liberty
  code: verified
  code_url: https://etherscan.io/address/0x73fe14ff5a25e4363a72828cccd8444f0748fde7#code
  proxy_of: '0x73fe14ff5a25e4363a72828cccd8444f0748fde7'
  copies: 1
  upgradeable: 'yes'
  admin: '0x7f533afa9e994b7e44673188034f9ce52886a0c0'
value:
  usd: 12222
  basis: held
activity:
  txs_90d: 106042
impact: liveness
action: Upgrade the token to verify activation and election vouchers with a post-quantum signature or an owner-written
  allow-list.
evidence_level: source
checks:
- id: c1
  source: '0x73fe14ff5a25e4363a72828cccd8444f0748fde7'
  file: contracts/libraries/oz-v5/immutable/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile.
  for:
  - evidence-3
  - what
- id: c3
  source: '0x73fe14ff5a25e4363a72828cccd8444f0748fde7'
  file: contracts/wlfi/WorldLibertyFinancialV2.sol
  line: 469
  has: if (authorizedSigner() != ECDSA.recover(hash, _signature)) {
  says: Account activation requires a voucher that recovers to authorizedSigner.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x73fe14ff5a25e4363a72828cccd8444f0748fde7'
  file: contracts/wlfi/WorldLibertyFinancialV3.sol
  line: 73
  has: if (authorizedSigner() != ECDSA.recover(hash, _signature)) {
  says: Vesting election requires a voucher that recovers to authorizedSigner.
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
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The WLFI token activates a legacy holder's account and changes its vesting election only when the voucher recovers to authorizedSigner via ECDSA. A quantum attacker who recovers that key can sign vouchers that let legacy holders unlock their own allocation without World Liberty's approval.

## Evidence

- [_validateSignatureForAccountActivationAndActivate](https://etherscan.io/address/0x73fe14ff5a25e4363a72828cccd8444f0748fde7#code) rejects activation unless ECDSA recovers authorizedSigner.
- [electVestingUpdate](https://etherscan.io/address/0x73fe14ff5a25e4363a72828cccd8444f0748fde7#code) rejects an election unless ECDSA recovers authorizedSigner.
- [tryRecover](https://etherscan.io/address/0x73fe14ff5a25e4363a72828cccd8444f0748fde7#code) derives the signer with the ecrecover precompile.

## Reviewer notes

### Mechanism

activateAccount / activateAccountAndClaimVest (WorldLibertyFinancialV2.sol 221-235) call _validateSignatureForAccountActivationAndActivate(msg.sender, sig) (466-474), which builds an EIP-712 hash of (ACTIVATION_TYPEHASH, account) and at line 469 requires authorizedSigner() == ECDSA.recover(hash, sig), then activates the caller in the Registry and starts its vest. electVestingUpdate (WorldLibertyFinancialV3.sol 66-79) checks the same signer at line 73 over (ELECTION_TYPEHASH, account, deadline) and moves the caller's vesting category. ECDSA.recover ends in ecrecover (ECDSA.sol 142). Both act on msg.sender only; blacklisted accounts stay blocked in _update. The owner (3-of-5 Safe) can do both without signatures and upgrades through the ProxyAdmin.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No permit selector in the current implementation.
- Ruled out: delegateBySig always reverts in V4.
- Ruled out: Rotating authorizedSigner does not remove the ECDSA dependency.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
