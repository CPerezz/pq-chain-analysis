---
id: unidentified-bee3211a-signer-key
title: "Unidentified market maker's contract 0xbee3211a: a quantum attacker who recovers one of its three operator ECDSA keys can sign orders that trade away the about USD 9.64M it holds"
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17]
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
  value_usd: 9641659
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-18
  txs_30d: 114703
  txs_90d: 435657
families:
- code: "0xe89e1c84076dbd917f6d71608db579d3f4995487"
  name: same proxy code and admin (0xbee3211a… and 0xbee02256…; the sibling now runs implementation 0x4dffeb6b… and holds USD 0)
  instances: 2
  list: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-bee3211a-signer-key/notes.md
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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-bee3211a-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review18 (implementation bytecode strings and selectors, operator and admin reads, sibling check)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-bee3211a-signer-key/notes.md
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fa0e03d5"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Step 4 MEDIUM: one live EOA can upgrade the implementation; rotating to other EOA operators does not remove the ECDSA scheme, so the fix is an upgrade, not a setter. The ecrecover-running selector was not traced (I did not decompile it); the mechanism stays inferred from bytecode."
related: []
---

## Summary

This upgradeable market-maker contract holds about USD 9.64M in tokens and is filled through aggregator routers. Its
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
  ([`source-excerpts.md`](#source-excerpts-unidentified-bee3211a-signer-key)).

## Evidence

- CHECKED (bytecode): selectors and revert strings above ([`notes.md`](#review-notes-unidentified-bee3211a-signer-key-2026-11-17-review18)).
  Which selector runs `ecrecover` was not traced, so status stays `candidate`.
- CHECKED (`cast`, block 26,431,737): EIP-1967 implementation `0xe89e1c84…`; ProxyAdmin `0x29dfb2d5…` owned by EOA
  `0x97f7d409…`; logic `owner()` the same EOA; operators `0xbeedd84b…`, `0x97f7d409…`, `0xbee2dfb8…` (all EOAs).
- CHECKED (on-chain, block 26,438,999): about USD 9.64M of tokens held, BBTC not priced: USDT 4.66M, USDC 1.91M,
  WETH 1,690.9 (≈ $3.05M at Chainlink ETH/USD 1,804.56), WBTC 0.275 (≈ $17.7k). The original read (block 26,431,214:
  USDT 4.24M, WETH 2.75M, USDC 2.07M, BBTC 0.30M, WBTC ~USD 0.23M, total $10.7M) overstated WBTC
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-bee3211a-signer-key/onchain.json)).
- CHECKED (Xatu, any function): 114,703 transactions in 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-bee3211a-signer-key/activity.json)); precompile trace: 1,407,957
  `ecrecover` transactions in the year to March 2026 (`curated_contracts.csv`).
- CHECKED (`data/families.parquet`, `cast`, Blockscout): the only other proxy with this code, `0xbee02256…`, has the
  same admin and owner, now runs implementation `0x4dffeb6b…` and holds no priced tokens or ETH.
