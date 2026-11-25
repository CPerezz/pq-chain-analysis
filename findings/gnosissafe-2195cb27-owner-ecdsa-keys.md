---
id: gnosissafe-2195cb27-owner-ecdsa-keys
format: 2
title: Safe multisig lets a quantum attacker holding owner ECDSA keys move its funds
status: confirmed
severity: MEDIUM
justification: 'Owners approve with ECDSA; Safe accepts contract owners, so owners can swap in post-quantum signers:
  MEDIUM.'
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2195cb272e3302dd234867bc85ca67b8560e3cdd'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 10203
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, which the Safe accepts as contract
  owners.
evidence_level: source
checks:
- id: c1
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign-style signatures are verified with ecrecover.
  for:
  - evidence-1
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default signatures are verified with ecrecover on the data hash.
  for:
  - evidence-1
  - justification
  - what
- id: code
  code: '0x2195cb272e3302dd234867bc85ca67b8560e3cdd'
  is: contract
  bytes: 171
  says: The address holds contract code.
  for:
  - what
- id: c3
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  line: 285
  says: Contract owners are checked through their own isValidSignature.
  for:
  - action
  - evidence-2
  - justification
- id: c4
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  line: 301
  says: Each recovered signer must be an owner.
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (source of 1.3.0 read, two real transactions replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This Safe 1.3.0 proxy runs a transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign transfers of everything the Safe holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the owner with ecrecover on the transaction hash.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also accepts contract owners through isValidSignature.

## Reviewer notes

### Mechanism

execTransaction calls checkNSignatures, which walks threshold-many 65-byte slots. For v > 30 it calls ecrecover on the eth_sign-prefixed hash (line 295); otherwise for v not 0 or 1 it calls ecrecover(dataHash, v, r, s) (line 299). Line 301 requires each recovered address to be an owner, in ascending order. Keys recovered from posted signatures satisfy this. v == 0 calls ISignatureValidator(owner).isValidSignature on the full contract signature (line 285), so a post-quantum signer contract can be an owner. v == 1 uses approveHash or msg.sender (line 291).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Owner list, threshold and modules of this Safe were not read in the checks shown.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
