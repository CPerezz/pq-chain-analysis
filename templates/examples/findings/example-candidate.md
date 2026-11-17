---
id: example-candidate
title: "ExampleVault: one operator key signs every withdrawal voucher"
status: candidate
patterns: [PQ-4]
project: example-project
contracts:
- address: "0x4444444444444444444444444444444444444444"
  name: ExampleVault
sources:
- study: example-study
  who: example-author
  date: 2026-11-10
---

## Summary

`ExampleVault.withdraw` pays out on a voucher signed by a single stored key and checks it with `ecrecover`. I read the
verified source but did not read the contract's state, so I do not know whether the signer can be changed. That is
why this is a candidate: a written claim that somebody still has to check.
