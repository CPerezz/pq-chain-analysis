---
id: saclienterc20-3ea5eaaa-own-signature-only-exit
title: "SAClientERC20: funds released only by the party's own signature"
status: confirmed
severity: LOW
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x3ea5eaaa2727a38f2a16151e8b85017f966e4656"
  family: "777e08a9ce4ae5874141449c0abf0ade"
  name: "SAClientERC20"
  upgradeable: "yes"
  admin: "0x0e46e654dc33f86bd9ee9b103a1bd3afdcc8d7de"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin owner 0x3b84..f251"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live upgrade path via ProxyAdmin -> LOW; contradicts the row's 'Update path: no proxy slot' (it measured the implementation, not proxy 0xb400)."
---

## Summary

Stealth-address token pool: balances credited to a saDest key move only by a relayed request whose ecrecover equals saDest (no direct call), so a saDest with code would be stuck. The address is the implementation behind TransparentUpgradeableProxy 0xb400..bc15, whose ProxyAdmin is owned by a live EOA.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: SAClientERC20: tokens credited to a key address (saDest) move only by a relayed request signed by that key; no direct call. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- contracts/SAClientERC20.sol _verifySASig L224-233: ecrecover(hash, v, r, s) must equal relayerRequest.saDest; every SA outflow (transferSAtoEOA/SA/Handler L199-221) goes through it
- Proxy 0xb40078c3871dcf6757e92f5369019fa20bf2bc15: EIP-1967 impl slot = 0x3ea5eaaa..., admin = ProxyAdmin 0x0e46e654dc33f86bd9ee9b103a1bd3afdcc8d7de; the proxy holds 0.104 ETH
- ProxyAdmin.owner() = proxy owner() = 0x3b84F56CCae06d51F0634e2f1550336CAA47F251, an EOA (nonce 165) at block 26438999
- At 0x3ea5 itself, owner()=0x0 and the balance is 0 (bare implementation); row value n/a, txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The ProxyAdmin owner can upgrade to add an ERC-1271 or direct-call path if a saDest ever takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
