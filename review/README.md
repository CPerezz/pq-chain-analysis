# review/: the open rows of the EIP-8151 study, and how to finish them

Every row is one contract under one root issue that the EIP-8151 study filed in bulk, by rules,
before anyone read the contract. Each row ends as a reviewed format-2 card in `findings/`, a removal, or a question
for the owner. Rows already settled are in `findings/` (format 2) and are not in this queue.

## State at the hand-over (2026-11-22)

9,482 rows are open, every one `todo`, ordered CRITICAL first. By issue and by the rating the old registry gave them
(untrusted: reviewers have re-rated many, mostly down):

| Issue | CRITICAL | HIGH | MEDIUM | LOW | other | Total |
|---|---|---|---|---|---|---|
| `signature-rechecked` | 33 |  | 2 | 1 |  | 36 |
| `fixed-gas-recovery` | 3 | 23 | 95 | 3 |  | 124 |
| `fixed-signer` | 1 | 61 | 183 | 63 | 2 | 310 |
| `wallets-fixed-signers` |  | 109 | 6 | 4 |  | 119 |
| `signer-upgrade-only` |  | 51 | 9 | 133 |  | 193 |
| `own-signature-only-exit` |  | 10 | 7 | 3 |  | 20 |
| `rotate-signer-before-migrating` |  | 4 | 9 | 3,884 | 2 | 3,899 |
| `custody-wallets-fixed-signers` |  | 4 |  |  |  | 4 |
| `wallet-owner-keys` |  | 3 |  |  |  | 3 |
| `signed-shortcut-lost` |  |  | 20 | 3,949 |  | 3,969 |
| `sender-gas-limits` |  |  | 5 | 365 | 1 | 371 |
| `7702-own-key-only` |  |  |  | 340 |  | 340 |
| `entry-by-own-signature-only` |  |  |  | 92 |  | 92 |
| `signed-4337-gas-limits` |  |  |  | 2 |  | 2 |
| Total | 37 | 265 | 336 | 8,839 | 5 | 9,482 |

What the review has learned about these rows:

- **Settled before the hand-over:** about 33,000 rows. 5,958 findings are format-2 cards: about 400 written by an
  author agent, checked by a refuter agent and settled by a reader; the rest written by script for notices whose
  shape reviewed cards fixed (token permit and signed delegation, a stored signer that a function replaces, a signer
  fixed at deployment). Each scripted card says in its Reviewer notes that no agent read the contract. The rest were
  dropped as unused (nothing held, nothing called) or removed as not affected. The first study's 457 open rows were
  filed as cards on the owner's word that its findings hold (outcome `trusted`): each restates the study's finding for
  one contract, with checks re-run at the block, and no refuter read it.
- **The scripts already read every open `rotate-signer-before-migrating`, `fixed-signer`, `signer-upgrade-only` and
  `signed-shortcut-lost` row and could not write it**: no verified source, a comparison a pattern cannot follow, an
  ERC-1271 path, several kinds of signer, a signer nobody can replace, 1,000 USD or more held with the signed path
  off. These rows need a reader's judgment, not another script.
- **Re-ratings so far go mostly down:** of the fixed-signer and wallet rows the old registry rated HIGH, every one
  reviewed became INFORMATIONAL (a key holder must move its account to code before anything breaks). Rated issues
  (`signature-rechecked`, `fixed-gas-recovery`) keep real CRITICAL and HIGH cards: a gas amount
  fixed in code with no update path is CRITICAL whatever the contract holds.
- **Leads are leads.** The study's scanner, its family tables and its rules have been wrong in both directions; the
  dossier's `scan` and `use` blocks say where to look, never what is true.

## What you need

- `uv` (Python 3.12), `cast` (Foundry) for the agents' reads, and internet access (Sourcify and Blockscout serve the
  verified sources).
- **An Ethereum mainnet archive node.** Every read is at block 26,438,999 (2026-11-18). A full node cannot answer
  state that old. Methods used: `eth_call`, `eth_getCode`, `eth_getStorageAt`, `eth_getBalance`,
  `eth_getTransactionCount`, `eth_getTransactionByHash`, `eth_getTransactionReceipt`, `eth_getBlockByNumber`, and
  `eth_getLogs` (one address, a narrow block range). No traces.
- Your harness's sub-agents: one for each author and each refuter, each with a fresh context.

## Setup (once)

```
python3 review/gateway.py --upstream https://YOUR-ARCHIVE-NODE &       # every read goes through it (port 8546)
export R="uv run --quiet --with pyyaml --with eth-abi --with pycryptodome python -m"
ETH_RPC_URL=http://127.0.0.1:8546/reader-1 uv run tools/new_finding.py --selftest     # known answers: must pass
$R review.rows status                                                  # first run builds review/work/state.db
```

The gateway passes one request at a time to the node, refuses `latest`, traces and wide log scans, and caches every
answer (a read at a past block never changes). Every tool and agent talks to `http://127.0.0.1:8546/<its name>` and to
no other node address; the name is for the gateway's log (`review/work/gateway/log/`). Name yourself `reader-…`:
only that name may read one event topic over up to 10,000 blocks, which is how you answer an author's question
about logs.

