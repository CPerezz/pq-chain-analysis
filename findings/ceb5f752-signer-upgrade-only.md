---
id: ceb5f752-signer-upgrade-only
title: "0xceb5f752: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xceb5f75270f18340597f9a0d36dbd75e1b26510f"
  family: "690098061e81cfa0c151da6b3fc2ee77"
  copies: 4
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The claim that signatures stop working once the signer has code is wrong for this code: a signer with code is routed to ERC-1271 instead of ecrecover, so EIP-8151 does not block it (provided the new code answers isValidSignature); refuted per the rubric's 'the code checks for code first... or accepts ERC-1271 for that signer'."
---

## Summary

17,946-byte account extension. Its signature check does EXTCODESIZE on the claimed signer before ever calling ecrecover: if the signer has code, it jumps straight to an ERC-1271 isValidSignature(bytes32,bytes) staticcall (selector 0x1626ba7e) and skips ecrecover entirely; ecrecover only runs for a code-less signer.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly of 0xceb5f752's own code (publicnode, latest, block ~26452845 — non-proxy contract, code immutable since 26438999): pc 0x0d3a ISZERO-checks the signer for non-zero, pc 0x0d4e EXTCODESIZE on it, pc 0x0d4f JUMPI to 0x0dce on codesize!=0
- pc 0x0dce: PUSH4 0x1626ba7e then GAS STATICCALL at 0x0df7 (ERC-1271 call) — reached only when the signer has code; falling through (codesize==0) leads to the EIP-2098/65-byte split and the ecrecover STATICCALL (PUSH1 0x01, GAS, STATICCALL) at 0x0db5
- Family 690098061e facts: n_ec=2 for this exact code hash, matching the two STATICCALLs found (ecrecover + ERC-1271), consistent with reason P6 'a code check beside the recovery: the account's code may be checked first'

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
