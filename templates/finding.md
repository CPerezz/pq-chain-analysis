---
# Format 2. Start a finding with `uv run tools/new_finding.py`, which fills the facts; read AGENTS.md first.
# Readers see everything above `## Reviewer notes` except the fields marked "not shown". Leave a field empty when
# it is not established; never guess. Field rules: findings/README.md.
id: name-12345678-issue            # = file name: <contract name>-<first 8 hex of the address>-<issue>
format: 2
title:                             # 20-80 characters, plain words: what is wrong, for whom. No amounts, ids or codes
status: candidate                  # candidate | confirmed | reproduced | duplicate
severity:                          # CRITICAL | HIGH | MEDIUM | LOW | INFORMATIONAL (migration notices only)
justification:                     # up to 120 characters: why it is an issue, and why at this level
category:                          # the pattern's: quantum-exposure | breaks-at-activation | voided-by-migration | migration-notice
pattern: PQ-0                      # one id from patterns.md
study: study-id                    # the study that flagged it: a folder in studies/
as_of: 2026-11-18                  # the date of `block`
block: 0                           # every state read in this file is at this block
contract:
  address: "0x0000000000000000000000000000000000000000"
  name:                            # from verified source or the chain
  project:                         # slug; only from verified source, the chain or the team
  label:                           # the explorer's public tag: a lead, never a name
  code:                            # verified | decompiled | bytecode
  code_url:                        # verified or bytecode: the Etherscan or Sourcify page; decompiled: code/<code hash>.sol
  proxy_of:                        # the implementation, when this address is a proxy
  copies: 1                        # addresses running the same code
  family:                          # the code family, when copies is above 1
  upgradeable:                     # yes | no | config-only
  admin:                           # not shown: the address that can upgrade or reconfigure, or none
value:
  usd:                             # what the address (and its copies) holds
  whose:                           # users | operator | mixed
  basis:                           # held | market-cap | escrow
activity:
  txs_90d:                         # transactions that called it, any function, in the 90 days to `block`
  last:                            # not shown: the date of the last one
impact:                            # funds-loss | funds-locked | liveness: what happens if nobody acts
action:                            # up to 140 characters, for the contract's team, starting with a verb; empty if not sure
evidence_level:                    # source | bytecode | onchain | trace | executed
sources:
- study: study-id
  who:                             # person or agent
  date: 2026-11-18
  by: ai-assisted                  # ai-assisted | project-team | other
  verdict: reported                # reported | confirmed | refuted
reviews: []                        # added by reviewers: who, date, by, verdict (confirmed | refuted), note
related: []                        # other findings on the same contract
---

## What happens

Up to 300 characters about this contract: what it does, where it trusts the signature, what goes wrong.

## Evidence

- One fact that shows the problem, with its [link](https://etherscan.io/address/0x0000000000000000000000000000000000000000#code).
  At most three bullets, every one with a link.

## Reviewer notes

### Mechanism

The path through the code, for this contract. Never shown.

### Checks

- What was read, how, and what it gave; what was ruled out.

### History

- 2026-11-18: filed from study study-id.
