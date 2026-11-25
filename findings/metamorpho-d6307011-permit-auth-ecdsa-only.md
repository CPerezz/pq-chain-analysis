---
id: metamorpho-d6307011-permit-auth-ecdsa-only
format: 2
title: MetaMorpho vault accepts ECDSA permits a quantum attacker could forge
status: confirmed
severity: HIGH
justification: Vault shares stay permit-forgeable after a holder migrates; the vault code is fixed, so each user
  must move funds.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd63070114470f685b75b74d60eec7c1113d33a3d'
  name: MetaMorpho
  project: morpho
  code: verified
  code_url: https://etherscan.io/address/0xd63070114470f685b75b74d60eec7c1113d33a3d#code
  copies: 1
  admin: '0x38afc3aa2c76b4ca1f8e1daba68e998e1f4782db'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 448
impact: funds-loss
action: Move vault shares from migrated addresses to a fresh post-quantum account; use approve directly instead
  of permit.
evidence_level: source
checks:
- id: c1
  source: '0xd63070114470f685b75b74d60eec7c1113d33a3d'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile
  for:
  - evidence-3
  - justification
  - what
- id: c2
  source: '0xd63070114470f685b75b74d60eec7c1113d33a3d'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  line: 61
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA.recover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c62
  source: '0xd63070114470f685b75b74d60eec7c1113d33a3d'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  has: if (signer != owner) {
  line: 62
  says: permit requires recovered signer to equal owner
  for:
  - evidence-1
- id: c66
  source: '0xd63070114470f685b75b74d60eec7c1113d33a3d'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  has: _approve(owner, spender, value);
  line: 66
  says: permit grants allowance over the owner's shares
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

This MetaMorpho vault issues ERC-20 shares with an ERC-2612 permit that grants an allowance when an ECDSA signature recovers to the owner. A quantum attacker who recovers a holder's secp256k1 key can permit itself that holder's shares, then transfer and redeem them.

## Evidence

- [permit](https://etherscan.io/address/0xd63070114470f685b75b74d60eec7c1113d33a3d#code) recovers the signer with ECDSA and requires it to equal the owner.
- [permit](https://etherscan.io/address/0xd63070114470f685b75b74d60eec7c1113d33a3d#code) then sets the owner's allowance for the spender.
- [tryRecover](https://etherscan.io/address/0xd63070114470f685b75b74d60eec7c1113d33a3d#code) derives the signer from the ecrecover precompile.

## Reviewer notes

### Mechanism

ERC20Permit.permit (lines 44-67) checks the deadline, builds the EIP-712 hash with _useNonce(owner), and calls ECDSA.recover(hash, v, r, s) at line 61, which uses ecrecover in tryRecover (ECDSA.sol line 142). If the recovered signer equals owner (line 62), _approve(owner, spender, value) runs at line 66. There is no ERC-1271 path and no account-code check, so a forged secp256k1 signature for a holder grants the attacker an allowance; the attacker then uses transferFrom and redeem to take the holder's shares and underlying USDC. This keeps working after the holder's address adopts post-quantum authorization. approve by msg.sender remains available, so post-quantum accounts are not locked out.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Owner functions such as transferOwnership do not alter the permit signature check.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
