---
id: daimo-p256-verifier
title: "Daimo P256Verifier: a quantum attacker who recovers a passkey's P-256 key can sign for the smart wallets that verify passkeys through it (about 4,200 wallets, up to $1.24M) until their owners add post-quantum signers"
project: daimo
status: confirmed
severity: MEDIUM
patterns: [PQ-9]
primitives: [sw_p256]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xc2b78104907f722dabac4c69f826a522b2754de4"
  implementation: null
  name: P256Verifier
  upgradeable: "no"
  admin: none (stateless, no owner; each wallet chooses its signers and verifier)
  value_usd: 1237800
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 1347
families: []
fix:
  layer: account-migration
  who_acts: owners of the wallets that verify passkeys through 0xc2b78104 (list in evidence/daimo-p256-verifier/wallets.json), by adding a post-quantum signer and removing the passkey; wallet vendors (for example ZeroDev's WebAuthnValidator 0x7ab16ff354acb328452f1d445b3ddee9a91e9e69) ship post-quantum validators
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/daimo-p256-verifier/classification.jsonl
  - evidence/daimo-p256-verifier/onchain.json
  - evidence/daimo-p256-verifier/activity.json
  - evidence/daimo-p256-verifier/source-excerpts.md
  - evidence/daimo-p256-verifier/wallets.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review22)
  ref: evidence/daimo-p256-verifier/wallets.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [jovay-dcap-p256-collateral]
---

## Summary

`0xc2b78104…` is Daimo's stateless P-256 verifier, the canonical RIP-7212 fallback. Smart wallets that accept WebAuthn
passkeys call it to check a passkey signature. A quantum attacker who recovers a passkey's private key from its public
key (stored in the wallet) can sign user operations for that wallet. It is still in use: 1,347 transactions in the
last 30 days, mostly ZeroDev Kernel accounts through `WebAuthnValidator`. The 4,208 wallets seen using it since March
2026 hold up to $1.24M. Rated MEDIUM (step 4: the fix is each wallet owner adding a post-quantum signer; step 5 does
not apply).

## Mechanism

- `P256Verifier` (`src/P256Verifier.sol`, from line 11) has no function selector: its calldata is
  `(hash, r, s, x, y)`, and it returns 1 if `(r, s)` is a valid P-256 ECDSA signature by public key `(x, y)`. It does
  the curve arithmetic in Solidity, with `modexp` for field inversions (FreshCryptoLib-based). It holds no state and
  has no owner. PQ-9.
- The wallet supplies the public key and decides what a valid signature allows. In the traced example (tx
  `0xf12aea4e…`), EntryPoint v0.7 → Kernel account `0xc35694d5…` → `WebAuthnValidator` `0x7ab16ff3….validateUserOp`
  → `0xc2b78104…` (calling it directly, not the `0x100` precompile first).

## Evidence

- CHECKED (Sourcify-verified source; deployment through the CREATE2 deployer, tx `0xbc5be668…`, block 18,308,790):
  the code above.
- CHECKED (Xatu call frames since block 24,700,000): 8,496 transactions called `0xc2b78104…`; 8,246 were EntryPoint
  v0.7 `handleOps`, the rest direct Safe `execTransaction` and other calls. Decoding the `handleOps` senders and direct
  `to` addresses gives 4,208 wallets: Kernel proxies, Safe proxies and EIP-7702 EOAs among the largest
  ([`wallets.json`](../evidence/daimo-p256-verifier/wallets.json)). There were 13,742 pre-quantum calls in the year to
  March 2026 (`curated_contracts.csv`).
- CHECKED (`eth_getBalance` and Multicall3 `balanceOf` at about block 26,431,523): those wallets hold 117.0 ETH ($212k)
  plus $1.03M in USDC, USDT, DAI, EURC, WETH, wstETH, WBTC and cbBTC, $1.24M in total. This is an upper bound: a bundle
  can include other wallets' operations, and EIP-7702 wallets are also exposed through their own ECDSA key. Other
  tokens were not counted.
- CHECKED (`cast run` of tx `0xf12aea4e…`): the call path above.
- CHECKED (on-chain read at block 26,431,214): the verifier holds nothing.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0xc2b78104…` P256Verifier | no | $1.24M (escrow: 4,208 wallets, upper bound) | 2026-11-15 | 1,347 |

The exposure is in the wallets, not the verifier. The biggest balances are a handful of wallets holding $80k–$214k
each, mostly USDT/USDC.

## Remediation

- Wallet owners add a post-quantum signer (for example an ML-DSA or hash-based verifier through ERC-7913, or a
  post-quantum passkey once authenticators support one) and remove the P-256 passkey signer. Wallet vendors whose
  validators call this verifier (ZeroDev `WebAuthnValidator` `0x7ab16ff3…`, Safe passkey signers, EIP-7702 delegates)
  need to ship those validators. The verifier itself has nothing to fix and cannot be changed.
- Using the `0x100` P256VERIFY precompile instead changes nothing about the quantum exposure.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: stateless verifier library; the exposure is rated on the wallets that use it).
- 2026-11-17 review (Review22): LOW -> MEDIUM, step 4: rated on the wallets that verify passkeys through it, whose owners must add post-quantum signers (account migration); step 5 does not lower it (4,208 wallets hold up to $1.24M). `0x78337799` identified as Automata PCCS's copy (Intel issuer signatures), misgrouped.
- 2026-11-17 review (Review22): `0x78337799` (Jovay's copy of the verifier for Intel DCAP collateral) moved to `jovay-dcap-p256-collateral`; the rating stays MEDIUM, step 4, since it rested on `0xc2b78104` alone.
