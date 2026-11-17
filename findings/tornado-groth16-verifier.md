---
id: tornado-groth16-verifier
title: "Tornado Cash: a quantum attacker who recovers the Groth16 setup trapdoor can forge withdraw proofs and drain all 19 classic pools (about $577M) through Verifier 0xce172ce1"
project: tornado-cash
status: confirmed
severity: CRITICAL
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xce172ce1f20ec0b3728c9965470eaf994a03557a"
  implementation: null
  name: Verifier
  upgradeable: "no"
  admin: none (no proxy, no owner; the 19 pools hold it as `verifier`, immutable or behind an operator set to 0x0)
  value_usd: 577264563
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 7048
families: []
fix:
  layer: new-deployment
  who_acts: nobody can change the pools; each depositor must withdraw with a valid note before a CRQC exists, and new pools would need a post-quantum proof system
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tornado-groth16-verifier
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
  who: Review03 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tornado-groth16-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: CRITICAL
related: []
---

## Summary

Every classic Tornado Cash pool (4 ETH, 4 DAI, 4 cDAI, 2 USDC, 2 USDT, 3 WBTC) releases its fixed denomination to
whoever presents a Groth16 proof that `Verifier` 0xce172ce1 accepts (PQ-7). A quantum attacker who recovers the
trapdoor of the BN254 trusted setup from the verifying key can forge proofs for unspent nullifiers and empty every
pool: about $577M at block 26,431,528, of which $564M is the 310,260 ETH in the ETH pools. Rated CRITICAL (step 4): pooled
funds are released by a forged proof, the pools are immutable with no operator, and the many anonymous depositors
cannot all move.

## Mechanism

- Each pool's `withdraw(bytes _proof, bytes32 _root, bytes32 _nullifierHash, address _recipient, address _relayer,
  uint256 _fee, uint256 _refund)` checks the nullifier is unspent and the root known, then
  `require(verifier.verifyProof(_proof, [root, nullifierHash, recipient, relayer, fee, refund]))`, marks the
  nullifier spent and calls `_processWithdraw`, which sends `denomination` to `_recipient` (verified source of
  `TornadoCash_eth` 0xa160cd…, solc 0.5.11).
- `Verifier.verifyProof(bytes proof, uint256[6] input)` (excerpt lines 187–220) builds `vk_x` from the hard-coded
  `IC` points with `ecadd`/`ecmul` (precompiles 6 and 7) and runs the pairing check (precompile 8) against the
  hard-coded `alfa1`, `beta2`, `gamma2`, `delta2` (lines 168–181). Whoever knows the setup trapdoor can produce a proof
  for any public input, so any nullifier hash not yet spent can be withdrawn to any recipient.
- No other check guards the funds: the Merkle root only has to be one of the recent known roots, which are public.

## Evidence

- CHECKED (verified source, Sourcify): `Verifier.sol` Groth16 verifier with hard-coded verifying key
  ([`source-excerpts.md`](#source-excerpts-tornado-groth16-verifier)).
- CHECKED (verified source, Blockscout): `TornadoCash_eth` 0xa160cd… `withdraw` calls `verifier.verifyProof`;
  `verifier` is a storage variable changeable only through `updateVerifier` by `operator`. `ERC20Tornado` 0x23773e…
  and 0xbb93e5… (solc 0.7.6) declare `IVerifier public immutable verifier` with no update function.
- CHECKED (on-chain read, block 26,431,528): InstanceRegistry 0xb20c66c4… `getAllInstanceAddresses()` returns 19
  pools; `verifier()` of every one is 0xce172ce1…; `operator()` returns 0x0 on the 11 pools that have it and reverts
  on the 8 that do not; EIP-1967 implementation and admin slots are empty on all 19; balances and DefiLlama prices
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tornado-groth16-verifier/escrow.json)).
- CHECKED (on-chain read, block 26,431,214): the verifier is not a proxy and has no owner and no holdings
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tornado-groth16-verifier/onchain.json)).
- CHECKED (Xatu call frames, 72 sampled partitions between blocks 24,700,000 and 26,423,999): every contract that
  called the verifier is one of the registry pools ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tornado-groth16-verifier/escrow.json)).
- CHECKED (Xatu, any function): 7,048 transactions reached the verifier in 2026-10-16 to 2026-11-16, last on
  2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tornado-groth16-verifier/activity.json)); the yearly pre-quantum count in
  `curated_contracts.csv` is `txs_y1` = 52,703 calls.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xce172ce1…` Verifier | no | $0 (escrow: $577.3M in the 19 pools) | 2026-11-16 | 7,048 |

