---
id: wormhole-98f3c9e6-guardian-signatures
format: 2
title: A quantum attacker with 13 guardian keys can forge Wormhole messages
status: confirmed
severity: MEDIUM
justification: Forged guardian keys fake every message, upgrades included; the fix is a governance upgrade the guardians
  sign.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x98f3c9e6e3face36baad05fe09d375ef1464288b'
  name: Wormhole
  project: wormhole
  code: verified
  code_url: https://etherscan.io/address/0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0#code
  proxy_of: '0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 6
  basis: held
activity: {}
impact: funds-loss
action: Upgrade this contract to post-quantum guardian signatures by a guardian-signed governance message while
  the ECDSA keys are safe.
evidence_level: source
checks:
- id: ecdsa
  source: '0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0'
  file: contracts/Messages.sol
  line: 93
  has: if(ecrecover(hash, sig.v, sig.r, sig.s) != guardianSet.keys[sig.guardianIndex]){
  says: each signature is recovered with ECDSA and must equal the guardian key at its index
  for:
  - evidence-1
  - justification
  - what
- id: quorum
  source: '0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0'
  file: contracts/Messages.sol
  lines:
  - 54
  - 56
  has: if (vm.signatures.length < quorum(guardianSet.keys.length)){ return (false, "no quorum");
  says: a message needs a quorum of guardian signatures
  for:
  - evidence-1
  - justification
  - what
- id: upgrade
  source: '0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0'
  file: contracts/Governance.sol
  lines:
  - 27
  - 48
  has: upgradeImplementation(upgrade.newContract);
  says: submitContractUpgrade swaps the implementation on a verified governance message
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
  - what
- id: govcur
  source: '0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0'
  file: contracts/Governance.sol
  lines:
  - 197
  - 200
  has: if (vm.guardianSetIndex != getCurrentGuardianSetIndex()) { return (false, "not signed by current guardian
    set");
  says: governance messages must be signed by the current guardian set
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel-upgrade
  selector: '0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0'
  fn: submitContractUpgrade(bytes)
  says: the running implementation exposes submitContractUpgrade
  for:
  - upgradeable
- id: gidx
  call: '0x98f3c9e6e3face36baad05fe09d375ef1464288b'
  fn: getCurrentGuardianSetIndex()(uint32)
  is: 7
  says: the current guardian set is 7
  for:
  - evidence-3
- id: gset
  call: '0x98f3c9e6e3face36baad05fe09d375ef1464288b'
  fn: getGuardianSet(uint32)((address[],uint32))
  args:
  - 7
  is:
  - - '0x5893B5A76c3f739645648885bDCcC06cd70a3Cd3'
    - '0xfF6CB952589BDE862c25Ef4392132fb9D4A42157'
    - '0x114De8460193bdf3A2fCf81f86a09765F4762fD1'
    - '0x107A0086b32d7A0977926A205131d8731D39cbEB'
    - '0x8C82B2fd82FaeD2711d59AF0F2499D16e726f6b2'
    - '0x42579bFFbCF4276E290aB8E4C162bd4052b97970'
    - '0x938f104AEb5581293216ce97d771e0CB721221B1'
    - '0xF3ea0AD4FFB5a178AE4EBc21861651B25BdcbB91'
    - '0x9D16870160e703324D057c3361c34C5beFBa2c34'
    - '0x000aC0076727b35FBea2dAc28fEE5cCB0fEA768e'
    - '0xAF45Ced136b9D9e24903464AE889F5C8a723FC14'
    - '0xf93124b7c738843CBB89E864c862c38cddCccF95'
    - '0xD2CC37A4dc036a8D232b48f62cDD4731412f4890'
    - '0xDA798F6896A3331F64b48c12D1D57Fd9cbe70811'
    - '0xaE565927Bb8dB25CD8Bf3e7BB663D70023e4Ea78'
    - '0x3F851Ad586A47ceF8d04748f33ab0D71395f06b4'
    - '0x178e21ad2E77AE06711549CFBB1f9c7a9d8096e8'
    - '0x7899cEAB1DC961Dae9defDB7A4f521269a5448FC'
    - '0x61D9800f9FCb4160FB0C6cf3A0902592bAC2B434'
  - 0
  says: guardian set 7 holds 19 keys and does not expire
  for:
  - evidence-3
  - what
- id: q19
  call: '0x98f3c9e6e3face36baad05fe09d375ef1464288b'
  fn: quorum(uint256)(uint256)
  args:
  - 19
  is: 13
  says: 13 signatures make a quorum of 19 guardians
  for:
  - evidence-3
  - what
- id: pname
  source: '0x98f3c9e6e3face36baad05fe09d375ef1464288b'
  file: Wormhole.sol
  line: 8
  has: contract Wormhole is ERC1967Proxy {
  says: the verified proxy is named Wormhole, in Wormhole's repository
  for:
  - name
- id: tb-core
  call: '0x3ee18b2214aff97000d974cf647e7c347e8fa585'
  fn: wormhole()(address)
  is: '0x98f3c9e6e3face36baad05fe09d375ef1464288b'
  says: Wormhole's token bridge uses this contract to verify messages
  for:
  - what
- id: tb-weth
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: balanceOf(address)(uint256)
  args:
  - '0x3ee18b2214aff97000d974cf647e7c347e8fa585'
  is: '48661498388110000000000'
  says: the token bridge holds 48,661 WETH
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (on-chain reads, bytecode selectors, Blockscout holdings and internal calls)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

Wormhole's core bridge accepts a message when 13 of its 19 guardians sign it with ECDSA. A quantum attacker who recovers 13 guardian keys can forge any message, including one that upgrades this contract. Wormhole's token bridge, which holds 48,661 WETH, verifies its messages here.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0#code) matches each ECDSA recovery with the guardian key at its index; two thirds of the keys plus one must sign.
- [submitContractUpgrade](https://etherscan.io/address/0x3c3d457f1522d3540ab3325aa5f1864e34cba9d0#code) replaces this contract's code on a message signed by the current guardian set.
- [Guardian set 7](https://etherscan.io/address/0x98f3c9e6e3face36baad05fe09d375ef1464288b#readProxyContract) is current and holds 19 keys; 13 signatures make a quorum.

## Reviewer notes

### Mechanism

Proxy 0x98f3c9e6 (EIP-1967) runs implementation 0x3c3d457f. parseAndVerifyVM -> verifyVM (Messages.sol 28-66) loads the guardian set named by the VAA, rejects an expired non-current set, requires quorum(n) = 2n/3+1 signatures (line 175; 13 of 19), then verifySignatures (74-100) requires ecrecover(hash, v, r, s) == guardianSet.keys[index] for every signature, indices strictly ascending. There is no other way to validate a VAA. Governance (Governance.sol) acts on VAAs that pass verifyVM, are signed by the current set (line 198) and come from governance chain 1, contract 0x04: submitContractUpgrade (27-49) swaps the implementation, submitNewGuardianSet (79-112) installs a new key set. So 13 recovered guardian keys forge both transfer messages consumed by integrators (the token bridge 0x3ee18b22 has wormhole() = this proxy) and the governance messages that would fix it. Current set index 7, 19 keys, all without code at the block; sets 0-6 have expiration times before the block timestamp (1794969479).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or another path for a guardian with code: verifySignatures has none, only ecrecover compared with the stored key (Messages.sol line 93).
- Ruled out: Unused implementation: this is the proxy in use; the trace window shows 7,327 transactions and 19 distinct recovered guardians.
- Ruled out: Key state: getGuardianSet(7) returns 19 keys and every one has no code at block 26,438,999 (cast codesize); older sets 0-6 all expired before the block's timestamp.
- Ruled out: Fixed gas: Solidity's ecrecover forwards all available gas; there is no constant gas amount for the precompile in Messages.sol.
- Ruled out: Replays: both listed replays revert under EIP-8151 with guardians that are plain accounts, using about 3,300 more gas; that is a sender gas-limit issue (relayers' gas limits), separate from this exposure, for the reviewer to link as its own finding. Not cited here.
- Ruled out: Value: the core itself holds about $6; the funds at stake sit in integrators such as the token bridge, which this card does not total.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
