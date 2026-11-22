---
id: governanceproposer-06ef1dcf-governance-proposer-sig
format: 2
title: Aztec GovernanceProposer counts ECDSA signals quantum attackers can forge
status: confirmed
severity: MEDIUM
justification: Forged proposer signals reach quorum and pass any payload; a Governance vote for a PQ proposer and
  rollup fixes it
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x06ef1dcf87e419c48b94a331b252819fadbd63ef'
  name: GovernanceProposer
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x06ef1dcf87e419c48b94a331b252819fadbd63ef#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13897
impact: funds-loss
action: Vote in a proposer contract and rollup version whose block proposers sign with post-quantum keys
evidence_level: source
checks:
- id: c1
  source: '0x06ef1dcf87e419c48b94a331b252819fadbd63ef'
  file: lib/l1-contracts/src/shared/libraries/SignatureLib.sol
  line: 25
  has: address recovered = ECDSA.recover(_digest, _signature.v, _signature.r, _signature.s);
  says: SignatureLib.verify recovers the signer with ECDSA.recover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x06ef1dcf87e419c48b94a331b252819fadbd63ef'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review00 (GovernanceProposer, Governance, GSE, RewardDistributor and rollup v3 source; configuration and
    voting power reads)
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

The GovernanceProposer collects payload signals from each slot's block proposer and accepts a signal when ECDSA recovers that proposer from the signature. A quantum attacker who recovers enough proposers' keys can forge signals to reach quorum and put any payload before Aztec Governance.

## Evidence

- [SignatureLib.verify](https://etherscan.io/address/0x06ef1dcf87e419c48b94a331b252819fadbd63ef#code) recovers the signer with ECDSA.recover and requires it to equal the expected signer.
- [ECDSA.tryRecover](https://etherscan.io/address/0x06ef1dcf87e419c48b94a331b252819fadbd63ef#code) obtains the signer from the ecrecover precompile.

## Reviewer notes

### Mechanism

EmpireBase._internalSignal (lines 275-312) sets signaler = selection.getCurrentProposer() of the canonical rollup. With an empty signature it requires msg.sender == signaler. Otherwise it verifies getSignalSignatureDigest(payload, slot) through SignatureLib.verify (line 25, ECDSA.recover -> ecrecover at ECDSA.sol line 148). The entry points are signal and signalWithSig. submitRoundWinner needs QUORUM_SIZE (600 of 1,000) signals and calls Governance.propose. Rollup.vote then votes the rollup's power and the stake that follows it in favour. An executed payload runs as Governance, which owns the Registry, GSE and RewardDistributor. It can therefore add an attacker rollup that withdraws the following stake, and it can recover reward tokens.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The direct-call path does not help: the proposer address is itself an ECDSA key.
- Ruled out: The contract is not upgradeable, so it must be replaced by a Governance vote.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
