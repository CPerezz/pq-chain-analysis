# pq-chain-analysis

What the move to post-quantum cryptography breaks, exposes or leaves unprotected on Ethereum mainnet: one list of
findings, and the studies that produced them.

- **Findings:** [by severity](generated/INDEX.md) · [by class and pattern](generated/PATTERNS.md) · [by study](generated/STUDIES.md) · [not yet reviewed](generated/TRIAGE.md)
- **Check an address:** <https://kevaundray.github.io/pq-chain-analysis/>
- **Report:** [REPORT.md](REPORT.md), the census of pre-quantum cryptography in mainnet contracts (November 2026)

## How it is organised

There are two collections. A **study** says how something was investigated. A **finding** says what was found. They
are kept apart because several studies can find the same issue, and one study finds many.

| Path | What it holds |
|---|---|
| [`studies/<id>/`](studies/) | One folder per study: goal, setup, procedure, how to reproduce, results, limits. See [`studies/README.md`](studies/README.md) |
| [`triage/<id>.md`](triage/) | New entries, until someone other than the reporter has checked them. See [`triage/README.md`](triage/README.md) |
| [`findings/<id>.md`](findings/) | One self-contained file per issue, for all studies, once reviewed. Each names the studies that found it. See [`findings/README.md`](findings/README.md) |
| [`patterns.md`](patterns.md) | The patterns findings are grouped by, each with its category and a plain description |
| [`outreach/<project>.md`](outreach/) | Where contact with each affected team stands |
| [`generated/`](generated/) | The lists and CSV files, built from the four above |
| [`templates/`](templates/) | A blank form for each kind of record, and filled examples: one finding per category, one study |
| `tools/` | `build.py` checks the records and builds `generated/`; `find.py` looks an address up; `new_finding.py` starts a finding with its facts read from the chain; `site_data.py` builds the site's data |
| [`code/`](code/) | Decompiled code that findings link, for contracts without verified source |
| [`AGENTS.md`](AGENTS.md) | The rules agents follow when they file or review findings |
| `docs/` | The site |

No study code lives here. A study links its code, at a full commit hash, in its header. A finding links the contract's
code (verified on Etherscan or Sourcify, or decompiled in `code/`) and gives state as a contract, a block and, where
there is one, a transaction, which anyone can read again from the chain.

## Levels

Every finding has one level. It is a label, not a gate: file at any level, and move up when the next one is met.

| Level | Meaning |
|---|---|
| `candidate` | A written claim. Reading-only is fine |
| `confirmed` | The code is quoted and the state it depends on was read at a stated block |
| `reproduced` | It was executed, and the finding carries the command, the code at a commit, the inputs and the expected result |

## Adding a study

Copy [`templates/study.md`](templates/study.md) to `studies/<id>/README.md` and fill it. A study can be added as
`planned` before any work is done. Keep its code in a repository or gist of your own and link it at a commit.

## Adding a finding

1. Look the address up: `uv run tools/find.py 0xADDRESS`. If the issue is already filed, add your entry to its
   `sources` instead of creating a file. It then shows as found by both studies.
2. Otherwise start it with `uv run tools/new_finding.py` (see [`findings/README.md`](findings/README.md)): it writes
   `triage/<id>.md` with the facts read from the chain, and you write the judgment.
3. If no pattern in [`patterns.md`](patterns.md) fits, add one there in the same pull request.
4. Someone else reviews it and moves it to `findings/`: [`triage/README.md`](triage/README.md).

A finding is one contract and one issue. The part a reader sees is short by rule; the rest goes in its Reviewer notes.

A contract can be in any number of findings. The same contract under the same pattern twice is a duplicate.

## Checking your change

```
uv run tools/build.py             # check everything, then rebuild generated/ to preview
uv run tools/build.py --selftest  # also prove the rules reject what they should
```

Rebuild `generated/` (`uv run tools/build.py`) before a filing commit. Every push and pull request runs the check.

## Licence

[CC0 1.0](LICENSE).