Escrow (the pools that call the verifier), block 26,431,528, DefiLlama prices at that time:

| Asset | Pools (denominations) | Held | USD |
|---|---|---|---|
| ETH | 0x12d66f… 0.1, 0x47ce0c… 1, 0x910cbd… 10, 0xa160cd… 100 | 310,259.9 ETH | $563.7M |
| DAI | 0xd4b88d… 100, 0xfd8610… 1k, 0x07687e… 10k, 0x23773e… 100k | 8,065,400 DAI | $8.06M |
| WBTC | 0x178169… 0.1, 0x610b71… 1, 0xbb93e5… 10 | 83.3 WBTC | $5.38M |
| USDT | 0x169ad2… 100, 0x083622… 1k | 40,403 USDT | $40.4k |
| USDC | 0xd96f2b… 100, 0x4736dc… 1k | 30,600 USDC | $30.6k |
| cDAI | 0x22aaa7… 5k, 0x03893a… 50k, 0x2717c5… 500k, 0xd21be7… 5M | 1,010,000 cDAI | $25.3k |

The 100 ETH pool alone holds $510.7M. The ETH and DAI/USDC/USDT 100/1k pools have the operator-controlled verifier
slot, but their operator is 0x0, so it can no longer be changed. Tornado governance (TORN) controls the router and
registry, not the pools.

## Remediation

- Post-quantum replacement: new pools whose withdraw proof uses a hash-based proof system (STARK/FRI or similar) and
  a hash-only commitment tree. That does not protect the existing pools: their verifier cannot be changed by anyone.
- Who acts: each depositor, by withdrawing with their note (to a fresh address) before a CRQC exists. Notes that are
  lost or never withdrawn stay forgeable. Tornado governance can only steer new deposits (router, UI) to new pools.
- Protocol change: none would help here; the pools have no account key to protect, and only the setup trapdoor
  is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review03): CRITICAL unchanged (step 4). Escrow measured: 19 registry pools, all pointing at this verifier, $577.3M at block 26,431,528; operators 0x0 or absent, verifier immutable; callers checked in Xatu.

# Source excerpts: tornado-groth16-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xce172ce1f20ec0b3728c9965470eaf994a03557a` — Verifier (verified source via sourcify)

### `Verifier.sol`

