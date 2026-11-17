---
id: aztec-governance-proposer-sig
title: "Aztec GovernanceProposer: a quantum attacker who recovers enough validators' ECDSA keys can signal any payload to Aztec Governance, have the rollup vote its stake for it, and move up to about USD 6.8M of staked and reward AZTEC"
project: aztec
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x06ef1dcf87e419c48b94a331b252819fadbd63ef"
  implementation: null
  name: GovernanceProposer
  upgradeable: "no"
  admin: none; Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e can replace it with updateGovernanceProposer (a vote)
  value_usd: 6799736
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-13
  txs_30d: 2341
families: []
fix:
  layer: new-deployment
  who_acts: Aztec Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e votes in a GovernanceProposer and rollup version whose proposers sign with post-quantum keys; validators generate those keys
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aztec-governance-proposer-sig
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review00 (GovernanceProposer, Governance, GSE, RewardDistributor and rollup v3 source; configuration and voting power reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aztec-governance-proposer-sig/aztec-system.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [aztec-committee-attestations, aztec-honk-verifier]
---

## Summary

Aztec Governance takes proposals from the GovernanceProposer, where each slot's block proposer on the canonical
rollup signals a payload, by ECDSA signature or by calling from the proposer's own address; a payload with 600
signals in a 1,000-slot round is proposed, and the rollup then votes all validator stake that follows it in favour
(99.8% of Governance voting power). A quantum attacker who recovers the keys of the proposers of 600 slots (every
validator has signed on-chain) can therefore pass any payload, for example register a rollup that withdraws the
608.9M AZTEC of following stake, and take the RewardDistributor's 62.0M AZTEC: about USD 6.8M on 2026-11-17.
Governance can replace the proposer contract and the rollup by vote. Rated MEDIUM (step 4: a governance vote and a
new rollup version with post-quantum proposer keys).

## Mechanism

- `EmpireBase._internalSignal` (GovernanceProposer source lines 275–312): `signaler =
  selection.getCurrentProposer()` of `getInstance()` = Registry's canonical rollup (line 290); an empty signature
  requires `msg.sender == signaler`, otherwise `getSignalSignatureDigest(payload, slot)` must verify against the
  signaler through `SignatureLib.verify` (`ECDSA.recover`, lines 294–299). Entry points `signal` (line 153) and
  `signalWithSig` (line 165).
- Either way the authority is the proposer's secp256k1 key: attesters must be ECDSA addresses because their block
  attestations are recovered with `ecrecover` ([aztec-committee-attestations](aztec-committee-attestations.md)).
- `submitRoundWinner` (line 178) requires `QUORUM_SIZE` signals (600 of `ROUND_SIZE` 1,000) and calls
  `Governance.propose` (`GovernanceProposer.sol` line 91).
- Anyone can call `Rollup.vote(proposalId)`: `StakingLib.vote` (v3 source) checks the proposal came from the
  GovernanceProposer while this rollup was canonical and votes the rollup's power and the following ("bonus")
  stake in favour with `GSE.vote` and `GSE.voteWithBonus`.
- After `Governance.execute` the payload runs as Governance (any target except the AZTEC token, `Governance.sol`
  line 494). Governance owns the Registry, GSE and RewardDistributor: `GSE.addRollup` makes a new rollup the latest,
  `GSE.withdraw` lets the latest rollup withdraw following stake to itself, and
  `RewardDistributor.recoverFrom` pays out reward AZTEC to the Registry owner's chosen address.
- Pattern PQ-5 (a set of ECDSA signers counted to a quorum). Excerpts:
  [`source-excerpts.md`](#source-excerpts-aztec-governance-proposer-sig).

## Evidence

- CHECKED (verified source: Sourcify for `0x06ef1dcf…`, Blockscout for rollup v3 and RewardDistributor
  `0x555baac4…`, read 2026-11-17): the path above.
- CHECKED (`eth_call`, block 26,431,459): Governance `governanceProposer()` = `0x06ef1dcf…`; `getInstance()` =
  Rollup v3 `0xe37a2663…`; `QUORUM_SIZE` 600, `ROUND_SIZE` 1,000; Governance configuration: voting delay 3 days,
  voting 7 days, execution delay 2 days, quorum 20%, yea margin 33%, minimum 100M AZTEC; GSE `owner()` and Registry
  `owner()` = Governance; RewardDistributor `REGISTRY()` = Registry `0x35b22e09…`
  ([`aztec-system.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aztec-governance-proposer-sig/aztec-system.json)).
- CHECKED (latest block): Governance `totalPowerNow()` 619.75M AZTEC, of which the GSE holds 618.32M; 7 proposals
  so far; rollup v3 exit delay 4 days.
- CHECKED (Xatu, any function): 2,341 transactions called the GovernanceProposer in 2026-10-16 to 2026-11-16, last
  on 2026-11-13 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aztec-governance-proposer-sig/activity.json)).
- INFERRED (from source, not executed): a payload calling `Registry.addRollup` and `GSE.addRollup` for an attacker
  rollup lets that rollup call `GSE.withdraw` for every following attester and collect the stake after the
  Governance withdrawal delay.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x06ef1dcf…` GovernanceProposer | no | $6.80M escrow (what a captured Governance can move) | 2026-11-13 | 2,341 |

Escrow on 2026-11-17 (AZTEC at USD 0.010135): stake following the latest rollup, 608.9M AZTEC (USD 6.17M), held by
Governance `0x1102471e…` through the GSE; RewardDistributor `0x555baac4…`, 62.0M AZTEC (USD 0.63M). Not counted:
the 10M AZTEC staked directly in rollup v2 (withdrawable only by v2), AZTEC deposited in Governance directly
(Governance cannot call the token), and the rollups' own owed rewards. The 12 days between proposal and execution,
against a 4-day exit delay, let validators who notice exit first, if their withdrawer keys are not also forged.

## Remediation

- Aztec Governance `0x1102471eb3378fee427121c9efcea452e4b6b75e` votes in (`updateGovernanceProposer`, and a new
  rollup version through the Registry and GSE) a proposer contract and rollup whose block proposers sign with
  post-quantum keys; a signature-only fix to the GovernanceProposer is not enough while the proposer's address is
  itself an ECDSA key.
- Validators generate post-quantum keys; withdrawers should move to post-quantum accounts.
- The vote has to pass before a CRQC exists, because the same keys can block or redirect it afterwards.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review00): MEDIUM kept, step 4 (Governance replaces the proposer contract and rollup by
  vote). Corrected the mechanism: the signers are the rotating block proposers counted to a 600-of-1,000 quorum, not
  one operator key (PQ-4 -> PQ-5, `trigger` operator-key -> committee-keys, `alternative` alternative-exists ->
  key-rotation-only since the direct-call path is the same ECDSA key, `role` auxiliary -> core); traced the
  automatic stake vote and measured what a captured Governance controls (USD 6.80M escrow).

# Source excerpts: aztec-governance-proposer-sig

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x06ef1dcf87e419c48b94a331b252819fadbd63ef` — GovernanceProposer (verified source via sourcify)

### `lib/l1-contracts/src/governance/proposer/EmpireBase.sol`

```solidity
  294      } else {
  295        bytes32 digest = getSignalSignatureDigest(_payload, currentSlot);
  296  
  297        // _sig.verify will throw if invalid, it is more my sanity that I am doing this for.
  298        require(_sig.verify(signaler, digest), Errors.EmpireBase__OnlyProposerCanSignal(msg.sender, signaler));
  299      }
  300  
  301      round.signalCount[_payload] += 1;
  302  
  ...
```

### `lib/l1-contracts/src/shared/libraries/BN254Lib.sol`

```solidity
   41  
   42    uint256 public constant GROUP_ORDER =
   43      21_888_242_871_839_275_222_246_405_745_257_275_088_548_364_400_416_034_343_698_204_186_575_808_495_617;
   44  
   45    bytes32 public constant STAKING_DOMAIN_SEPARATOR = bytes32("AZTEC_BLS_POP_BN254_V1");
   46  
   47    error AddPointFail();
   48    error MulPointFail();
   49    error GammaZero();
   50    error SqrtFail();
   51    error PairingFail();
   52    error NoPointFound();
   53    error InfinityNotAllowed();
   54  
   55    /**
  ...
   97      // Build G1 R = pk1DigestPoint + gamma * G1
   98      G1Point memory right = g1Add(pk1DigestPoint, g1Mul(g1Generator(), gamma));
   99  
  100      // Pairing: e(L, -G2) * e(R, pk2) == 1
  101      return bn254Pairing(left, g2NegatedGenerator(), right, pk2);
  102    }
  103  
  104    /// @notice Convert a G1 point (public key) to the digest point that must be signed to prove possession.
  105    /// @dev exposed as public to allow clients not to have implemented the hashToPoint function.
  ...
  159      if (!success) revert MulPointFail();
  160      return output;
  161    }
  162  
  163    function bn254Pairing(G1Point memory g1a, G2Point memory g2a, G1Point memory g1b, G2Point memory g2b)
  164      internal
  165      view
  166      returns (bool)
  167    {
  ...
  193            result,
  194            0x20 // output size = 32 bytes
  195          )
  196      }
  197      require(didCallSucceed, PairingFail());
  198      return result[0] == 1;
  199    }
  200  
  201    // The hash to point is based on the "mapToPoint" function in https://www.iacr.org/archive/asiacrypt2001/22480516.pdf
  ...
```

### `lib/l1-contracts/src/shared/libraries/SignatureLib.sol`

```solidity
    1  // SPDX-License-Identifier: Apache-2.0
    2  // Copyright 2024 Aztec Labs.
    3  pragma solidity ^0.8.27;
    4  
    5  import {ECDSA} from "@oz/utils/cryptography/ECDSA.sol";
    6  
    7  // Signature
    8  struct Signature {
    9    uint8 v;
  ...
   20     * @param _signature - The signature to verify
   21     * @param _signer - The expected signer of the signature
   22     * @param _digest - The digest that was signed
   23     */
   24    function verify(Signature memory _signature, address _signer, bytes32 _digest) internal pure returns (bool) {
   25      address recovered = ECDSA.recover(_digest, _signature.v, _signature.r, _signature.s);
   26      require(_signer == recovered, SignatureLib__InvalidSignature(_signer, recovered));
   27      return true;
   28    }
   29  
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`
