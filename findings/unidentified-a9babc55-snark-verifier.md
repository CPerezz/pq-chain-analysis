---
id: unidentified-a9babc55-snark-verifier
title: "Tornado Cash fork (deployer 0x166e5650): a recovered Groth16 setup trapdoor lets anyone withdraw from its 11 mixer pools (about USD 56 left)"
project: unidentified-a9babc55
status: confirmed
severity: CRITICAL
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xa9babc55c7da0eb203d082af0e5c1ad2c3f03743"
  implementation: null
  name: Verifier
  upgradeable: "no"
  admin: none (no admin functions; the 11 pools embed this address as an immutable; pool owner EOA 0x166e5650dad33cca439c9d5ce0ac2fed433ddf1a cannot repoint it)
  value_usd: 56
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-01
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: deployer and pool owner EOA 0x166e5650dad33cca439c9d5ce0ac2fed433ddf1a (new pools with a post-quantum verifier); depositors withdraw from the old pools
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-a9babc55-snark-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review04)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-a9babc55-snark-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: []
---

## Summary

`0xa9babc55…` is the Groth16 verifier of a Tornado Cash fork: 11 fixed-denomination mixer pools (5 USDT, 6 ETH)
deployed by EOA `0x166e5650…` call it from `withdraw`. A quantum attacker who recovers the setup trapdoor (PQ-7) can
forge withdrawal proofs for nullifiers nobody deposited and empty every pool. The pools hold about USD 56 now
(20 USDT and 0.02 ETH, block 26,431,520). Rated HIGH: CRITICAL at step 4 (pooled funds, verifier embedded immutably,
depositors cannot all be counted on to move), lowered one level at step 5 (under USD 50k).

## Mechanism

- `Verifier.verifyProof(bytes proof, uint256[6] input)` (source lines 200–233) decodes the Groth16 proof, builds
  `vk_x` from the hard-coded `verifyingKey()` with `ecAdd`/`ecMul` (precompiles 6, 7) and checks one `ecPairing`
  (precompile 8) on BN254. The six public inputs are Tornado's `root, nullifierHash, recipient, relayer, fee, refund`.
- The verifying key is byte-for-byte Tornado Cash Classic's (`alfa1` and `IC[0]` equal those in
  `0xce172ce1f20ec0b3728c9965470eaf994a03557a`, finding `tornado-groth16-verifier`), so this fork relies on Tornado's
  2020 setup ceremony; the same trapdoor forges proofs for both.
- Each pool's `withdraw(bytes,bytes32,bytes32,address,address,uint256,uint256)` (selector `0x21a0adb6`) calls
  `verifier.verifyProof` and, on success, marks the nullifier spent and pays one denomination to `recipient`. With a
  forged proof an attacker withdraws repeatedly with fresh nullifier hashes against any known root.
