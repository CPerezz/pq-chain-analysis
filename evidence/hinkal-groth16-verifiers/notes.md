# Review notes (Review23, 2026-11-17)

## How Hinkal checks proofs (verified source, Sourcify, Hinkal `0x25e5e82f5702a27c3466fe68f14abdbbadfca826`)

- `Hinkal.transact(a, b, c, dimensions, circomData)` → `VerifierFacade.verifyProof(a, b, c, input, buildVerifierId(dimensions, externalActionId))`
  → `verifierMap[verifierId].verifyProof(a, b, c, input, verifierId)` (selector `0x6743734c`).
- `registerVerifiers(uint256[] ids, address[] verifiers)` and `removeVerifier(id)` are `onlyOwner` (Ownable2Step).
- Each registered address is a small wrapper (≈1,325 bytes, deployer `0xc2212d20…`) that forwards to one fixed
  snarkjs-style Groth16 verifier `verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[n])` (address embedded in
  the wrapper's code).

## The six census verifiers are retired (traces via eth.drpc.org `trace_block`; reads at block ~26,431,576)

| Verifier | Wrapper that called it | verifierId used | verifierMap(id) now |
|---|---|---|---|
| 0x45926fe3… (4 inputs) | 0x56651dc0… | 0x58848304… | 0x6f8865d8… |
| 0x73567fbb… (18) | 0x109569e8… | 0xfa58fbc6… | 0x163fe0b0… |
| 0x5099c001… (20) | 0xbfabaf16… | 0x30382e94… | 0x163fe0b0… |
| 0x5b3fb770… (26) | 0x376725ab… | 0x8fb63dca… | 0x4d890d7f… |
| 0x96a0ea20… (34) | 0xc54d0326… | 0xb2ea2c02… | 0x50ca9296… |
| 0x96b3597f… (29) | 0xdbc1309d… | 0xc26d639b… | 0x4d890d7f… |

- Owner EOA `0xbdc77a0c…` re-registered all ids on 2026-06-10 (6 `registerVerifiers` txs, blocks 25,285,697–25,285,711);
  the six verifiers' last calls are 2026-06-09/10.
- All 117 `VerifierRegistered` events of `0x25e5e82f…` (Routescan logs API): 64 distinct ids; `verifierMap(id)` read
  now for every id: none points to any of the six old wrappers; none of the 32 currently registered wrappers' code
  contains any of the six verifier addresses.
- Other Hinkal pools: `0x7cb60446…` (149 registrations) and `0x2ea81946…` (321): none registers the six verifiers or
  their wrappers; none of their 117 distinct registered wrappers' code contains the six addresses.

## Live Hinkal verification is still BN254 Groth16

- `0x25e5e82f…` tx `0x095ac30c…` (2026-09-21): wrapper `0x163fe0b0…` → verifier `0x2617f5b358dd51fe8e2357b0ef80254e8d515d74`
  (`verifyProof(...,uint256[14])`, code contains the BN254 base-field modulus).
- `0x7cb60446…` tx `0xd2b98b24…` (2026-11): wrapper `0x8c16d510…` → verifier `0x2cd65ac8e4bf2ac3d21fdb0b9330cf6233b1ca4d`
  (`verifyProof(...,uint256[15])`, BN254 modulus present).
- `0x2ea81946…` tx `0x2367b289…` (2026-05-29): wrapper `0xe0f73f57…` → verifier `0x27ff63ee7a1501fe4457d753cd55cb90c79719ea`
  (BN254 modulus present).

## Who can change it (reads at block 26,431,610)

- `0x25e5e82f…` and `0x2ea81946…`: no EIP-1967 slots; `owner()` = `0xbdc77a0c69f13207acb70a6981cad60b4c1d1942` (EOA).
- `0x7cb60446…`: no EIP-1967 slots; `owner()` = HinkalTimelockController `0xf04310839973454155d9886a4023451f8d3db7d0`
  (`getMinDelay()` = 21,600 s); proposer, executor and canceller roles granted to Safe
  `0x4d28b33517ab72e7e2f728ff6527f8256cced7fb` (2 of 3: `0xbdc77a0c…`, `0x6c7fc304…`, `0x091418cb…`).

## Escrow

Pool holdings in [`escrow.json`](escrow.json): `0x25e5e82f…` $12,978; `0x7cb60446…` $63,939; `0x2ea81946…`
$14,921 (ETH at $1,811.62 + Blockscout-priced ERC-20s). Last `transact`: 2026-09-21, 2026-11-17, 2026-05-29.