## Roles

- **Reader** (you, the session that runs this file): claims rows, starts the agents, reads every sheet, settles,
  files, commits. You never write a card from scratch; you correct one when a refuter shows it wrong.
- **Author**: one sub-agent per row. Brief below; instructions in `AUTHOR.md`. Ends when `review.submit` prints
  `ACCEPTED`.
- **Refuter**: a fresh sub-agent per row, after the author. Brief below; instructions in `REFUTER.md`. It never sees
  the author's reasoning. Ends when `review.refute` prints `ACCEPTED`.

## The loop

```
$R review.rows take --who reader-1 --n 5          # CRITICAL first, then HIGH, MEDIUM, LOW, then the rest
$R review.dossier 'KEY'                           # unpack the row's dossier and fetch its sources (prints the folder)
```

For each row you hold:

1. **Author**: start one sub-agent with the AUTHOR brief. It writes `review/work/out/<address>-<issue>/draft.json`
   and stops at `ACCEPTED`. If it stops with questions only you can answer (event logs, a decision), answer them in
   `feedback.md` in the row's folder with a check it can cite, and start a fresh author.
2. **Refuter**: start one sub-agent with the REFUTER brief. It writes `refute.json` and stops at `ACCEPTED`.
3. **A removal** (`not-affected`) whose refuter agrees gets a second refuter: move the first answer aside, then start a
   fresh refuter on the same row:
   ```
   mkdir -p review/work/refute1/DIR && mv review/work/out/DIR/refute.json review/work/out/DIR/refute_results.json review/work/refute1/DIR/
   ```
   Cards get one refuter; only removals get two (two refuters who answered the same card disagreed only on removals).
4. **Read the sheet** (`$R review.sheet show 'KEY'`) and check what the two disagree on against the code and the chain
   yourself. Then settle:
   ```
   $R review.sheet settle 'KEY' --as kept|re-rated|moved|removed|question|covered --who reader-1 --note "..."
   ```
   - The note is one paragraph: what the contract does, the rating and pattern with the reason, the fix, and every
     correction you made, so that the next reader can tell your words from the author's.
   - **A refuter objects, or an agent fails: you settle it.** Keep the refuter's answer
     (`mv refute.json refute-before-edit.json` in the row's folder), correct `draft.json` yourself, run
     `$R review.submit 'KEY' --who reader-1` until `ACCEPTED`, and settle with `--note` saying how each objection was
     resolved. Never start a second agent for the same objection: it costs a full round and the evidence shows the
     reader resolves these.
   - `question`: you cannot settle it with a check. It stays open for the owner and is never filed.
   - `covered`: another row of the same address carries the card (`--by KEY`).
   - `redo`: only when the draft is beyond correcting; the next author reads `feedback.md`.
5. **Copies in use.** When an author shows this address is not in use but other addresses running its code are, add
   each such address as a row (`$R review.rows add 'ISSUE|0xADDRESS' --from 'KEY' --note "..."`) and settle this one
   `removed`. Add a row the same way for a second issue an author finds on an address.

Run at most as many agents at once as your budget allows (the previous reader ran five). One row per agent; agents
never start agents and never open another row's folder.

## Filing and committing

After every batch of settled rows (any size):

```
$R review.file --who reader-1                     # writes findings/, removes the old entries, saves the queue's state
uv run tools/build.py
git add -A findings triage code review/queue.tsv review/ledger.tsv review/held review/added.jsonl review/signoff.txt
git commit -m "review: N rows settled (kept K, re-rated R, moved M, removed X)"
```

- **CRITICAL and HIGH cards wait for the owner's sign-off.** The filer holds them until their key is a line of
  `review/signoff.txt`. List them for the owner with their sheets; the owner adds the keys.
- Commit `queue.tsv`, `ledger.tsv` and `held/` with every filing: they are the queue's state (`held/` keeps the
  work of rows settled but not filed yet, such as a card waiting for sign-off), and a fresh clone continues from them.
  Run `$R review.rows save` before any other commit. Never commit `review/work/` (it is ignored): it holds the
  database, the dossiers in use, the agents' folders and the caches.
- `review.sheet reopen 'KEY'` takes back a row settled in this review whose filed card turns out wrong. A card filed
  before the hand-over that you believe wrong: do not edit it; list it for the owner.

## Rules that are not in the briefs

- **Severity** follows `AGENTS.md`. A key holder that must move its own account to code before anything
  breaks is a migration notice (INFORMATIONAL), whatever it would lock; value and activity never change a rating.
- **Unused does not matter, value does.** An address that held nothing at the block (ETH and the priced tokens) and
  that nothing called in the 90 days before it has no finding. When a row stands for one address and its dossier
  shows both (`facts.value_usd` 0, `use.calls_in_90_days.transactions` 0), settle it without an agent:
  `$R review.sheet settle 'KEY' --as unused --who reader-1`. Not for first-study rows (`first/…`: their money often
  sits in another contract, as with a proof verifier) nor for `fixed-gas-recovery` and `signature-rechecked` rows,
  which are rated whatever they hold. Anything that holds value gets a full review.