- Pattern PQ-7. Source excerpts: [`source-excerpts.md`](#source-excerpts-unidentified-a9babc55-snark-verifier).

## Evidence

- CHECKED (Blockscout-verified source, `Verifier`, pragma ^0.7.0): `verifyProof` and the hard-coded verifying key;
  no owner, no setter.
- CHECKED (Sourcify source of `0xce172ce1…`): its `alfa1` and `IC[0]` match this verifier's.
- CHECKED (precompile trace `data/agg/y1_tx_caller.parquet`, plus `eth_getTransactionByHash` on all 180 transactions in
  which the verifier called `ecPairing`, blocks 22,101,235–24,680,797): every one is a `withdraw` call to one of the
  11 pools listed below.
- CHECKED (`eth_call` at block 26,431,520): every pool returns `verifier() = 0xa9babc55…` and
  `owner() = 0x166e5650…`. In the two pool code variants (11,207 and 12,023 bytes; `0xcb498d5c…`, `0x9a9351f3…`) the
  verifier address is a constant in the runtime code, and it is not in storage slots 0–15 of `0xcb498d5c…`, so it
  cannot be repointed. INFERRED: the same for the other nine pools, which share those two code sizes. Pools are plain
  contracts, not proxies.
- CHECKED (Blockscout): the verifier and pools `0xd5f9eda2…` and `0x9a9351f3…` were created by
  `0x166e5650dad33cca439c9d5ce0ac2fed433ddf1a`, an EOA with no name, tag or ENS name. Pool source is not verified.
- CHECKED (pool bytecode selectors, 4byte lookup): Tornado functions plus fee and ownership functions; none of the
  decoded selectors sets the verifier.
- CHECKED (on-chain read at block 26,431,214): the verifier holds nothing ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-a9babc55-snark-verifier/onchain.json)).
- CHECKED (Xatu, any function): last transaction reaching the verifier 2026-10-01; none in 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-a9babc55-snark-verifier/activity.json)).
- CHECKED (`eth_getBalance`, USDT `balanceOf` at block 26,431,520): pool balances in
  [`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-a9babc55-snark-verifier/escrow.json).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xa9babc55…` Verifier | no | — (secures USD 56 in the pools) | 2026-10-01 | 0 |

Escrow (the pools the verifier releases), block 26,431,520, ETH at USD 1,811.62:

| Pool | Denomination | Deposits (`nextIndex`) | Holds | Withdrawals in trace (y1) |
|---|---|---|---|---|
| `0xcb498d5c…` | 10,000 USDT | 93 | 0.0013 USDT | 71 |
| `0xa410030e…` | 1,000 USDT | 43 | 0 | 30 |
| `0xd5f9eda2…` | 50,000 USDT | 34 | 0 | 26 |
| `0x9a9351f3…` | 0.01 ETH | 25 | 0.02 ETH | 15 |
| `0x273ae47a…` | 10 USDT | 24 | 20 USDT | 13 |
| `0x52da6d61…` | 10 ETH | 8 | 0 | 8 |
| `0x9164fbd2…` | 50 ETH | 7 | 0 | 7 |
| `0xce6e83eb…` | 5,000 USDT | 11 | 0 | 4 |
| `0xbdc351c1…` | 0.1 ETH | 14 | 0 | 4 |
| `0x4f716560…` | 1 ETH | 4 | 0 | 1 |
| `0xa369028f…` | 5 ETH | 2 | 0 | 1 |

Total held: about USD 56. The pools have moved larger sums (up to 50,000 USDT per withdrawal) but are drained now;
whatever is deposited later is exposed the same way. Tornado Cash's own pools, which share the setup, are covered by
`tornado-groth16-verifier`.

## Remediation

- Post-quantum replacement: a hash-based proof system (STARK/FRI) for the withdrawal circuit, in new pools; neither
  the verifier nor the pools can be changed in place.
- Who acts: the deployer and pool owner `0x166e5650dad33cca439c9d5ce0ac2fed433ddf1a`, by deploying new pools; each
  depositor by withdrawing from the old pools before a CRQC exists. No protocol change is needed or would help.
- Users: withdraw any remaining notes now; do not deposit into these pools.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review04): CRITICAL -> HIGH, step 5: the consumer is identified as 11 Tornado Cash fork pools (immutable verifier, owner EOA 0x166e5650) holding about USD 56 at block 26,431,520; step 4 alone would be CRITICAL. Evidence level bytecode -> source-read (verifier source is Blockscout-verified); status candidate -> confirmed.
- 2026-11-19: HIGH -> CRITICAL, step 5 removed (value no longer lowers a rating); step 4 gives CRITICAL.

# Source excerpts: unidentified-a9babc55-snark-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xa9babc55c7da0eb203d082af0e5c1ad2c3f03743` — Verifier (verified source via blockscout)

### `.sol`

