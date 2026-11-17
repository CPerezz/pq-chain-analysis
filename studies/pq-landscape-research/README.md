---
id: pq-landscape-research
title: "Post-quantum verifiers, account plans and replacement options on Ethereum, as of 2026-11-03"
authors: [kevaundray]
status: published
started: null
published: 2026-11-04
topic: pre-quantum-exposure
code: none
---

## Goal

Collect what is known outside this repo: which post-quantum signature verifiers exist and where they are deployed,
where Ethereum's post-quantum account plans stand, what could replace each pre-quantum primitive and at what gas cost,
and which contract designs stay vulnerable after accounts migrate.

## Setup

- Web sources, each linked where it is used.
- Mainnet reads through a public RPC (`ethereum-rpc.publicnode.com`, block ≈26,336,574) and Sepolia reads through
  `ethereum-sepolia-rpc.publicnode.com`.
- Anything inferred is tagged **[INFERENCE]** in the notes; anything not confirmed is tagged **[UNVERIFIED]**.

## Procedure

Desk research. Every verifier, factory and account address named by a project was checked on mainnet with
`eth_getCode`. Bytecode fingerprints (moduli, NTT tables) were taken from the Sepolia runtime code of the ZKNox and
Kohaku verifiers and checked against their source.

## Reproduce

There is no code. Follow the links in [notes.md](notes.md) and repeat the `eth_getCode` checks on the addresses it
lists.

## Results

[notes.md](notes.md), in four parts: post-quantum verifiers on mainnet and testnets with their fingerprints;
the status of post-quantum account plans (EIP-8141, EIP-8151, EIP-8298 and others); replacement options by use case
with gas costs; and eight vulnerable design patterns. Several of them reappear in [`patterns.md`](../../patterns.md):
ECDSA tried before ERC-1271, ECDSA-only permits, `ecrecover` used for curve arithmetic, committee keys.

## Limits

- Statements about the fork schedule come from secondary sources and were not checked independently.
- The notes found no lattice verifier on mainnet. The [bytecode-fingerprint-scan](../bytecode-fingerprint-scan/),
  done afterwards, found six. The notes were not updated.
- It is a snapshot of 2026-11-03. EIP texts have changed since.
