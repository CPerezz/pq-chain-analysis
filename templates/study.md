---
# Copy to studies/<id>/README.md. Field reference: studies/README.md. Then run: uv run tools/build.py
id: short-study-name                    # = folder name; lowercase letters, digits, '-'
title: "One line: the question this study answers"
authors: [github-login]
status: planned                         # planned | running | published
started: 2026-11-17
published: null
topic: eip-0000                         # a slug; `eip-<number>` for a study of an EIP
code: none                              # `none`, or a list of links, each with a full commit hash or gist revision:
# code:
#   - https://github.com/<owner>/<repo>/tree/<full commit hash>
spec:                                   # required when the topic is an EIP; delete otherwise
  repo: ethereum/EIPs
  path: EIPS/eip-0000.md
  commit: "0000000000000000000000000000000000000000"
---

## Goal

The question, and why it matters.

## Setup

Data (where it lives, block range), node or service, the block at which state was read, tool versions. For a protocol
change: the change in plain words.

## Procedure

What was done, step by step, with the script for each step.

## Reproduce

The commands, in order, at the commit linked in the header; what they need and how long they take.

## Results

What was found, with numbers. Small tables go in `results/`.

## Limits

What the method cannot see, what was not covered, what could make a number wrong.
