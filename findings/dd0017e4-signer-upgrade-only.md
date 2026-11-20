---
id: dd0017e4-signer-upgrade-only
title: "0xdd0017e4 (tagged deployed by moneycanbuy.fun: Deployer): signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdd0017e40f1a5fe514d15d108ce01eb52f2a5edb"
  family: "f1bf24b34f76fa29b85525d88f945aaf"
  label: "deployed by moneycanbuy.fun: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
  last_active: 2026-10-21
fix:
  layer: new-deployment
  who_acts: "moneycanbuy.fun / IdentityMD operator (redeploy the registry)"
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
  verdict: confirmed
  rating: MEDIUM
  note: "There is no update path, but nothing is locked: users pay a per-request oracle fee and get no trait (the function dies). A trait oracle feed holds no money by design → MEDIUM. The real root issue is a fixed signer, not upgrade-only."
---

## Summary

Sworn Registry (moneycanbuy.fun): oracle trait attestations are accepted only from attester 0x5598aa91…, set in the constructor with no setter, and the contract has no owner and no upgrade. 'upgrade(uint16[],uint256)' buys trait checks; it is not a code upgrade.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgrade). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: upgrade(uint16[],uint256), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Verified source (sourcify, src/Registry.sol): '@dev No owner, pause, upgrade'; _check() does ECDSA.tryRecover(attestationDigest(a)) and requires signer == attester; attester is written only in the constructor
- attester() = 0x5598Aa9146215Bc13eb26f2c692Ad1461Fd32982 at block 26438999 on all three copies; cast code 0x, nonce 0 (offchain EOA signer)
- upgrade() pulls the user's IMD and pays the Intake for an oracle request; a failed signature check in onResult only emits Missed and clears the request: the fee is spent, the trait is not granted, nothing stays in escrow
- 0x9cb36ecc has no sourcify match; it shares the upgrade/abandon/mintCard selectors and attester() returns the same key. Activity: txs_90d=3

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-21.

## Remediation

Before the attester key takes code, deploy a new Registry with a new attester (or with ERC-1271 support) and move minting there; the existing cards keep their stored traits.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
