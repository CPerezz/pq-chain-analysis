---
id: metamorpho-beefff20-permit-auth-ecdsa-only
format: 2
title: Smokehouse USDC vault takes ECDSA permits a quantum attacker could forge
status: confirmed
severity: HIGH
justification: Holders' shares stay forgeable after migration; the vault is immutable, so only each user moving
  protects them.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbeefff209270748ddd194831b3fa287a5386f5bc'
  name: MetaMorpho
  project: morpho
  code: verified
  code_url: https://etherscan.io/address/0xbeefff209270748ddd194831b3fa287a5386f5bc#code
  copies: 1
  admin: '0x0a0e559bc3b0950a7e448f0d4894db195b9cf8dd'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5652
impact: funds-loss
action: Move vault shares from migrated addresses to a fresh post-quantum account; use approve directly until then.
evidence_level: source
checks:
- id: c1
  source: '0xbeefff209270748ddd194831b3fa287a5386f5bc'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0xbeefff209270748ddd194831b3fa287a5386f5bc'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  line: 61
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA only
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0xbeefff209270748ddd194831b3fa287a5386f5bc'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  has: _approve(owner, spender, value);
  line: 66
  says: permit grants the allowance after the signer check
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
  pattern: PQ-1
reviews: []
related: []
---

## What happens

This MetaMorpho vault's ERC-2612 permit grants an allowance when ECDSA recovers the owner from the signature. A quantum attacker who recovers a holder's key can permit itself the holder's shares, then transfer and redeem them, even after the holder migrates.

## Evidence

- [permit](https://etherscan.io/address/0xbeefff209270748ddd194831b3fa287a5386f5bc#code) sets an allowance once ECDSA.recover returns the owner.
- [ECDSA.tryRecover](https://etherscan.io/address/0xbeefff209270748ddd194831b3fa287a5386f5bc#code) gets the signer from the ecrecover precompile.

## Reviewer notes

### Mechanism

ERC20Permit.permit (lines 44-67) checks the deadline and builds the EIP-712 hash with _useNonce(owner). At line 61 it calls ECDSA.recover(hash, v, r, s), which calls ecrecover at ECDSA.sol line 142. If the signer equals owner, line 66 calls _approve(owner, spender, value). There is no ERC-1271 path and no account-code check. With a forged permit, the attacker calls transferFrom and redeem on the holder's shares. approve works by msg.sender, so post-quantum accounts are not locked out.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Ownership functions (transferOwnership) do not touch the permit signature check.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
