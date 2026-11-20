---
id: multisigcommitter-26fdb12d-rotate-signer-before-migrating
title: "MultisigCommitter: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x26fdb12dfc046c116a5077fdaa3fd6c9e9ded091"
  family: "1eb7dd57be89dc46e681b29de8379043"
  copies: 3
  name: "MultisigCommitter"
  upgradeable: "no"
  rating: NONE
  txs_90d: 4796
  last_active: 2026-11-18
  recoveries_14d: 111
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
  note: "A signer with code is accepted through ERC-1271. The study's revert replay used code without isValidSignature."
---

## Summary

ZKsync MultisigCommitter: commit batches need signatures from shared or per-chain validators. Each one is checked with OZ SignatureCheckerUpgradeable.isValidSignatureNow, which falls back to ERC-1271 when the signer has code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: ZKsync MultisigCommitter: signers must be validators of the chain or shared validators, each checked with SignatureChecker. Read from source. Executed: a real transaction reverts with code at the signer.
- MultisigCommitter.sol:256 checks with SignatureCheckerUpgradeable.isValidSignatureNow(signers[i], digest, signatures[i]) (ECDSA, then ERC-1271).
- This address is an implementation that was never initialized: owner()=0 at 26438999, slot0=0xff. The live proxy seen in txs.json context is 0x18cc381705761aa2d2e8ea62888a4029a0fad3ab (impl 0x434f65c3…, ProxyAdmin 0xff3582a0…, owner 0xE30Dca30… which is a contract).
- Validator sets can be rotated: addSharedValidator/removeSharedValidator are onlyOwner, and per-chain roles are set by the chain admin.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 4,796 transactions called it in the 90 days before that block; last on 2026-11-18.
- 111 signature recoveries in the study's two-week trace window.

## Remediation

None needed if the migrated validator's code implements ERC-1271; otherwise the owner or chain admin rotates the validator.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