```solidity
   28  // 2019 OKIMS
   29  
   30  pragma solidity 0.5.17;
   31  
   32  library Pairing {
   33      uint256 constant PRIME_Q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
   34  
   35      struct G1Point {
   36          uint256 X;
  ...
   75              // Use "invalid" to make gas estimation work
   76              switch success case 0 { invalid() }
   77          }
   78  
   79          require(success, "pairing-add-failed");
   80      }
   81  
   82      /*
   83       * @return r the product of a point on G1 and a scalar, i.e.
  ...
   95              success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
   96              // Use "invalid" to make gas estimation work
   97              switch success case 0 { invalid() }
   98          }
   99          require(success, "pairing-mul-failed");
  100      }
  101  
  102      /* @return The result of computing the pairing check
  103       *         e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
  104       *         For example,
  105       *         pairing([P1(), P1().negate()], [P2(), P2()]) should return true.
  106       */
  107      function pairing(
  108          G1Point memory a1,
  109          G2Point memory a2,
  110          G1Point memory b1,
  111          G2Point memory b2,
  ...
  139              // Use "invalid" to make gas estimation work
  140              switch success case 0 { invalid() }
  141          }
  142  
  143          require(success, "pairing-opcode-failed");
  144  
  145          return out[0] != 0;
  146      }
  147  }
  148  
  149  contract Verifier {
  150      uint256 constant SNARK_SCALAR_FIELD = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
  151      uint256 constant PRIME_Q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
  152      using Pairing for *;
  153  
  154      struct VerifyingKey {
  155          Pairing.G1Point alfa1;
  156          Pairing.G2Point beta2;
  157          Pairing.G2Point gamma2;
  158          Pairing.G2Point delta2;
  159          Pairing.G1Point[7] IC;
  160      }
  161  
  162      struct Proof {
  163          Pairing.G1Point A;
  164          Pairing.G2Point B;
  165          Pairing.G1Point C;
  166      }
  167  
  168      function verifyingKey() internal pure returns (VerifyingKey memory vk) {
  169          vk.alfa1 = Pairing.G1Point(uint256(20692898189092739278193869274495556617788530808486270118371701516666252877969), uint256(11713062878292653967971378194351968039596396853904572879488166084231740557279));
  170          vk.beta2 = Pairing.G2Point([uint256(12168528810181263706895252315640534818222943348193302139358377162645029937006), uint256(281120578337195720357474965979947690431622127986816839208576358024608803542)], [uint256(16129176515713072042442734839012966563817890688785805090011011570989315559913), uint256(9011703453772030375124466642203641636825223906145908770308724549646909480510)]);
  171          vk.gamma2 = Pairing.G2Point([uint256(11559732032986387107991004021392285783925812861821192530917403151452391805634), uint256(10857046999023057135944570762232829481370756359578518086990519993285655852781)], [uint256(4082367875863433681332203403145435568316851327593401208105741076214120093531), uint256(8495653923123431417604973247489272438418190587263600148770280649306958101930)]);
  172          vk.delta2 = Pairing.G2Point([uint256(21280594949518992153305586783242820682644996932183186320680800072133486887432), uint256(150879136433974552800030963899771162647715069685890547489132178314736470662)], [uint256(1081836006956609894549771334721413187913047383331561601606260283167615953295), uint256(11434086686358152335540554643130007307617078324975981257823476472104616196090)]);
  173          vk.IC[0] = Pairing.G1Point(uint256(16225148364316337376768119297456868908427925829817748684139175309620217098814), uint256(5167268689450204162046084442581051565997733233062478317813755636162413164690));
  174          vk.IC[1] = Pairing.G1Point(uint256(12882377842072682264979317445365303375159828272423495088911985689463022094260), uint256(19488215856665173565526758360510125932214252767275816329232454875804474844786));
  175          vk.IC[2] = Pairing.G1Point(uint256(13083492661683431044045992285476184182144099829507350352128615182516530014777), uint256(602051281796153692392523702676782023472744522032670801091617246498551238913));
  176          vk.IC[3] = Pairing.G1Point(uint256(9732465972180335629969421513785602934706096902316483580882842789662669212890), uint256(2776526698606888434074200384264824461688198384989521091253289776235602495678));
  177          vk.IC[4] = Pairing.G1Point(uint256(8586364274534577154894611080234048648883781955345622578531233113180532234842), uint256(21276134929883121123323359450658320820075698490666870487450985603988214349407));
  178          vk.IC[5] = Pairing.G1Point(uint256(4910628533171597675018724709631788948355422829499855033965018665300386637884), uint256(20532468890024084510431799098097081600480376127870299142189696620752500664302));
  179          vk.IC[6] = Pairing.G1Point(uint256(15335858102289947642505450692012116222827233918185150176888641903531542034017), uint256(5311597067667671581646709998171703828965875677637292315055030353779531404812));
  180  
  181      }
  182  
  183      /*
  184       * @returns Whether the proof is valid given the hardcoded verifying key
  185       *          above and the public inputs
  186       */
  187      function verifyProof(
  188          bytes memory proof,
  189          uint256[6] memory input
  190      ) public view returns (bool) {
  191          uint256[8] memory p = abi.decode(proof, (uint256[8]));
  ...
  195              require(p[i] < PRIME_Q, "verifier-proof-element-gte-prime-q");
  196          }
  197  
  198          Proof memory _proof;
  199          _proof.A = Pairing.G1Point(p[0], p[1]);
  200          _proof.B = Pairing.G2Point([p[2], p[3]], [p[4], p[5]]);
  201          _proof.C = Pairing.G1Point(p[6], p[7]);
  202  
  203          VerifyingKey memory vk = verifyingKey();
  204  
  205          // Compute the linear combination vk_x
  206          Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
  207          vk_x = Pairing.plus(vk_x, vk.IC[0]);
  208  
  209          // Make sure that every input is less than the snark scalar field
  210          for (uint256 i = 0; i < input.length; i++) {
  211              require(input[i] < SNARK_SCALAR_FIELD, "verifier-gte-snark-scalar-field");
  212              vk_x = Pairing.plus(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
  213          }
  214  
  215          return Pairing.pairing(
  216              Pairing.negate(_proof.A),
  217              _proof.B,
  218              vk.alfa1,
  219              vk.beta2,
  220              vk_x,
  ...
```
