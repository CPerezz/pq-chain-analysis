---
id: entrypoint-00000000-bundle-signer-code
format: 2
title: Bundlers lose a whole bundle when one shared signer gets real code
status: confirmed
severity: HIGH
justification: Anyone can void many pending operations with one code change; the bundle reverts and the fix is new bundler software.
category: voided-by-migration
pattern: PQ-23
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: "0x0000000071727de22e5e9d8baf0edac6f37da032"
  name: "EntryPoint"
  project: eth-infinitism
  label:
  code: verified
  code_url: https://etherscan.io/address/0x0000000071727de22e5e9d8baf0edac6f37da032#code
  proxy_of:
  copies: 1
  family:
  upgradeable: "no"
  admin:
value:
  usd: 110972
  whose: users
  basis: held
activity:
  txs_90d:
  last:
impact: funds-loss
action: Track each recovered signer as a validation dependency in bundlers and ERC-7562, and cap pending operations per signer.
evidence_level: executed
checks:
- id: whole-bundle
  source: "0x0000000071727de22e5e9d8baf0edac6f37da032"
  file: contracts/core/EntryPoint.sol
  line: 584
  has: "AA34 signature error"
  says: "a failed signature check of any operation reverts the whole handleOps call"
  for: [what, evidence-1]
- id: bundle-today
  replay: "0x8843c889f07730b5c3b7e316645dcda63bf5bae71e1b5639a9f3f3cde02a46a7"
  run: today
  ok: true
  says: "the real bundle succeeds when replayed as it was"
  for: [evidence-2]
- id: bundle-signer-code
  replay: "0x8843c889f07730b5c3b7e316645dcda63bf5bae71e1b5639a9f3f3cde02a46a7"
  run: eip8151_signer_code
  ok: false
  says: "under EIP-8151 with code at the signer its operations recover, the whole bundle reverts"
  for: [what, evidence-2, justification]
- id: bundle-delegated
  replay: "0x8843c889f07730b5c3b7e316645dcda63bf5bae71e1b5639a9f3f3cde02a46a7"
  run: eip8151_signer_delegated
  ok: true
  says: "with a 7702 delegation at that signer instead, the bundle succeeds"
  for: [evidence-2, notes]
- id: bundle-target
  tx: "0x8843c889f07730b5c3b7e316645dcda63bf5bae71e1b5639a9f3f3cde02a46a7"
  to: "0x0000000071727de22e5e9d8baf0edac6f37da032"
  ok: true
  says: "the bundle was sent to this entry point and succeeded"
  for: [evidence-2]
- id: no-upgrade
  storage: "0x0000000071727de22e5e9d8baf0edac6f37da032"
  slot: "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc"
  is: 0
  says: "the EIP-1967 implementation slot is empty: the entry point is not a proxy"
  for: [upgradeable, action]
- id: op-062
  ref: "https://github.com/ethereum/ERCs/blob/63e961eda74ecb84dc224473452821eddbb451c2/ERCS/erc-7562.md?plain=1#L204-L206"
  says: "ERC-7562 allows precompiles in validation because they read no state"
  for: [what, evidence-3]
- id: executed
  ref: "https://github.com/CPerezz/pq-chain-analysis/blob/813db3ac5a6528abb0e1a8f26f92b2cd66390bd5/studies/eip-8151-impact/results/area-s/aa-bundle-replays.jsonl"
  says: "the study's fork engine replayed the bundle today, with code at the signer and with a delegation"
  for: [what, evidence-2, justification]
sources:
- study: eip-8151-impact
  who: "Claude (area S of the study: ERC-4337 validation frames from the traced window; real bundles replayed with code at a shared signer)"
  date: 2026-11-25
  by: ai-assisted
  verdict: reported
reviews:
- who: EntryPointRefuter, refuter (a fresh agent that tried to break the card)
  date: 2026-11-25
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "whole-bundle revert read in the deployed source; ERC-7562 rules (UREP-010, UREP-020, SREP-040, OP-062) do not bound a shared recovered signer"
- who: Claude, reader who settled the card
  date: 2026-11-25
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "the refuter asked for a backed operation count and a check for the ERC-7562 premise; both added"
related: []
---

## What happens

Bundlers simulate each operation before bundling it, trusting that `ecrecover` reads no state. Under EIP-8151 it reads the signer's code, so one transaction giving a shared signer real code voids every pending operation it signed, and this entry point reverts the whole bundle.

## Evidence

- Line 584 of the [verified source](https://sourcify.dev/server/repo-ui/1/0x0000000071727de22e5e9d8baf0edac6f37da032) reverts the whole bundle when one operation's signature check fails.
- A real bundle whose validations recover one paymaster's signer 5 times reverts when that signer has code, and passes with a delegation ([bundle](https://etherscan.io/tx/0x8843c889f07730b5c3b7e316645dcda63bf5bae71e1b5639a9f3f3cde02a46a7), [replay](https://github.com/CPerezz/pq-chain-analysis/blob/813db3ac5a6528abb0e1a8f26f92b2cd66390bd5/studies/eip-8151-impact/results/area-s/aa-bundle-replays.jsonl)).
- ERC-7562 lets validation call `0x01` because precompiles read no state ([rule OP-062](https://github.com/ethereum/ERCs/blob/63e961eda74ecb84dc224473452821eddbb451c2/ERCS/erc-7562.md?plain=1#L204-L206)).

## Reviewer notes

### Mechanism

`handleOps` validates every operation first, then executes. Validation calls the account and the paymaster, whose code recovers a signer; a failed check reverts the call with `FailedOp`, which ends the whole transaction. Bundlers avoid paying for that by simulating each operation and keeping only the ones that pass, and ERC-7562 bounds how many pending operations one state change can invalidate by limiting the storage validation reads. A precompile is treated as reading nothing. Under EIP-8151 the recovered address's code decides the answer, and no bundler tracks it: one transaction that gives a shared signer real code, landed after the last simulation, voids every pending operation that recovers it and makes any bundle carrying one of them revert. Anyone can set this up with their own key and many of their own accounts once keyed addresses can hold code (EIP-8298 or EIP-7851); a paymaster's operator or the owner of many accounts can do it with its own signer.

### Checks

- Replayed on the study's fork engine (execution-specs, only the precompile changed): bundle 0x8843c889f07730b5c3b7e316645dcda63bf5bae71e1b5639a9f3f3cde02a46a7 of block 26,438,000, sent to this entry point, its validations recovering 0x4337dd7891df2580890e4f6eab503465efeb6afe; 5 times (traced) with code at that signer it reverts after 214,362 gas; today and with a 7702 delegation it succeeds.
- Traced window (blocks 26,339,000 to 26,438,999): 153,474 distinct signers recovered in validation across the entry points; 60 paymasters recover one signer each.
- The fix is outside this contract: bundlers and ERC-7562 (track the recovered address, cap pending operations per signer), before the fork.

### History

- 2026-11-25: reported and executed (study eip-8151-impact, area S: ERC-4337 validation frames, real bundles replayed).
- 2026-11-25: reviewed by a refuter agent; operation counts tied to the replay record, the ERC-7562 premise given a check; settled.
