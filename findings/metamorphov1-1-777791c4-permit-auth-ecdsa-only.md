---
id: metamorphov1-1-777791c4-permit-auth-ecdsa-only
format: 2
title: Hyperithm USDC vault accepts ECDSA permits a quantum attacker could forge
status: confirmed
severity: HIGH
justification: Holders' shares stay forgeable via ECDSA permit after migrating; the vault code is fixed, so users
  must move.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x777791c4d6dc2ce140d00d2828a7c93503c67777'
  name: MetaMorphoV1_1
  project: morpho
  code: verified
  code_url: https://etherscan.io/address/0x777791c4d6dc2ce140d00d2828a7c93503c67777#code
  copies: 1
  admin: '0xee7e9bb21d5589bf657b94083db2fa349a3918c8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1139
impact: funds-loss
action: Move vault shares from migrated addresses to a fresh post-quantum account; ship future vaults that check
  account code and ERC-1271 first.
evidence_level: source
checks:
- id: c1
  source: '0x777791c4d6dc2ce140d00d2828a7c93503c67777'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  line: 61
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit gets the signer via ECDSA.recover and compares it to owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x777791c4d6dc2ce140d00d2828a7c93503c67777'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
- id: p66
  source: '0x777791c4d6dc2ce140d00d2828a7c93503c67777'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  has: _approve(owner, spender, value);
  line: 66
  says: permit grants the allowance over the owner's own shares
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

This vault issues ERC-20 shares with an ERC-2612 permit that sets an allowance when ECDSA recovers the owner from the signature. A quantum attacker who recovers a holder's key can sign a permit for that holder's shares, then transfer and redeem them.

## Evidence

- [permit](https://etherscan.io/address/0x777791c4d6dc2ce140d00d2828a7c93503c67777#code) recovers the signer with ECDSA.recover and approves the spender if it equals the owner.
- [tryRecover](https://etherscan.io/address/0x777791c4d6dc2ce140d00d2828a7c93503c67777#code) gets the signer from the ecrecover precompile, with no account-code or ERC-1271 path.

## Reviewer notes

### Mechanism

ERC20Permit.permit (lines 44-67) checks the deadline, builds the EIP-712 hash with _useNonce(owner), calls ECDSA.recover(hash, v, r, s) at line 61, reverts if signer != owner, then _approve(owner, spender, value) at line 66. ECDSA.tryRecover (line 142) relies solely on ecrecover. An attacker with the holder's secp256k1 key signs a permit to itself, then uses transferFrom/redeem on the holder's shares. Because the check never consults account code, it keeps working for an address that migrated in place to post-quantum authorisation. approve works by msg.sender, so post-quantum accounts are not locked out.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Attacker reaches only the signer's own shares, not other holders' shares.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
