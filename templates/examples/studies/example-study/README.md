---
id: example-study
title: "Example study: which contracts forward a fixed amount of gas to a precompile"
authors: [example-author]
status: published
started: 2026-11-01
published: 2026-11-10
topic: eip-0000
code:
  - https://github.com/example/example-study-code/tree/0123456789abcdef0123456789abcdef01234567
spec:
  repo: example/specs
  path: specs/eip-0000.md
  commit: 0123456789abcdef0123456789abcdef01234567
---

## Goal

One or two sentences: the question the study answers and why it matters.

## Setup

What it ran on: the data (with where it lives and the block range), the node or service, the block at which state was
read, the versions of the tools. For a study of a protocol change, the change in plain words.

## Procedure

What was done, step by step, with the script for each step. Someone who reads only this section should know how the
candidates were found and how each was checked.

## Reproduce

The commands, in order, at the commit linked in the header. Say what they need (an archive node, a dataset) and how
long they take.

## Results

What was found, with numbers, and links to the findings (they are listed under this study in `generated/STUDIES.md`).
Small result tables go in `results/` next to this file. A study that found nothing says so here.

## Limits

What the method cannot see, what was not covered, and what could make a number wrong.
