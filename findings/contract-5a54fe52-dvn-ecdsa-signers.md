---
id: contract-5a54fe52-dvn-ecdsa-signers
format: 2
title: LayerZero TSS DVN accepts ECDSA signer quorums a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Forged signer quorums verify fake messages that release bridged funds; operators fix it by deploying
  post-quantum DVNs.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5a54fe5234e811466d5366846283323c954310b2'
  project: layerzero
  code: decompiled
  code_url: code/0x8271b7c92bcbb93eedac68962b6f5ab92f1710e49f30bff76f475fc807d43efe.sol
  proxy_of: '0x3eea8d627ab6983fffc7027ee623fd7699343fc1'
  copies: 1
  upgradeable: 'yes'
  admin: '0x967baf657ec4d4b1cb00b06f7cc6e8ba604e3ac8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 59
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs, and have OApps and defaults point at it.
evidence_level: bytecode
checks:
- id: sel-quorum
  selector: '0x3eea8d627ab6983fffc7027ee623fd7699343fc1'
  fn: quorum()
  says: The code exposes a signer quorum getter.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-setquorum
  selector: '0x3eea8d627ab6983fffc7027ee623fd7699343fc1'
  fn: setQuorum(uint64)
  says: The code has a function that sets the signer quorum.
  for:
  - evidence-2
  - justification
  - what
- id: sel-committeesize
  selector: '0x3eea8d627ab6983fffc7027ee623fd7699343fc1'
  fn: committeeSize()
  says: The code exposes the committee size.
  for:
  - evidence-3
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
reviews: []
related: []
---

## What happens

This upgradeable LayerZero DVN (TSS) acts on a quorum of committee signatures and changes its own quorum through a self-call. A quantum attacker who recovers enough ECDSA signer keys forges that quorum and verifies fabricated cross-chain packets for OApps that require this DVN.

## Evidence

- [quorum](https://etherscan.io/address/0x3eea8d627ab6983fffc7027ee623fd7699343fc1#code) exposes the number of signer approvals the DVN requires.
- [setQuorum](https://etherscan.io/address/0x3eea8d627ab6983fffc7027ee623fd7699343fc1#code) changes the quorum and is callable by the contract itself.
- [committeeSize](https://etherscan.io/address/0x3eea8d627ab6983fffc7027ee623fd7699343fc1#code) reports the size of the signing committee.

## Reviewer notes

### Mechanism

Proxy 0x5a54fe52 delegates to the unverified implementation 0x3eea8d62 (ProxyAdmin 0x967baf65). The decompiled bytecode shows a MultiSigOracle-style committee: quorum() is read from storage, setQuorum(uint64) requires msg.sender == address(this) and 0 < quorum <= committee size, and committeeSize()/committeeStatus() describe the signer set. Kev's precompile trace shows this contract calling ecrecover. Per the finding, it checks a 2-of-2 quorum of secp256k1 signatures before verifying packets for ReceiveUln302. Recovering both keys from posted signatures lets an attacker verify a forged packet. If this DVN is in an OApp's required set and the other required DVNs are forged too, the OApp's lzReceive releases or mints funds.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; the funds at risk sit in the OApps that require it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
