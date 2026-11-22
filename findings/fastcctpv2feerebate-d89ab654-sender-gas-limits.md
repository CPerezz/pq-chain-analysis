---
id: fastcctpv2feerebate-d89ab654-sender-gas-limits
format: 2
title: Batch claims of Circle transfers fail on tight gas limits after EIP-8151
status: confirmed
severity: LOW
justification: A real batch claim fails only on its sender's gas limit, and a higher limit fixes it.
category: breaks-at-activation
pattern: PQ-18
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd89ab65485da0f6fcfc78ed22dec97f95780a93a'
  name: FastCCTPV2FeeRebate
  code: verified
  code_url: https://etherscan.io/address/0xd89ab65485da0f6fcfc78ed22dec97f95780a93a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 440
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate batch-claim gas limits under EIP-8151: this batch used 9,000 more gas and still failed at its
  1,800,069 limit.'
evidence_level: executed
checks:
- id: fn
  source: '0xd89ab65485da0f6fcfc78ed22dec97f95780a93a'
  file: contracts/FastCCTPV2FeeRebate.sol
  line: 28
  has: function batchClaimTransfers(bytes[] calldata allMessages, bytes[] calldata attestations) external {
  says: anyone can call batchClaimTransfers with a batch of messages and their attestations
  for:
  - evidence-1
  - what
- id: fwd
  source: '0xd89ab65485da0f6fcfc78ed22dec97f95780a93a'
  file: contracts/FastCCTPV2FeeRebate.sol
  line: 48
  has: fastCCTPV2.batchClaimTransfers(allMessages, attestations);
  says: the batch and its attestations are forwarded to the claim contract with no gas amount set
  for:
  - evidence-1
  - justification
  - what
- id: tx
  tx: '0xfa70febd90050ad2752f3e7500b91c23c7db8c26f59b290b5e20c4bcb59b8ca1'
  to: '0xd89ab65485da0f6fcfc78ed22dec97f95780a93a'
  ok: true
  says: a real batch claim sent to this contract succeeded
  for:
  - evidence-2
  - what
- id: replay-today
  replay: '0xfa70febd90050ad2752f3e7500b91c23c7db8c26f59b290b5e20c4bcb59b8ca1'
  run: today
  ok: true
  says: replayed under today's rules the batch claim succeeds
  for:
  - evidence-2
  - what
- id: replay-8151
  replay: '0xfa70febd90050ad2752f3e7500b91c23c7db8c26f59b290b5e20c4bcb59b8ca1'
  run: eip8151
  ok: false
  says: under EIP-8151 the batch claim fails with its original gas limit
  for:
  - action
  - evidence-2
  - justification
  - what
- id: replay-more-gas
  replay: '0xfa70febd90050ad2752f3e7500b91c23c7db8c26f59b290b5e20c4bcb59b8ca1'
  run: eip8151_more_gas
  ok: true
  says: under EIP-8151 with 300,000 more gas the batch claim succeeds
  for:
  - action
  - evidence-2
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

This contract checks a batch of Circle transfer messages and passes them, with their attestations, to a claim contract. A real batch claim that succeeded today fails under EIP-8151 with the gas limit it was sent with, and passes with 300,000 more gas.

## Evidence

- [batchClaimTransfers](https://etherscan.io/address/0xd89ab65485da0f6fcfc78ed22dec97f95780a93a#code) forwards the messages and attestations to the claim contract with no gas amount of its own.
- [This batch claim](https://etherscan.io/tx/0xfa70febd90050ad2752f3e7500b91c23c7db8c26f59b290b5e20c4bcb59b8ca1) succeeded; replayed under EIP-8151 it fails as sent and passes with 300,000 more gas.

## Reviewer notes

### Mechanism

batchClaimTransfers (lines 28-50) checks each message's recipient, mint recipient and fee fields, approves the summed fees in USDC to the immutable claim contract fastCCTPV2 (0x047669eb...095a), calls fastCCTPV2.batchClaimTransfers(allMessages, attestations) with no gas argument (line 48), and resets the approval. The claim contract has Circle's MessageTransmitterV2 (0x81d40f21...4b64, signatureThreshold() = 2 at the block) verify each attestation by ECDSA recovery. Tx 0xfa70febd... (sender EOA 0xa0c85ffa...593b, no code, nonce 154,744 at the block; gas limit 1,800,069, gas used 1,568,143) calls this address directly and emits 8 MessageReceived events from MessageTransmitterV2, so about 16 recoveries. Under EIP-8151 the replay fails as sent and passes with 300,000 more gas, so the failure is the sender's gas limit, not a budget fixed in code. No other step in the transaction checks a user's signature: the only signatures are the Circle attesters'.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a gas amount fixed in this contract: line 48 forwards all remaining gas, and the EIP-8151 replay with 300,000 more gas passes.
- Ruled out: an attester whose account has real code: the replay under EIP-8151 passes with more gas, so every recovery still returns its signer.
- Ruled out: the failing transaction belonging to another contract: it is sent to this address, whose sender sets the gas limit; the recoveries themselves happen in Circle's MessageTransmitterV2, which has its own row.
- Ruled out: a proxy or upgrade path: the code has no delegatecall and the address no proxy slot (tool facts); the contract has no owner or withdraw function (lines 7-51).
- Ruled out: The number: Claude took it from the replays, not from a per-signature figure. The today run used 1,568,143 gas and the eip8151_more_gas run 1,577,143, so this transaction needs 9,000 more. A limit raised by exactly that may still fail: each nested call keeps back 1/64 of what is left.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
