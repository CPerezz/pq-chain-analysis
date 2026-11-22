---
id: contract-74f09cb3-wormhole-receiver
format: 2
title: Pyth Lazer governance receiver accepts forgeable ECDSA guardian quorums
status: candidate
severity: MEDIUM
justification: Forged guardian quorums let an attacker run Lazer governance; Pyth governance can fix it by repointing,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x74f09cb3c7e2a01865f424fd14f6dc9a14e3e94e'
  project: pyth
  code: decompiled
  code_url: code/0x4549fca50a9672af8304ecb096e3db0b9a4d387c0a5be0487e5281e435fc8c2c.sol
  proxy_of: '0x87047526937246727e4869c5f76a347160e08672'
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 382
impact: funds-loss
action: Repoint the Pyth executor to a receiver that verifies post-quantum guardian signatures, while the ECDSA
  keys are still safe.
evidence_level: bytecode
checks:
- id: code
  code: '0x74f09cb3c7e2a01865f424fd14f6dc9a14e3e94e'
  is: contract
  bytes: 842
  says: The address holds contract code.
  for:
  - what
- id: sel-verify
  selector: '0x87047526937246727e4869c5f76a347160e08672'
  fn: parseAndVerifyVM(bytes)
  says: The code verifies VAAs with parseAndVerifyVM.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-guardianset
  selector: '0x87047526937246727e4869c5f76a347160e08672'
  fn: submitNewGuardianSet(bytes)
  says: The code replaces the guardian set via a signed VAA.
  for:
  - evidence-2
  - justification
  - what
- id: sel-index
  selector: '0x87047526937246727e4869c5f76a347160e08672'
  fn: getCurrentGuardianSetIndex()
  says: The code tracks a current guardian set index.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x74f09cb3
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (PythLazer source, bytecode selectors, on-chain reads, Blockscout internal calls)
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

This receiver verifies Wormhole-style governance messages by checking guardian ECDSA signatures against its stored guardian set. A quantum attacker who recovers enough guardian keys can forge accepted messages, including ones that replace the guardian set itself.

## Evidence

- [parseAndVerifyVM](https://etherscan.io/address/0x87047526937246727e4869c5f76a347160e08672#code) is in the code and checks message signatures against the guardian set.
- [submitNewGuardianSet](https://etherscan.io/address/0x87047526937246727e4869c5f76a347160e08672#code) is in the code and changes the guardian set through a signed message.
- [getCurrentGuardianSetIndex](https://etherscan.io/address/0x87047526937246727e4869c5f76a347160e08672#code) is in the code and returns the active guardian set.

## Reviewer notes

### Mechanism

The proxy 0x74f09cb3 delegatecalls implementation 0x87047526. parseAndVerifyVM (selector 0xc0fd8bde) parses a VAA and looks up the guardian set by index in storage_map_b. It then checks ascending-index ECDSA signatures (error SignatureIndexesNotAscending) against that set. The Pyth executor 0xccd7e24e staticcalls this receiver to verify a governance VAA. It then acts as PythLazer's owner, which can add trusted signers and upgrade PythLazer. submitNewGuardianSet (0x6606b4e0) rotates the set, but only on a VAA signed by the current set. Kev's finding gives this set as 19 Wormhole keys with 13 needed. Forging that quorum therefore yields Lazer governance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds about $0 itself; exposure is through PythLazer governance.
- Ruled out: Rotating guardian keys keeps ECDSA and does not fix it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
