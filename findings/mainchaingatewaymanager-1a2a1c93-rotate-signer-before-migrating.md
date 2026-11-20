---
id: mainchaingatewaymanager-1a2a1c93-rotate-signer-before-migrating
title: "MainchainGatewayManager: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1a2a1c938ce3ec39b6d47113c7955baa9dd454f2"
  family: "bdf1434446e7ec86ccb6be3099ecaafc"
  copies: 4
  name: "MainchainGatewayManager"
  label: "Axie Infinity: Ronin Bridge"
  upgradeable: "yes"
  rating: NONE
  value_usd: 861858
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-19
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted as an EIP-8151 effect: the signature-checked withdrawals are already unreachable, the pause cannot be lifted, and the 'upgradeable' path is dead because the admin contract cannot call upgrade. The funds are frozen independently of EIP-8151. Main reviewer: you may prefer doubt."
---

## Summary

Ronin v1 MainchainGatewayManager proxy (469 ETH plus tokens). It was already permanently paused at the block: every withdrawal is whenNotPaused, and the gateway admin is a contract that can only pause. EIP-8151 changes nothing the gateway can still do.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Ronin v1 gateway ECVerify: true when the recovered address equals the one named / Ronin v1 mainchain gateway: signers ascending, counted when the validator contract accepts them, against its threshold. Read from source.
- At block (dossier state/facts 26438999): paused()=true, admin()/slot_0 = 0x23d48177…38fa, implementation 0x8407dc57…
- Proxy code (latest, block ~26452951; immutable): unpause 0x3f4ba83a, updateProxyTo, updateRegistry, changeAdmin and removeAdmin all require msg.sender == admin
- Admin 0x23d4…38fa code (latest, non-proxy, 753 bytes): only pauseGateway() (calls the gateway's pause 0x8456cb59), removeAdmin() and changeAdmin(address) of itself. It has no unpause, upgrade or registry call, so nobody can unpause or upgrade the gateway
- Source: withdrawToken/withdrawERC20/withdrawERC721 and their For variants all carry whenNotPaused

## Impact and exposure

- Value held at block 26,438,999: $861,858 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-19.

## Remediation

None that EIP-8151 makes necessary: validator signatures are already unusable while the gateway stays paused.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