- **Faults usable today** (anyone could take funds now, a signature that replays across wallets) are not this
  review's output. Write nothing about how they work in any file, card, commit or message of this repository; tell
  the owner privately and name the row only.
- **Facts come from the tools.** An agent never types an address, an owner or an amount it did not read through the
  gateway; `review.submit` re-runs every check and refuses what does not hold.

## Briefs

Replace ISSUE, 0xADDRESS and ADDR8 (the address's first 8 hex digits). DIR is `0xADDRESS-ISSUE`, with a `/` in the
issue written as `_` (`first/safe-owner-ecdsa-keys` gives `0xADDRESS-first_safe-owner-ecdsa-keys`).

### AUTHOR

```
# Goal
Review ONE contract of this registry: find out what is true for it, back every sentence with a check that can be re-run, and never guess. Earlier findings were filed in bulk and many are wrong; a wrong card is worse than no card.

# Contract
- Read `review/AUTHOR.md` and follow it exactly, start to end. It names every file you need. Work from the registry's root.
- Node reads only through the gateway: `export ETH_RPC_URL=http://127.0.0.1:8546/a-ADDR8`, and every read names the block: `--block 26438999`. No other node address, no traces, no wide log scans.
- One row only. Start no other agents. Write only inside `review/work/out/DIR/`. Do not edit the registry, the dossier or any tool. Do not open any other row's folder.
- When you are not sure of a fact or a judgment: do not guess; say so the way `review/AUTHOR.md` tells you to.
- Stop the moment the acceptance command prints `ACCEPTED`. Final message: at most 6 lines.

# Target
Row KEY = `ISSUE|0xADDRESS`. Your name: `a-ADDR8`. Role: AUTHOR.
Dossier: `review/work/dossier/DIR/`. Your draft: `review/work/out/DIR/draft.json`.

# Acceptance
`uv run --quiet --with pyyaml --with eth-abi --with pycryptodome python -m review.submit 'ISSUE|0xADDRESS' --who a-ADDR8` prints `ACCEPTED`. Your last message: that line, your verdict in one sentence, and at most three points the reader must look at.
```

### REFUTER (a second refuter of a removal is `r-ADDR8-2`)

```
# Goal
Try to prove ONE card of this registry wrong. Earlier findings were filed in bulk and many are wrong; a wrong card that you let through is the failure.

# Contract
- Read `review/REFUTER.md` and follow it exactly, start to end. Work from the registry's root.
- Node reads only through the gateway: `export ETH_RPC_URL=http://127.0.0.1:8546/r-ADDR8`, and every read names the block: `--block 26438999`. No other node address, no traces, no wide log scans.
- One row only. Start no other agents. Write only `review/work/out/DIR/refute.json`. From that folder read only `refuter_input.md`. Do not open any other row's folder.
- Never guess: an attempt you could not make is `could-not-check`.
- Stop the moment the acceptance command prints `ACCEPTED`. Final message: at most 6 lines.

# Target
Row KEY = `ISSUE|0xADDRESS`. Your name: `r-ADDR8`. Role: REFUTER.
What you refute: `review/work/out/DIR/refuter_input.md`. Dossier: `review/work/dossier/DIR/`. Your answer: `review/work/out/DIR/refute.json`.

# Acceptance
`uv run --quiet --with pyyaml --with eth-abi --with pycryptodome python -m review.refute 'ISSUE|0xADDRESS' --who r-ADDR8` prints `ACCEPTED`. Your last message: that line, your verdict, and each objection in one line.
```

## Files

| Path | What | Committed |
|---|---|---|
| `AUTHOR.md`, `REFUTER.md` | The two agents' instructions | yes |
| `data/rows.jsonl.gz` | The open rows at the hand-over: each row's old claim (untrusted), old rating, value, family | yes |
| `data/dossiers.jsonl.gz`, `data/decompiled.jsonl.gz` | Their dossiers, built from the study's tables at block 26,438,999, and decompiled code by code hash | yes |
| `added.jsonl` | Rows added in review | yes |
| `queue.tsv`, `ledger.tsv`, `held/` | The state of every row that left `todo`, every step taken, and the work of rows settled but not filed yet (written by `review.file` and `review.rows save`) | yes |
| `signoff.txt` | CRITICAL and HIGH rows the owner signed off, one key per line | yes |
| `work/` | `state.db`, `dossier/`, `out/` (each row's draft, card, refutation, results), `refute1/`, `sources/`, `gateway/` | no |
| `*.py` | `rows` (the queue), `dossier`, `submit` (author), `refute` (refuter), `sheet` (reader), `file` (filer), `gateway` | yes |

A row's states: `todo`, `taken`, `authored` (the author's draft is accepted), `refuted`, `settled`. The outcomes of
a settled row: `kept`, `re-rated`, `moved`, `removed`, `covered`, `unused`, `trusted` (a first-study row the owner
took as valid, without a refuter), `question`.
