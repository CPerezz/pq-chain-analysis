---
id: solady-p256-verifier
title: "Solady P256Verifier fallback: a quantum attacker who recovers a passkey's P-256 key can sign for the 59 smart wallets that used it (about USD 380 held); unused since the P256VERIFY precompile went live"
project: solady
status: confirmed
severity: LOW
patterns: [PQ-9]
primitives: [sw_p256]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x000000000000d01ea45f9efd5c54f037fa57ea1a"
  implementation: null
  name: P256Verifier
  upgradeable: "no"
  admin: none (stateless, no owner; each wallet chooses its own signers and verifier)
  value_usd: 380
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-06-03
  txs_30d: 0
families: []
fix:
  layer: account-migration
  who_acts: owners of the wallets that verify passkeys through it (59 in the trace, list in https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/solady-p256-verifier/wallets.json), by adding a post-quantum signer and removing the passkey; Solady (Vectorized) can ship a post-quantum verifier library
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/solady-p256-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review04)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/solady-p256-verifier/wallets.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`0x000000000000d01e…` is Solady's stateless P-256 verifier, written in Solidity with `modexp`; smart wallets that
accept WebAuthn passkeys call it through Solady's `P256` library when no P-256 precompile answers (PQ-9). A quantum
attacker who recovers a passkey's private key from its public key (stored in the wallet) can sign user operations for
that wallet. In the year to March 2026, 59 wallets used it; they hold about USD 380 now, and the verifier has not run
since the P256VERIFY precompile (`0x100`) went live. Rated LOW: MEDIUM at step 4 (wallet owners migrate to
post-quantum signers), lowered at step 5 (measured exposure under USD 50k).

## Mechanism

- `P256Verifier` (`src/P256Verifier.sol`, lines 9–17: curve constants `GX`, `GY`, `P`, `N`) takes
  `(hash, r, s, x, y)` and returns `uint256(1)` if `(r, s)` is a valid P-256 ECDSA signature by public key `(x, y)`,
  `uint256(0)` otherwise; about 168k gas, never reverts. It holds no state and has no owner.
- The wallet supplies the public key and decides what a valid signature allows; the verifier only does the curve
  arithmetic. INFERRED from Solady's `P256` library: it tries the precompile at `0x100` first and calls this
  contract only when the precompile returns nothing, which matches the trace (below).
- Source excerpts: [`source-excerpts.md`](#source-excerpts-solady-p256-verifier).

## Evidence

- CHECKED (Sourcify-verified source): the contract above; immutable, deployed by CREATE2 at a vanity address.
- CHECKED (precompile trace): the verifier called `modexp` in 693 transactions, blocks 22,104,981–23,932,659; the
  `p256verify` precompile first appears at block 23,935,699, and the verifier has no calls after it.
- CHECKED (`eth_getTransactionByHash` on all 693, `handleOps` calldata decoded): 592 are ERC-4337 bundles (EntryPoint
  v0.7 and v0.8), the rest direct wallet calls; 59 distinct wallets: SimpleTeamAccount implementation `0x83e759df…`
  (21), Kernel `0xbac849bb…` (10), SimpleAccount `0x68641de7…` (4), 23 without an EIP-1967 implementation
  (12 minimal proxies, 3 Safe proxies), 1 EIP-7702 account. 4 of them later used the precompile directly.
- CHECKED (`eth_getBalance` at block 26,431,608, Blockscout priced ERC-20 balances): the 59 wallets hold USD 380 in
  total (0.0245 ETH and USD 335 in tokens; largest `0x49cd6a44…` USD 252) ([`wallets.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/solady-p256-verifier/wallets.json)).
- CHECKED (on-chain read at block 26,431,214): the verifier holds nothing ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/solady-p256-verifier/onchain.json));
  CHECKED (Xatu, any function): last transaction touching it 2026-06-03, none in 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/solady-p256-verifier/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000000…d01ea45f` P256Verifier | no | — (escrow: 59 wallets, USD 380) | 2026-06-03 | 0 |

The exposure is the funds in wallets whose passkey is checked here, measured as USD 380 on 2026-11-17 (an upper
bound on the wallet list, since a bundle may carry other wallets' operations). Wallets that now verify the same
passkeys through the `0x100` precompile remain exposed to the same key recovery; that is the wallet's signer scheme,
not this contract.

## Remediation

- Post-quantum replacement: wallets add a post-quantum signer (for example an ML-DSA or hash-based verifier through
  ERC-7913, or a post-quantum passkey once authenticators support one) and remove the P-256 passkey signer. The
  verifier itself has nothing to fix; it cannot be changed.
- Who acts: each wallet's owner, through its wallet's signer management; Solady (Vectorized) can provide a
  post-quantum verifier library. No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: stateless verifier library; the exposure is rated on the wallets that use it).
- 2026-11-17 review (Review04): LOW kept, deciding step changed to step 5: step 4 gives MEDIUM (wallet owners migrate), and the 59 wallets that used the verifier hold USD 380 (block 26,431,608). fix.layer new-deployment -> account-migration; who_acts set.

# Source excerpts: solady-p256-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x000000000000d01ea45f9efd5c54f037fa57ea1a` — P256Verifier (verified source via sourcify)

### `src/P256Verifier.sol`

```solidity
    9  /// Unlike RIP-7212, this verifier returns `uint256(0)` on failure instead of empty return data.
   10  /// This contract will never revert.
   11  /// About 168k gas per call.
   12  /// For more details on the math, please refer to the comments in OpenZeppelin's implementation.
   13  contract P256Verifier {
   14      uint256 private constant GX = 0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296;
   15      uint256 private constant GY = 0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5;
   16      uint256 private constant P = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF; // `A = P - 3`.
   17      uint256 private constant N = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551;
  ...
```
