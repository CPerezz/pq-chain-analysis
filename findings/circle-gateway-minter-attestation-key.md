---
id: circle-gateway-minter-attestation-key
title: "Circle Gateway: a quantum attacker who recovers GatewayMinter's one ECDSA attestation key can mint up to $137M of USDC, EURC and cirBTC on mainnet to any address"
project: circle
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x2222222d7164433c4c09b0b0d809a9b52c04c205"
  implementation: "0xc2ff68068362aea1ca22a3896d05b2b812ce51b1"
  name: ERC1967Proxy -> GatewayMinter
  upgradeable: "yes"
  admin: "UUPS owner 0x3c54ffa14d01ef3a555106007a4fed6e8964aab6 (EOA; upgrades, adds/removes attestation signers, sets mint authorities); read at block 26431457"
  value_usd: 136550429
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-17
  txs_30d: null
families: []
fix:
  layer: contract-upgrade
  who_acts: "Circle: GatewayMinter owner 0x3c54ffa14d01ef3a555106007a4fed6e8964aab6 upgrades the implementation to verify post-quantum attestations; Circle as master minter of USDC, EURC and cirBTC can also lower the minter allowances"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431457
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-gateway-minter-attestation-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: Review09 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-gateway-minter-attestation-key/review-reads.json
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
related: [circle-gateway-burn-signer, circle-cctp-attesters, circle-usdc-permit-code-first]
---

## Summary

GatewayMinter is the mainnet destination side of Circle Gateway: `gatewayMint` mints tokens to the recipient named
in an attestation signed by one of Circle's attestation signers, one ECDSA key today (PQ-4). A quantum attacker who
recovers that key can sign attestations and mint USDC, EURC and cirBTC to any address, up to the minter allowances
Circle has granted: about $136.6M at block 26,431,457. Rated MEDIUM (step 4): Circle's owner key can upgrade the
contract, and Circle as master minter can cut the allowances.

## Mechanism

- `Mints.gatewayMint(attestationPayload, signature)` (l.161-193) -> `_verifyAttestationSignature` (l.256-261):
  `ECDSA.recover(keccak256(attestation).toEthSignedMessageHash(), signature)` must be in `attestationSigners`.
- Each attestation is checked for expiry (`maxBlockHeight`, l.269), destination domain, destination contract, a
  supported token, the optional destination caller and the denylist (l.284-327); `_mint` (l.333-353) marks the
  transfer-spec hash used and calls `mint(recipient, value)` on the token (no mint authority is set for any token).
- `addAttestationSigner` / `removeAttestationSigner` (l.231-248), `updateMintAuthority` (l.217) and
  `_authorizeUpgrade` (GatewayCommon.sol l.72) are `onlyOwner`. Rotating signers does not change the scheme.

Pattern PQ-4. Source: Sourcify, implementation `0xc2ff6806…` (lines in
[`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-gateway-minter-attestation-key/review-reads.json)).

## Evidence

- CHECKED (Sourcify verified source of `0xc2ff6806…`, read 2026-11-17): the functions above.
- CHECKED (on-chain at block 26,431,457): EIP-1967 implementation `0xc2ff6806…`; `owner()` `0x3c54ffa1…` (EOA, no
  code), `pendingOwner()` zero; `paused()` false; `isAttestationSigner(0x311ac5f3…)` true.
- CHECKED (Blockscout logs): one `AttestationSignerAdded` (`0x311ac5f3a327c18e27ea544694e20abd15caa85d`, block
  22,969,188), no `AttestationSignerRemoved`; `TokenSupported` for USDC (block 22,969,188), cirBTC (26,134,968) and EURC
  (26,150,487).
- CHECKED (on-chain at block 26,431,457): `isMinter(GatewayMinter)` true on all three tokens; `minterAllowance`
  95,245,156.44 USDC, 20,000,099.79 EURC, 300.00 cirBTC.
- CHECKED (Blockscout, 2026-11-17): 29,103 transactions to the minter in total; the latest 50 are all `gatewayMint`,
  the last at block 26,431,580. The 30-day count and the yearly pre-quantum count were not measured (the contract was
  not in the census).

## Impact and exposure

| Contract | Upgradeable | Escrow (mint allowance) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2222222d…` ERC1967Proxy -> GatewayMinter | yes | $136.6M | 2026-11-17 | not measured |

Escrow = remaining minter allowances priced with Blockscout rates on 2026-11-17: USDC $95.2M, EURC $22.0M
(at $1.099), cirBTC $19.4M (at $64,537). Circle's master minters can raise these, so this is the current, not the
maximum, amount. The source-side GatewayWallet is covered in `circle-gateway-burn-signer`.

## Remediation

- Circle (owner `0x3c54ffa1…`): upgrade GatewayMinter to verify attestations with a post-quantum scheme (ML-DSA or
  hash-based signatures through an ERC-7913 verifier). Adding or rotating ECDSA attestation signers does not help.
- Meanwhile Circle's master minters bound the damage through `minterAllowance`.
- The owner key is an ECDSA EOA and needs post-quantum control as well.
- Protocol change: not needed.

## History

- 2026-11-17: created in review (Review09), from verified source and on-chain reads at block 26,431,457; found while reviewing `circle-gateway-burn-signer`. Rated MEDIUM (step 4: upgrade by one owner key; escrow $136.6M, so step 5 does not lower it).
