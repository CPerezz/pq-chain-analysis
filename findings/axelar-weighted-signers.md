---
id: axelar-weighted-signers
title: "Axelar Gateway on Ethereum: a quantum attacker who recovers a weighted quorum of Axelar operator ECDSA keys can approve forged commands and release about USD 39.5M locked in the gateway"
project: axelar
status: confirmed
severity: MEDIUM
patterns: [PQ-5, PQ-17]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0"
  implementation: null
  name: AxelarAuthWeighted (current auth module, since 2026-11-12)
  upgradeable: config-only
  admin: owner AxelarGateway 0x4f4495243837681061c4743b74b3eedf548d56a5 (operator rotation via signed transferOperatorship; gateway upgradeable by AxelarServiceGovernance 0x7acbae6cba67d78aaf69e47000884ae00f9b2525)
  value_usd: 39499251
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: null
- address: "0xe3b83f79fbf01b25659f8a814945ab82186a8ad0"
  implementation: null
  name: AxelarAuthWeighted (retired auth module, replaced 2026-11-12)
  upgradeable: config-only
  admin: owner AxelarGateway 0x4f4495243837681061c4743b74b3eedf548d56a5; no longer called by it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-12
  txs_30d: 4825
families: []
fix:
  layer: contract-upgrade
  who_acts: Axelar governance (AxelarServiceGovernance 0x7acbae6cba67d78aaf69e47000884ae00f9b2525, proposals from axelar10d07y265gmmuvt4z0w9aw880jnsr700j7v9daj, operator EOA 0xc8a8399c3d1207f4e109673be7047604737c1d56) upgrades the gateway to a post-quantum auth module; the Axelar validator set must sign with post-quantum keys
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/axelar-weighted-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review18 (gateway and both auth modules from Sourcify, historical authModule reads, gateway escrow)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/axelar-weighted-signers/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 8ca74f93, 5463008f"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

Every command the Axelar Gateway on Ethereum executes (release or mint tokens, approve a contract call, rotate
operators) is accepted only if `AxelarAuthWeighted.validateProof` finds ECDSA signatures from Axelar operators whose
weights reach the threshold. A quantum attacker who derives enough operator keys from their public signatures can
sign `mintToken` commands that pay out the gateway's locked tokens (about USD 39.5M on 2026-11-17, within any
per-token mint limit per 6-hour period), approve arbitrary contract calls (Interchain Token Service releases), and rotate the
operator set to their own keys. Axelar governance can upgrade the gateway to a different auth module, as it did on
2026-11-12, but a post-quantum module also needs the Axelar validators to sign with new keys. Rated MEDIUM (step 4:
fixed by a governance upgrade plus several parties acting).

## Mechanism

- `AxelarGateway.execute(input)` (impl `0x16c22cbd…`, `AxelarGateway.sol` line 512) hashes the command batch and
  calls `IAxelarAuth(authModule).validateProof(messageHash, proof)` (line 519).
- `AxelarAuthWeighted.validateProof` → `_validateSignatures`: `ECDSA.recover(messageHash, signatures[i])` per
  signature (line 105), matched against the sorted operator list of an epoch no older than 16 rotations, summing
  weights to the threshold.
- Commands then run: `mintToken` → `_mintToken` transfers External tokens out of the gateway with `safeTransfer`
  (line 747) or mints internal Axelar tokens, counted against `tokenMintLimit`; `approveContractCall(WithMint)` lets
  a destination contract (for example Interchain Token Service) act on the message; `transferOperatorship` replaces
  the operator set when signed by the current one.
