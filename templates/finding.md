---
# Copy to triage/<id>.md; a reviewer moves it to findings/ (triage/README.md). Field reference, levels and severity
# rubric: findings/README.md. A candidate needs only the lines marked (all levels). Then run: uv run tools/build.py
id: project-mechanism                   # (all levels) = file name without .md; lowercase letters, digits, '-'
title: "One line: what breaks or what an attacker can do, for whom"   # (all levels)
status: candidate                       # (all levels) candidate | confirmed | reproduced | not-affected | duplicate
patterns: [PQ-4]                        # (all levels) ids from patterns.md; add a pattern there if none fits
project: project-slug                   # (all levels) the team that has to act; or put `project:` on every contract row
contracts:                              # (all levels) where it is: the address users call
  - address: "0x0000000000000000000000000000000000000000"
    implementation: null                # for a proxy: its current implementation
    name: ContractName
    upgradeable: unknown                # yes | no | config-only | unknown
    admin: null                         # who can upgrade or reconfigure, with address
    value_usd: null
    value_basis: null                   # held | market-cap | escrow
    value_as_of: null
    last_active: null
    txs_30d: null
families: []                            # many deployments of one code: code, name, instances, list, upgradeable, value_usd, value_basis, value_as_of
severity: UNRATED                       # CRITICAL | HIGH | MEDIUM | LOW | NONE | UNRATED
impact: unknown                         # funds-loss | funds-locked | liveness | none | unknown
fix:
  layer: unknown                        # contract-upgrade | onchain-config | new-deployment | account-migration | offchain | protocol | none | unknown
  who_acts: unknown
evidence:
  level: source-read                    # onchain-read | source-read | bytecode | trace | executed
  block: null                           # the block at which state was read; required from confirmed up
  raw: null                             # optional link to raw reads kept elsewhere, at a pinned commit
sources:                                # (all levels) one entry per study that found or checked it
  - study: study-id                     # (all levels) a folder in studies/
    who: ""                             # (all levels) person or agent
    date: 2026-11-17                    # (all levels)
    by: other                           # ai-assisted | project-team | other
    ref: ""                             # where in that study's material
    verdict: reported                   # reported | confirmed | refuted
    rating: ""                          # that source's own rating
related: []                             # other findings that are a different issue of the same pattern on the same contract
reviews: []                             # added by reviewers in triage/: who, date, by, verdict (confirmed | refuted), rating, note

# Only for patterns of class `exposure` (required from confirmed up):
# primitives: []                        # ecrecover | bn254 | kzg | bls12381 | p256 | sw_p256 | sw_secp256k1 | sw_bn254 | sw_ed25519 | sw_bls12381 | rsa
# trigger: unknown                      # user-key | operator-key | committee-keys | trusted-setup | owner-keys | issuer-key | none
# alternative: sole                     # sole | key-rotation-only | alternative-exists | configurable-verifier
# role: core                            # core | auxiliary
# and under fix:   protocol_change: not-needed   # required | helps | not-needed

# Only for status `reproduced`:
# repro:
#   code: https://github.com/<owner>/<repo>/tree/<full commit hash>
#   command: "the one command that repeats it"
#   inputs: {block: 0, tx: "0x..."}
#   expect: {before: {status: "0x1"}, after: {status: "0x0"}}
---

## Summary

What the issue is, where, and why it matters. One to three sentences. For a candidate this section is enough. Every
section stays as short as its evidence allows.

## Mechanism

The path through the code: which function checks what, and what follows. Name the pattern (PQ-n).

## Evidence

What was read and where, each statement marked CHECKED or INFERRED. Quote the code that decides it here, up to 150
lines; link anything longer. Give the block for every state read, and the transaction and inputs when there are any.
For `reproduced`: what the command printed.

## Impact and exposure

Value exposed with its basis and date; activity; every deployment and sibling checked.

## Remediation

The fix, who must act, whether it needs a protocol change, and what helps without the team.

## History

- 2026-11-17: reported by ... from study ...
