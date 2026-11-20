---
id: 23cab3cf-wallets-fixed-signers
title: "0x23cab3cf (tagged created by dYdX: Gps Statement Verifier Governor): wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x23cab3cf1aa7b929df5e9f3712aca3a6fb9494e4"
  family: "ad46f6c058e98be9e274f1d845ad6716"
  copies: 4
  label: "created by dYdX: Gps Statement Verifier Governor"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "none -- isMember(address) and signaturesRequired() have no setter in the 6-selector dispatcher"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "refutes the wallet/HIGH framing (no funds custodied by this contract); the real issue is liveness of availability attestations for an external system, rated MEDIUM per the 'oracle feed/relayer' bucket rather than HIGH/funds-locked"
---

## Summary

Not SimpleMultiSig -- dispatcher is verifyAvailabilityProof(bytes32,bytes)/isMember(address)/signaturesRequired()/isValid(bytes32)/hasRegisteredFact()/identify(), the classic StarkEx committee-availability-verifier ABI (row label: 'created by dYdX: Gps Statement Verifier Governor'). Committee membership is a fixed mapping with no setter found. The contract itself holds no funds; it only attests data availability for an external StarkEx/dYdX system. Once a committee member's EOA takes code it can never satisfy the on-chain check again, and with no setter the signature threshold can become permanently unreachable, halting new availability confirmations for that external system.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher selectors: 0x504f7f6f(verifyAvailabilityProof)/0x6a938567(isValid)/isMember(address)/signaturesRequired()/0xd6354e15/identify() -- none match template 8f5fee6f
- decompile: isMember returns storage_map_e[arg0] with no write path in the 6 resolved functions; signaturesRequired() returns store_b with no setter
- row.label = 'created by dYdX: Gps Statement Verifier Governor'
- committee member addresses could not be enumerated (no public array/getter; an event-log scan to find them is outside the RPC budget given the current node congestion) so their current EOA/contract status is unverified

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none found

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
