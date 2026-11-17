---
# Copy to findings/<id>.md. Field reference and severity rubric: findings/README.md. Then run tools/build.py.
id: project-mechanism                   # = file name without .md; lowercase letters, digits, '-'
title: "One line: what a quantum attacker can do, or what breaks for post-quantum users"
project: project-slug                   # the team that has to act
status: candidate                       # confirmed | candidate | not-affected | duplicate
severity: UNRATED                       # CRITICAL | HIGH | MEDIUM | LOW | NONE | UNRATED
patterns: []                            # IDs from patterns.md, e.g. [PQ-4]
primitives: []                          # ecrecover | bn254 | kzg | bls12381 | p256 | sw_p256 | sw_secp256k1 | sw_bn254 | sw_ed25519 | sw_bls12381 | rsa
trigger: unknown                        # user-key | operator-key | committee-keys | trusted-setup | owner-keys | issuer-key | none
impact: unknown                         # funds-loss | funds-locked | liveness | none | unknown
alternative: sole                       # sole | key-rotation-only | alternative-exists | configurable-verifier
role: core                              # core | auxiliary
contracts:                              # the address users call; for a proxy, add its implementation
  - address: "0x0000000000000000000000000000000000000000"
    implementation: null
    name: ContractName
    upgradeable: unknown                # yes | no | config-only | unknown
    admin: null                         # who can upgrade or reconfigure, with address
    value_usd: null
    value_basis: null                   # held | market-cap | escrow
    value_as_of: null
    last_active: null
    txs_30d: null
families: []                            # many deployments of one code: code, name, instances, list, upgradeable, value_usd, value_basis, value_as_of
fix:
  layer: unknown                        # contract-upgrade | onchain-config | new-deployment | account-migration | offchain | protocol | none | unknown
  who_acts: unknown
  protocol_change: not-needed           # required | helps | not-needed
evidence:
  level: source-read                    # onchain-read | source-read | bytecode | trace
  links: []                             # files under evidence/<id>/
sources:
  - by: ai-assisted                     # ai-assisted | project-team | other
    who: ""
    ref: ""
    date: 2026-11-17
    verdict: reported                   # reported | confirmed | refuted
    rating: ""
related: []
---

## Summary

What a quantum attacker can do through this contract, or what post-quantum users cannot do, and how much is exposed.
Two to five sentences.

## Mechanism

The path through the code: which function checks which signature or proof, against which key or setup, and what it
releases. Link the pattern (PQ-n) and the source excerpt.

## Evidence

What was read (verified source, bytecode, precompile trace) and what was read on-chain at which block. Mark every
statement CHECKED or INFERRED.

## Impact and exposure

Value exposed with its basis and date; activity (last active, 30-day transactions and value); every deployment and
sibling checked.

## Remediation

The post-quantum replacement, who must act (admin, governance, operator, owners), whether it needs a protocol change,
and what helps without the team.

## History

- 2026-11-17: created from ... (source).