```solidity
   41  // 2019 OKIMS
   42  
   43  pragma solidity ^0.7.0;
   44  
   45  library Pairing {
   46    uint256 constant PRIME_Q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
   47  
   48    struct G1Point {
   49      uint256 X;
  ...
   88      // Use "invalid" to make gas estimation work
   89        switch success case 0 { invalid() }
   90      }
   91  
   92      require(success, "pairing-add-failed");
   93    }
   94  
   95    /*
   96     * @return r the product of a point on G1 and a scalar, i.e.
  ...
  108        success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
  109      // Use "invalid" to make gas estimation work
  110        switch success case 0 { invalid() }
  111      }
  112      require(success, "pairing-mul-failed");
  113    }
  114  
  115    /* @return The result of computing the pairing check
  116     *         e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
  117     *         For example,
  118     *         pairing([P1(), P1().negate()], [P2(), P2()]) should return true.
  119     */
  120    function pairing(
  121      G1Point memory a1,
  122      G2Point memory a2,
  123      G1Point memory b1,
  124      G2Point memory b2,
  ...
  152      // Use "invalid" to make gas estimation work
  153        switch success case 0 { invalid() }
  154      }
  155  
  156      require(success, "pairing-opcode-failed");
  157  
  158      return out[0] != 0;
  159    }
  160  }
  161  
  162  contract Verifier {
  163    uint256 constant SNARK_SCALAR_FIELD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
  164    uint256 constant PRIME_Q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
  165    using Pairing for *;
  166  
  167    struct VerifyingKey {
  168      Pairing.G1Point alfa1;
  169      Pairing.G2Point beta2;
  170      Pairing.G2Point gamma2;
  171      Pairing.G2Point delta2;
  172      Pairing.G1Point[7] IC;
  173    }
  174  
  175    struct Proof {
  176      Pairing.G1Point A;
  177      Pairing.G2Point B;
  178      Pairing.G1Point C;
  179    }
  180  
  181    function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  182      vk.alfa1 = Pairing.G1Point(uint256(20692898189092739278193869274495556617788530808486270118371701516666252877969), uint256(11713062878292653967971378194351968039596396853904572879488166084231740557279));
  183      vk.beta2 = Pairing.G2Point([uint256(12168528810181263706895252315640534818222943348193302139358377162645029937006), uint256(281120578337195720357474965979947690431622127986816839208576358024608803542)], [uint256(16129176515713072042442734839012966563817890688785805090011011570989315559913), uint256(9011703453772030375124466642203641636825223906145908770308724549646909480510)]);
  184      vk.gamma2 = Pairing.G2Point([uint256(11559732032986387107991004021392285783925812861821192530917403151452391805634), uint256(10857046999023057135944570762232829481370756359578518086990519993285655852781)], [uint256(4082367875863433681332203403145435568316851327593401208105741076214120093531), uint256(8495653923123431417604973247489272438418190587263600148770280649306958101930)]);
  185      vk.delta2 = Pairing.G2Point([uint256(21280594949518992153305586783242820682644996932183186320680800072133486887432), uint256(150879136433974552800030963899771162647715069685890547489132178314736470662)], [uint256(1081836006956609894549771334721413187913047383331561601606260283167615953295), uint256(11434086686358152335540554643130007307617078324975981257823476472104616196090)]);
  186      vk.IC[0] = Pairing.G1Point(uint256(16225148364316337376768119297456868908427925829817748684139175309620217098814), uint256(5167268689450204162046084442581051565997733233062478317813755636162413164690));
  187      vk.IC[1] = Pairing.G1Point(uint256(12882377842072682264979317445365303375159828272423495088911985689463022094260), uint256(19488215856665173565526758360510125932214252767275816329232454875804474844786));
  188      vk.IC[2] = Pairing.G1Point(uint256(13083492661683431044045992285476184182144099829507350352128615182516530014777), uint256(602051281796153692392523702676782023472744522032670801091617246498551238913));
  189      vk.IC[3] = Pairing.G1Point(uint256(9732465972180335629969421513785602934706096902316483580882842789662669212890), uint256(2776526698606888434074200384264824461688198384989521091253289776235602495678));
  190      vk.IC[4] = Pairing.G1Point(uint256(8586364274534577154894611080234048648883781955345622578531233113180532234842), uint256(21276134929883121123323359450658320820075698490666870487450985603988214349407));
  191      vk.IC[5] = Pairing.G1Point(uint256(4910628533171597675018724709631788948355422829499855033965018665300386637884), uint256(20532468890024084510431799098097081600480376127870299142189696620752500664302));
  192      vk.IC[6] = Pairing.G1Point(uint256(15335858102289947642505450692012116222827233918185150176888641903531542034017), uint256(5311597067667671581646709998171703828965875677637292315055030353779531404812));
  193  
  194    }
  195  
  196    /*
  197     * @returns Whether the proof is valid given the hardcoded verifying key
  198     *          above and the public inputs
  199     */
  200    function verifyProof(
  201      bytes memory proof,
  202      uint256[6] memory input
  203    ) public view returns (bool) {
  204      uint256[8] memory p = abi.decode(proof, (uint256[8]));
  ...
  208        require(p[i] < PRIME_Q, "verifier-proof-element-gte-prime-q");
  209      }
  210  
  211      Proof memory _proof;
  212      _proof.A = Pairing.G1Point(p[0], p[1]);
  213      _proof.B = Pairing.G2Point([p[2], p[3]], [p[4], p[5]]);
  214      _proof.C = Pairing.G1Point(p[6], p[7]);
  215  
  216      VerifyingKey memory vk = verifyingKey();
  217  
  218      // Compute the linear combination vk_x
  219      Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
  220      vk_x = Pairing.plus(vk_x, vk.IC[0]);
  221  
  222      // Make sure that every input is less than the snark scalar field
  223      for (uint256 i = 0; i < input.length; i++) {
  224        require(input[i] < SNARK_SCALAR_FIELD, "verifier-gte-snark-scalar-field");
  225        vk_x = Pairing.plus(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
  226      }
  227  
  228      return Pairing.pairing(
  229        Pairing.negate(_proof.A),
  230        _proof.B,
  231        vk.alfa1,
  232        vk.beta2,
  233        vk_x,
  ...
```
