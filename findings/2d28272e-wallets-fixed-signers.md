---
id: 2d28272e-wallets-fixed-signers
title: "0x2d28272e (tagged deployed by Soulink: Deployer): wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x2d28272ebfb04f21a675e9955df09507c6b28b25"
  family: "e409c900bfef624082c9f0394c72ff9f"
  label: "deployed by Soulink: Deployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "the signers (quorum-signed addSigner/removeSigner/updateQuorum)"
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
  verdict: refuted
  rating: NONE
  note: "Merger change (RevWal046): the worker rated this HIGH because addSigner/removeSigner need the same quorum signature. Rows 0xa5ba9d68, 0x3cd540c2 and 0xc7434fec, whose owners can be replaced through a signed setOwners call, were refuted with rotate-signer-before-migrating, so this row is aligned with them: a signed setter that can replace the key counts as a setter. a setter exists in form (addSigner/removeSigner) but is not a usable update path since invoking it needs the very signature check EIP-8151 breaks -- does not qualify for LOW"
---

## Summary

Soulink custom quorum-multisig (row label: 'deployed by Soulink: Deployer') -- not literally SimpleMultiSig (different selectors: getSigners/isSigner/quorum/addSigner/removeSigner/updateQuorum plus ERC20/1155 transfer-out functions) but functions the same way: every fund-moving call (transfer/transferFrom/batchTransferFrom/safeBatchTransferFrom via selectors 0xbc78a768/0xe246cbae) and every signer-management call require an ecrecover-verified quorum of the 5 fixed signers. All 5 signers are still EOAs today.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher: getSigners()/isSigner/quorum()/addSigner(0xaf94411c)/removeSigner(0xa9ac06d9)/updateQuorum(0x3f63bafd)/0xbc78a768,0xe246cbae(transfer-type, both gated by an 'INSUFFICIENT_SIGNERS' check then ecrecover)
- getSigners() (scanner read, block 26438999) = 0x8b2a97bf13d44fb1a2b3eb5a14a69f75aff1eeb1,0x8033ceb86c71ebbf575ff7015fcb8f1689d90ac1,0xdb1671fb7bd1de1ba358b7130bf8e663d8c4ae11,0x97e699de72211383faedde1e00ce5555a1eb0564,0x04977f55aadf5b24a1d7c5a2bb5bc8988572d578
- eth_getCode on publicnode (latest, block ~26488250) for all 5 signers = 0x (EOA)
- decompile: addSigner/removeSigner/updateQuorum all branch through the same quorum-signature-count check + ecrecover path as the transfer functions -- no onlyOwner/direct-call path found for any of them

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before any signer key takes code, the quorum signs addSigner/removeSigner to rotate to keys that will stay EOAs (or a 7702-delegated account).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
