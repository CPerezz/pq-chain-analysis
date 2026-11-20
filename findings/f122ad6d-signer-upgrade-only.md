---
id: f122ad6d-signer-upgrade-only
title: "0xf122ad6d: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf122ad6d71bed71ae93ef19acf80dff448618669"
  family: "0260cd3e7faed3a7d04bb47d85803646"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "admin 0xa5c8c8b5… upgrades the config proxy 0x32a5d69f… so broker() returns a fresh key"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: the signer can be replaced through a live upgrade of the proxy."
---

## Summary

Not a BitFi Vault. This is the ClashOfNFT Passcard ERC721 ("PASSCARD"). Its signature mint 0xa7e91072(uint8 star,address token,bytes sig) requires ecrecover(hash) to equal broker(), which it reads at call time from the upgradeable config proxy 0x32a5d69f…. Today broker() is 0x1d78064b…, an address with no code. If the broker account gets non-7702 code, signed mints stop until the proxy upgrade points broker() at a new key. Mints via 0xdd951ed7 do not use a signature.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can…. Same code idiom as template ec3bbcc8, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- disassembly pc 0x1cd8–0x1d7b: recovered address EQ STATICCALL 0x32a5d69f….broker() (0xabff0110), else revert
- cast call broker() @26438999 = 0x1d78064b… (no code); proxy ERC1967 impl 0x59dea8bb…; upgradeTo is gated to the constant admin 0xa5c8c8b5…
- balance 0 ETH; ecrecover forwards all gas

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade the config proxy implementation so broker() returns a new key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-signer-upgrade-only` applies, not `eip-8151-signature-rechecked`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
- 2026-11-20: the same contract was also a row of triage entry `eip-8151-fixed-signer`; its reading as a fixed signer was wrong: the signer is broker() of an upgradeable config proxy, so it is filed here (D-025).