- CHECKED: no verified source, ENS, explorer tag or metadata names the operator; the proxy sits at a vanity address
  created through factory `0x79a8e2d1…`, and its callers are `0xbee…` vanity EOAs.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xbee3211a…` market-maker contract | yes | $9.64M | 2026-11-18 | 114,703 |
| `0xbee02256…` sibling (family) | yes | $0 | — | — |

The holdings are the market maker's own inventory, which forged operator-signed orders could trade away.

## Remediation

- Owner EOA `0x97f7d4093e5bdd0776e2ca90c90124c5e16ca569` (through ProxyAdmin `0x29dfb2d5…`): upgrade the implementation
  so `isValidSignature` and the request path verify a post-quantum operator signature (an ERC-7913 verifier, or an
  operator that is a post-quantum smart account checked through ERC-1271), and move ownership to a post-quantum
  account. Replacing operator EOAs does not help.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review18): MEDIUM kept, step 4. Operators, admin and holdings read on-chain; mechanism refined from
  bytecode (operator-gated `isValidSignature` and signed requests); sibling `0xbee02256…` checked (USD 0). Operator not
  identified.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.
- 2026-11-20: moved to triage with the rest of the pool and reviewed; state re-read at block 26,438,999; filed confirmed, MEDIUM; corrected the held WBTC (0.275 BTC ≈ $17.7k, not ~USD 0.23M) and the total (~$9.64M plus BBTC, not $10.7M); admin EOA nonce is 245 at this block (finding: 244 at 26,431,737), not an error, just later.

# Source excerpts: unidentified-bee3211a-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xbee3211ab312a8d065c4fef0247448e17a8da000` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0xe89e1c84076dbd917f6d71608db579d3f4995487`

No verified source on Sourcify or Blockscout.

# Review notes: unidentified-bee3211a-signer-key (2026-11-17, Review18)

## On-chain reads (`cast`, https://ethereum-rpc.publicnode.com, block 26,431,737)

- `0xbee3211a…`: EIP-1967 implementation `0xe89e1c84076dbd917f6d71608db579d3f4995487`; EIP-1967 admin ProxyAdmin
  `0x29dfb2d5341fd10cb99f191970d8ac85948fbf44`, `owner()` = EOA `0x97f7d4093e5bdd0776e2ca90c90124c5e16ca569`
  (nonce 244). Logic `owner()` = the same EOA.
- `numberOperators()` = 3; `getAllOperators()` = `0xbeedd84b868a3282d9d2b724f0acbde280678888`,
  `0x97f7d409…` (the owner), `0xbee2dfb85726e3bdd40a23ffdfe49546a5926666`. `weth()` = WETH. ETH balance 0.
- Holdings (`onchain.json`, block 26,431,214): USD 10,724,262 of tokens (USDT 4.24M, WETH 2.75M, USDC 2.07M, BBTC
  0.30M, WBTC 0.23M).
- Deployment (Sourcify): tx `0x939b280d…`, block 22,304,481, deployer recorded as `0x97f7d409…`; Blockscout lists
  creator contract `0x79a8e2d1…` (unverified factory, itself created by `0x6513aedb…`): a vanity-address deployment.
- Sibling with the same proxy code (`data/families.parquet` family `code:0x18db792b…`):
  `0xbee0225697a311af58096ce2f03a2b65f1702f00`, same ProxyAdmin and owner, now implementation `0x4dffeb6b…`,
  operators `0xbee029ff…` and `0x97f7d409…`, ETH 0, priced tokens USD 0 (Blockscout), 861 `ecrecover` transactions
  in the year to March 2026 (last block 24,411,295).

## Implementation bytecode (`0xe89e1c84…`, 16,512 bytes; unverified)

- Selectors include `isValidSignature(bytes32,bytes)` (`0x1626ba7e`), `addOperators(address[])`,
  `removeOperators(address[])`, `isOperator(address)`, `operatorAt(uint256)`, `getAllOperators()`,
  `numberOperators()`, `setAllowance(address[],address,uint256)`, `emergencyWithdraw(address,uint256)`,
  `adminExecute(address,bytes)`, `convertETH(uint256)`, `weth()`, `MAX()`, `0x69328dec`
  (`withdraw(address,uint256,address)`), and unresolved `0x4cf3fe9c` and 15 others.
- Strings: "\x19Ethereum Signed Message:", "ECDSA: invalid signature", "ECDSA: invalid signature length", "Signature
  expired", "Signature does not match request", "Only forwarder allow", "Incorrect sender", "Not accepted dest",
  "destination is not approved", "caller is not operator", "Builder payment failed", "ReserveFund".
- Contains the secp256k1 `n/2` constant (OpenZeppelin `ECDSA`).
- INFERRED: `isValidSignature` recovers an ECDSA signer and accepts it if it is an operator, so RFQ/limit orders whose
  maker is this contract (filled through aggregator routers) are authorised by an operator key; a second path checks
  an operator-signed request ("Signature does not match request") before executing it against approved destinations.

## Activity

- Blockscout latest direct transactions: `0x4cf3fe9c` from several `0xbee…` vanity EOAs; `withdraw` (`0x69328dec`)
  from operator `0xbeedd84b…`.
- Xatu: 114,703 transactions touching the contract in 2026-10-16 to 2026-11-16 (39,504 direct).
- Precompile trace: 1,518,623 `ecrecover` calls in 1,407,957 transactions in the year to March 2026
  (`data/agg/y1_caller.parquet`, `curated_contracts.csv`).
- No ENS, tag, verified source or metadata identifies the operator.
