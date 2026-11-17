---
id: keyring-rsa-credentials
title: "Keyring Network: a factored issuer RSA key lets anyone mint KeyringCore compliance credentials for any address, bypassing KYC gates of permissioned DeFi"
project: keyring
status: confirmed
severity: LOW
patterns: [PQ-10]
primitives: [rsa]
trigger: issuer-key
impact: none
alternative: configurable-verifier
role: core
contracts:
- address: "0x899cbf89b644e79f9042c4c96fc513d31063872b"
  implementation: null
  name: RSASignatureChecker
  upgradeable: config-only
  admin: none on the checker; KeyringCore 0xb0b5e2176e10b12d70e60e3a68738298a7dfe666 DEFAULT_ADMIN_ROLE Safe 0x39e9922ac1c57e96f0165ce62c6d3582ca24c46a (2 of 4) can replace it with setSignatureChecker
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-10
  txs_30d: 23
families: []
fix:
  layer: onchain-config
  who_acts: Keyring; the KeyringCore 0xb0b5e2176e10b12d70e60e3a68738298a7dfe666 admin Safe 0x39e9922ac1c57e96f0165ce62c6d3582ca24c46a (2 of 4) calls setSignatureChecker with a post-quantum checker, and the key manager Safe 0x4173b60205d3397495a329a2b7ed6f8b9920460f registers post-quantum issuer keys and revokes the RSA ones
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/keyring-rsa-credentials/classification.jsonl
  - evidence/keyring-rsa-credentials/onchain.json
  - evidence/keyring-rsa-credentials/activity.json
  - evidence/keyring-rsa-credentials/source-excerpts.md
  - evidence/keyring-rsa-credentials/onchain-review.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review02 (registry review)
  ref: evidence/keyring-rsa-credentials/onchain-review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Keyring's KeyringCore (`0xb0b5e217…`) records a compliance credential for an address when given an RSA (PKCS#1 v1.5,
SHA-256, e = 3) signature by a registered issuer key, checked by RSASignatureChecker `0x899cbf89…` (PQ-10). A quantum
attacker who factors an issuer modulus can create credentials for any address and policy, so unapproved addresses pass
`checkCredential` in the protocols that gate access with Keyring. Nothing is paid out by the check itself; the harm is
a compliance bypass, and the value behind the gated protocols is not measured. Rated LOW (step 4): the KeyringCore
admin Safe can switch the checker with one setting, and nothing can be taken through the check.

## Mechanism

- `KeyringCore.createCredential(tradingAddress, policyId, chainId, validUntil, cost, key, signature, backdoor)`
  (payable, anyone) checks cost and chain id, then `signatureChecker.checkSignature(...)`; it then requires that
  `keccak256(key)` is a registered, valid issuer key and sets `_entityData[policyId][tradingAddress].exp = validUntil`
  (`src/KeyringCore.sol` lines 121–190). `checkCredential(policyId, entity)` returns true until that expiry.
- `RSASignatureChecker.checkSignature` packs the message and calls `pkcs1Sha256Raw(message, signature, e = 0x03, key)`,
  which runs `modexp` (precompile 0x05) with the issuer's modulus and compares the PKCS#1 SHA-256 encoding
  (`src/signatureCheckers/RSASignatureChecker.sol` lines 56–113;
  [`source-excerpts.md`](../evidence/keyring-rsa-credentials/source-excerpts.md)).
- `setSignatureChecker(address)` is `onlyRole(DEFAULT_ADMIN_ROLE)` (line 111); `registerKey`/`revokeKey` are
  `onlyRole(KEY_MANAGER_ROLE)`; upgrades need `UPGRADER_ROLE`.

## Evidence

- CHECKED (verified source: checker on Blockscout, KeyringCore implementation `0x2b3cf9e7…` on Sourcify): the path
  above.
- CHECKED (on-chain read at block 26,431,454, [`onchain-review.json`](../evidence/keyring-rsa-credentials/onchain-review.json)):
  KeyringCore proxy `0xb0b5e217…` (found from the last recorded call, a `createCredential` transaction in block
  26,385,463) has EIP-1967 implementation `0x2b3cf9e7…` and `signatureChecker()` = `0x899cbf89…`;
  `DEFAULT_ADMIN_ROLE` is held by Safe `0x39e9922a…` (2 of 4), `UPGRADER_ROLE` by Safe `0xec0fdc75…` (1 of 1),
  `KEY_MANAGER_ROLE` by Safe `0x4173b602…` (1 of 2). Role holders were checked for the addresses in the proxy's
  initialisation calldata; later grants were not enumerated.
- CHECKED (on-chain read at block 26,431,214, [`onchain.json`](../evidence/keyring-rsa-credentials/onchain.json)): the
  checker is a plain contract holding nothing.
- CHECKED (Xatu, [`activity.json`](../evidence/keyring-rsa-credentials/activity.json)): 23 transactions 2026-10-16 to
  2026-11-16, last 2026-11-10; 383 pre-quantum transactions in the last year (`txs_y1`,
  `data/report/curated_contracts.csv`).
- INFERRED: KeyringCore's 0.32 ETH balance is credential fees for `OPERATOR_ROLE`; a forged credential does not
  release it.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x899cbf89…` RSASignatureChecker | config-only (replaced via KeyringCore) | — | 2026-11-10 | 23 |

Exposure: a forged credential lets an address that Keyring did not approve into protocols that call
`KeyringCore.checkCredential` (permissioned pools and vaults). The attacker gets access, not other users' funds, so
`impact` is `none`; the value held by those gated protocols was not measured and `value_usd` is null. Other contracts
named KeyringCore on Blockscout (`0xebf01b53…`, `0x05b6eeb5…` and others) were not in the census data and were not
checked.

## Remediation

- Replacement: a post-quantum signature checker (ML-DSA or SLH-DSA) implementing `ISignatureChecker`, with Keyring's
  off-chain issuer signing credentials with the matching post-quantum key.
- Who acts: Keyring. Admin Safe `0x39e9922a…` (2 of 4) calls `setSignatureChecker`; key manager Safe `0x4173b602…`
  registers the new issuer keys and `revokeKey`s the RSA ones (revoking alone stops forged credentials at the cost of
  all new credentials). No protocol change is needed.
- Consumers: protocols gating on Keyring can also require a credential issued after the switch.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review02): MEDIUM -> LOW, step 4: one known admin (KeyringCore DEFAULT_ADMIN_ROLE Safe 0x39e9922a…, 2 of 4, read at block 26,431,454) switches the checker with `setSignatureChecker`, and a forged credential bypasses compliance without taking funds. Impact unknown -> none; checker upgradeable "no" -> config-only.
