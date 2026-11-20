---
id: wrappedtokenstakedeth-ac78ebe8-signer-upgrade-only
title: "WrappedTokenStakedETH: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xac78ebe8b1770f1a5a0d9eaad88a33150b05846b"
  family: "69c13af3a68d8433ac982b75f9693b50"
  name: "WrappedTokenStakedETH"
  upgradeable: "yes"
  admin: "owner() 0x0E4E519691021d930072Ff13c503a50626e31a8e (UUPS)"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
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
  note: "The signer is owner(), which a live setter (transferOwnership) can replace; the dossier's own bucket was 'fixed by rotation'. The solmate permit path is the holder's own signature and approve() stays open."
---

## Summary

Hashnote wrapped stETH token implementation. Withdrawals must be signed by owner(), which OwnableUpgradeable can transfer, and the live proxy 0x0c9b6b2b is also upgradeable by that live owner.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- DepositWithdrawToken.sol:148-172 _assertWithdrawSignature: recovered == owner()
- PermissionedToken.sol:15,63 OwnableUpgradeable + _authorizeUpgrade -> _checkOwner
- proxy 0x0c9b6b2b9345841f6210f6045ee2508d68ee1ac6 impl = 0xac78ebe8, owner() 0x0E4E5196 (EOA n=123) @26438999 (proxyprobe)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner transfers ownership to a fresh key, or upgrades, before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
