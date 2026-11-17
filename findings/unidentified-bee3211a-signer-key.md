---
id: unidentified-bee3211a-signer-key
title: "Unidentified market maker's contract 0xbee3211a: a quantum attacker who recovers one of its three operator ECDSA keys can sign orders that trade away the about USD 10.7M it holds"
project: unidentified-bee3211a
status: candidate
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xbee3211ab312a8d065c4fef0247448e17a8da000"
  implementation: "0xe89e1c84076dbd917f6d71608db579d3f4995487"
  name: market-maker contract (TransparentUpgradeableProxy; implementation unverified)
  upgradeable: "yes"
  admin: ProxyAdmin 0x29dfb2d5341fd10cb99f191970d8ac85948fbf44 owned by EOA 0x97f7d4093e5bdd0776e2ca90c90124c5e16ca569, also logic owner and an operator; read at block 26,431,737
  value_usd: 10724262
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 114703
families:
- code: "0xe89e1c84076dbd917f6d71608db579d3f4995487"
  name: same proxy code and admin (0xbee3211a… and 0xbee02256…; the sibling now runs implementation 0x4dffeb6b… and holds USD 0)
  instances: 2
  list: evidence/unidentified-bee3211a-signer-key/notes.md
  upgradeable: "yes"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: contract-upgrade
  who_acts: ProxyAdmin owner EOA 0x97f7d4093e5bdd0776e2ca90c90124c5e16ca569 upgrades the implementation to verify post-quantum operator signatures
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-bee3211a-signer-key/classification.jsonl
  - evidence/unidentified-bee3211a-signer-key/onchain.json
  - evidence/unidentified-bee3211a-signer-key/activity.json
  - evidence/unidentified-bee3211a-signer-key/source-excerpts.md
  - evidence/unidentified-bee3211a-signer-key/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review18 (implementation bytecode strings and selectors, operator and admin reads, sibling check)
  ref: evidence/unidentified-bee3211a-signer-key/notes.md
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
related: []
---

## Summary

This upgradeable market-maker contract holds about USD 10.7M in tokens and is filled through aggregator routers. Its
unverified implementation accepts orders through `isValidSignature` (ERC-1271) and operator-signed requests, both
authorised by an ECDSA signature from one of three operator EOAs (PQ-4). A quantum attacker who recovers any
operator key (the operators transact on-chain, so their public keys are known) can sign orders that sell the
contract's inventory at the attacker's price. One EOA owns the proxy admin and can upgrade the verification. Rated
MEDIUM (step 4: fix by a contract upgrade); the operator is not identified.

## Mechanism

- INFERRED from bytecode (implementation `0xe89e1c84…`): `isValidSignature(bytes32,bytes)` with OpenZeppelin
  `ECDSA` ("ECDSA: invalid signature", the secp256k1 `n/2` constant, "\x19Ethereum Signed Message:") and an operator
  set (`addOperators`, `removeOperators`, `isOperator`, `getAllOperators`, "caller is not operator"). An order whose
  maker is this contract is valid when the recovered signer is an operator.
- A second path executes operator-signed requests ("Signature does not match request", "Signature expired", "Only
  forwarder allow") against approved destinations ("Not accepted dest", "destination is not approved").
- The owner also has `adminExecute(address,bytes)` and `emergencyWithdraw(address,uint256)`, so the owner EOA key is
  a second ECDSA dependency over the same funds.
- Pattern PQ-4. No verified implementation source
  ([`source-excerpts.md`](../evidence/unidentified-bee3211a-signer-key/source-excerpts.md)).

## Evidence

- CHECKED (bytecode): selectors and revert strings above ([`notes.md`](../evidence/unidentified-bee3211a-signer-key/notes.md)).
  Which selector runs `ecrecover` was not traced, so status stays `candidate`.
- CHECKED (`cast`, block 26,431,737): EIP-1967 implementation `0xe89e1c84…`; ProxyAdmin `0x29dfb2d5…` owned by EOA
  `0x97f7d409…`; logic `owner()` the same EOA; operators `0xbeedd84b…`, `0x97f7d409…`, `0xbee2dfb8…` (all EOAs).
- CHECKED (on-chain, block 26,431,214): USD 10.7M of tokens held (USDT 4.24M, WETH 2.75M, USDC 2.07M, BBTC 0.30M,
  WBTC 0.23M) ([`onchain.json`](../evidence/unidentified-bee3211a-signer-key/onchain.json)).
- CHECKED (Xatu, any function): 114,703 transactions in 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](../evidence/unidentified-bee3211a-signer-key/activity.json)); precompile trace: 1,407,957
  `ecrecover` transactions in the year to March 2026 (`curated_contracts.csv`).
- CHECKED (`data/families.parquet`, `cast`, Blockscout): the only other proxy with this code, `0xbee02256…`, has the
  same admin and owner, now runs implementation `0x4dffeb6b…` and holds no priced tokens or ETH.
- CHECKED: no verified source, ENS, explorer tag or metadata names the operator; the proxy sits at a vanity address
  created through factory `0x79a8e2d1…`, and its callers are `0xbee…` vanity EOAs.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xbee3211a…` market-maker contract | yes | $10.7M | 2026-11-16 | 114,703 |
| `0xbee02256…` sibling (family) | yes | $0 | — | — |

The holdings are the market maker's own inventory, which forged operator-signed orders could trade away.

## Remediation

- Owner EOA `0x97f7d4093e5bdd0776e2ca90c90124c5e16ca569` (through ProxyAdmin `0x29dfb2d5…`): upgrade the implementation
  so `isValidSignature` and the request path verify a post-quantum operator signature (an ERC-7913 verifier, or an
  operator that is a post-quantum smart account checked through ERC-1271), and move ownership to a post-quantum
  account. Replacing operator EOAs does not help.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review18): MEDIUM kept, step 4. Operators, admin and holdings read on-chain; mechanism refined from
  bytecode (operator-gated `isValidSignature` and signed requests); sibling `0xbee02256…` checked (USD 0). Operator not
  identified.