- Pattern PQ-5. Excerpts: [`source-excerpts.md`](#source-excerpts-axelar-weighted-signers).

## Evidence

- CHECKED (Sourcify exact matches, read 2026-11-17): gateway implementation `0x16c22cbd…` and both auth modules; the
  new module differs from the old one by one line in `_transferOperatorship`, the ECDSA check is identical
  ([`notes.md`](#review-notes-axelar-weighted-signers-2026-11-17-review18)).
- CHECKED (`cast`, eth.drpc.org): the gateway's `authModule()` was `0xe3b83f79…` at block 26,395,160 and is
  `0x3d3c73e9…` from block 26,395,170 to 26,431,544; the switch came with the upgrade to implementation `0x16c22cbd…`
  in tx `0x412a5698…`, sent by EOA `0xc8a8399c…` through `AxelarServiceGovernance.executeOperatorProposal`.
- CHECKED (`cast`, block 26,431,544): `governance()` = AxelarServiceGovernance `0x7acbae6c…` (governance chain
  "axelar", 3-day minimum timelock, operator `0xc8a8399c…`); both auth modules' `owner()` = gateway;
  `currentEpoch()` 20 (new) and 1,107 (old).
- CHECKED (Blockscout): gateway `Executed` events through block 26,426,190 (2026-11-16), so the new module is in use.
- CHECKED (Xatu, any function): the old module was called in 4,825 transactions in 2026-10-16 to 2026-11-16, last on
  2026-11-12 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/axelar-weighted-signers/activity.json)); 71,723 `ecrecover`-using
  transactions in the last year (`studies/top-callers-classification/results/curated_contracts.csv`).
- CHECKED (Blockscout token balances, `cast balance`): gateway escrow as below.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x3d3c73e9…` AxelarAuthWeighted (current) | config-only | $39.5M escrow (gateway) | 2026-11-16 | not measured |
| `0xe3b83f79…` AxelarAuthWeighted (retired) | config-only | — | 2026-11-12 | 4,825 |

Escrow: AxelarGateway `0x4f4495243837681061c4743b74b3eedf548d56a5` holds USD 39.5M of priced tokens (ZIG 18.4M,
USDC 13.3M, WBTC 3.1M, WETH 1.7M, BUSD 1.3M, others) and 0.9 ETH on 2026-11-17. The per-symbol mint limits slow
but do not stop a drain, and a forged quorum can also rotate the operators. Not included: tokens in Interchain
Token Service token managers released by forged `approveContractCall` messages, and the market value of internal
Axelar tokens a forged `mintToken` would mint. The old module holds nothing and is no longer reachable from the
gateway.

## Remediation

- Axelar governance (`AxelarServiceGovernance` `0x7acbae6cba67d78aaf69e47000884ae00f9b2525`, proposals from
  `axelar10d07y265gmmuvt4z0w9aw880jnsr700j7v9daj`, executed by operator `0xc8a8399c…` or after the 3-day timelock)
  upgrades the gateway to an auth module that verifies a post-quantum scheme (hash-based or lattice threshold
  signatures, or a STARK proof of the validator signatures). The 2026-11-12 upgrade shows the path works.
- The Axelar validators must generate and sign with post-quantum keys; rotating ECDSA operators
  (`transferOperatorship`) does not help.
- Governance proposals reach the gateway through the same `validateProof`, so a forged quorum could also schedule
  a governance action; the 3-day timelock leaves time to react only if someone watches.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review18): MEDIUM kept, step 4. The gateway switched to a new auth module `0x3d3c73e9…` on
  2026-11-12 (same ECDSA check); added it as the main contract and marked `0xe3b83f79…` retired. Measured the
  gateway escrow (USD 39.5M). `fix.layer` new-deployment -> contract-upgrade (governance upgrades the gateway).
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: axelar-weighted-signers

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xe3b83f79fbf01b25659f8a814945ab82186a8ad0` — AxelarAuthWeighted (verified source via sourcify)

### `contracts/auth/AxelarAuthWeighted.sol`

```solidity
    2  
    3  pragma solidity ^0.8.0;
    4  
    5  import { IAxelarAuthWeighted } from '../interfaces/IAxelarAuthWeighted.sol';
    6  import { ECDSA } from '../ECDSA.sol';
    7  import { Ownable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/utils/Ownable.sol';
    8  
    9  contract AxelarAuthWeighted is Ownable, IAxelarAuthWeighted {
   10      uint256 public currentEpoch;
  ...
   38          uint256 epoch = currentEpoch;
   39  
   40          if (operatorsEpoch == 0 || epoch - operatorsEpoch >= OLD_KEY_RETENTION) revert InvalidOperators();
   41  
   42          _validateSignatures(messageHash, operators, weights, threshold, signatures);
   43  
   44          return operatorsEpoch == epoch;
   45      }
   46  
  ...
   87  
   88          emit OperatorshipTransferred(newOperators, newWeights, newThreshold);
   89      }
   90  
   91      function _validateSignatures(
   92          bytes32 messageHash,
   93          address[] memory operators,
   94          uint256[] memory weights,
   95          uint256 threshold,
  ...
  101          uint256 weight;
  102          // looking for signers within operators
  103          // assuming that both operators and signatures are sorted
  104          for (uint256 i; i < signaturesLength; ++i) {
  105              address signer = ECDSA.recover(messageHash, signatures[i]);
  106              // looping through remaining operators to find a match
  107              for (; operatorIndex < operatorsLength && signer != operators[operatorIndex]; ++operatorIndex) {}
  108              // checking if we are out of operators
  109              if (operatorIndex == operatorsLength) revert MalformedSigners();
  ...
```

Library files with the primitive itself (not excerpted): `contracts/ECDSA.sol`

# Review notes: axelar-weighted-signers (2026-11-17, Review18)

## Auth module switch on 2026-11-12

- `AxelarGateway` proxy `0x4f4495243837681061c4743b74b3eedf548d56a5`:
  - `authModule()` = `0xe3b83f79fbf01b25659f8a814945ab82186a8ad0` and `implementation()` =
    `0x99b5fa03a5ea4315725c43346e55a6a6fbd94098` at block 26,395,160 (`cast`, eth.drpc.org);
  - `authModule()` = `0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0` and `implementation()` =
    `0x16c22cbdd77350b1ac88adda344f691c12f41960` from block 26,395,170 (bisected) to 26,431,544 (latest read).
  - Upgrade: tx `0x412a5698beb96a03e4927b8cbedf35e3399699e0312a9d3b2bbaeab4dc1fd169` (2026-11-12 00:07 UTC), emits
    `Upgraded(0x16c22cbd…)`; sent by EOA `0xc8a8399c3d1207f4e109673be7047604737c1d56` calling
    `AxelarServiceGovernance(0x7acbae6cba67d78aaf69e47000884ae00f9b2525).executeOperatorProposal`.
- New auth module `0x3d3c73e9…`: `AxelarAuthWeighted`, created 2026-11-09 (block 26,378,185) by
  `0x98b2920d53612483f91f12ed7754e51b4a77919e`; `owner()` = gateway; `currentEpoch()` = 20.
  Sourcify exact match. Diff to the old module's `AxelarAuthWeighted.sol`: one line in `_transferOperatorship`
  (`newOperatorsHash = keccak256(abi.encode(newOperators, newWeights, newThreshold))` instead of `keccak256(params)`).
  `_validateSignatures` unchanged: `ECDSA.recover(messageHash, signatures[i])` (line 105), weighted threshold.
- Old module `0xe3b83f79…`: `owner()` = gateway, `currentEpoch()` = 1107; last called by the gateway 2026-11-12
  (Blockscout internal transactions, block 26,395,160). No longer reachable from the gateway.

## Governance (`cast`, block 26,431,544)

- `AxelarGateway.governance()` = `0x7acbae6cba67d78aaf69e47000884ae00f9b2525` (`AxelarServiceGovernance`):
  `governanceChain()` = "axelar", `governanceAddress()` = `axelar10d07y265gmmuvt4z0w9aw880jnsr700j7v9daj`,
  `minimumTimeLockDelay()` = 259,200 s (3 days), `operator()` = EOA `0xc8a8399c…`.
- `mintLimiter()` = `0xcc940ae49c78f20e3f13f3cf37e996b98ac3ec68`; `tokenDeployer()` = `0xb28478319b64f8d47e19a120209a211d902f8b8f`.

## Gateway source (`contracts/AxelarGateway.sol`, impl `0x16c22cbd…`, Sourcify exact match)

- `execute(input)` (line 512): `messageHash = toEthSignedMessageHash(keccak256(data))`;
  `IAxelarAuth(authModule).validateProof(messageHash, proof)` (line 519); then runs commands `deployToken`,
  `mintToken`, `approveContractCall`, `approveContractCallWithMint`, `burnToken`, and `transferOperatorship` (only
  when signed by the current operator set).
- `_mintToken` (line 735): External tokens → `IERC20.safeTransfer(account, amount)` from the gateway's balance
  (line 747); internal tokens → `mint`. Counted against `tokenMintLimit` per symbol (set by the mint limiter).
- `upgrade(...)` (line 435) `onlyGovernance`.

## Escrow (Blockscout `/token-balances` for the gateway, 2026-11-17, from the remote box)

- 135 token balances; priced total USD 39,497,609. Largest: ZIG 18.40M, USDC 13.31M, WBTC 3.14M, WETH 1.65M,
  BUSD 1.33M, USDT 0.68M, DAI 0.35M, EURC 0.27M.
- ETH balance 0.906 ETH (`cast balance`, block 26,431,544) = USD 1,642 at 1,811.62.
- Total used: USD 39,499,251 (`value_basis: escrow`).
- Not measured: tokens locked in Interchain Token Service token managers that release on `approveContractCall`
  messages, and the market value of internal Axelar tokens that a forged `mintToken` would mint.
