---
id: 5b63c639-signer-upgrade-only
title: "0x5b63c639: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5b63c639401787a07c2b0ac6d0d4c31c169cbb8b"
  family: "e6df0ad1cbb07f56097fcbdd804df928"
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
  note: "LOW: the signer can be replaced through a live proxy upgrade. The real issue is signer-upgrade-only; re-signing of old signatures is not involved."
---

## Summary

Not a BitFi Vault. This is the ClashOfNFT Passcard ERC721 (same code as 0xf122ad6d apart from 63 bytes). The signature mint 0xa7e91072(uint8,address,bytes) checks ecrecover(keccak(...)) against broker(), read at call time from the config proxy 0x32a5d69f… (ERC1967 proxy to impl 0x59dea8bb…). Today broker() is 0x1d78064b…, which has no code. If the broker account gets non-7702 code, signed mints stop until the proxy is upgraded so broker() returns a new key. No signature from a user is relied on later.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can…. Same code idiom as template ec3bbcc8, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- disassembly pc 0x1cd8–0x1d7b: the recovered address is compared (EQ, else revert) to STATICCALL 0x32a5d69f….broker() (selector 0xabff0110)
- cast call broker() @26438999 = 0x1d78064b9bb8986ddad3b537a5c5621645611177 (code empty, nonce 0); proxy impl slot = 0x59dea8bb448b5167fb1cc6380a40a088588aa6c1, upgrade path hardcoded to admin 0xa5c8c8b5…
- NFT ETH balance 0; ecrecover forwards all gas

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade the config proxy implementation so broker() returns a new key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-signer-upgrade-only` applies, not `eip-8151-signature-rechecked`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
- 2026-11-20: the same contract was also a row of triage entry `eip-8151-fixed-signer`; its reading as a fixed signer was wrong: the signer is broker() of an upgradeable config proxy, so it is filed here (D-025).
