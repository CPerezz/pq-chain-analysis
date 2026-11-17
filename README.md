# pq-chain-analysis

What the move to post-quantum cryptography breaks, exposes or leaves unprotected on Ethereum mainnet: one list of
findings, and the studies that produced them.

- **Findings:** [by severity](generated/INDEX.md) · [by class and pattern](generated/PATTERNS.md) · [by study](generated/STUDIES.md)
- **Check an address:** <https://kevaundray.github.io/pq-chain-analysis/>
- **Report:** [REPORT.md](REPORT.md), the census of pre-quantum cryptography in mainnet contracts (November 2026)

## How it is organised

There are two collections. A **study** says how something was investigated. A **finding** says what was found. They
are kept apart because several studies can find the same issue, and one study finds many.

| Path | What it holds |
|---|---|
| [`studies/<id>/`](studies/) | One folder per study: goal, setup, procedure, how to reproduce, results, limits. See [`studies/README.md`](studies/README.md) |
| [`findings/<id>.md`](findings/) | One self-contained file per issue, for all studies. Each names the studies that found it. See [`findings/README.md`](findings/README.md) |
| [`patterns.md`](patterns.md) | The classes and patterns findings are grouped by |
| [`outreach/<project>.md`](outreach/) | Where contact with each affected team stands |
| [`generated/`](generated/) | The lists and CSV files, built from the four above |
| [`templates/`](templates/) | A blank form and a filled example for each kind of record |
| `tools/` | `build.py` checks the records and builds `generated/`; `site_data.py` builds the site's data |
| `docs/` | The site |

No study code lives here. A study links its code, at a full commit hash, in its header. A finding has no files beside
it: the code it relies on is quoted in it, and state is given as a contract, a block and, where there is one, a
transaction, which anyone can read again from the chain.

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

1. Search [`generated/contracts.csv`](generated/contracts.csv) for the address. If the issue is already listed, add
   your entry to that finding's `sources` instead of creating a file. It then shows as found by both studies.
2. Otherwise copy [`templates/finding.md`](templates/finding.md) to `findings/<id>.md`. A candidate needs a title, a
   pattern, where it is, an explanation, and who reports it from which study.
3. If no pattern in [`patterns.md`](patterns.md) fits, add one there in the same pull request.

A contract can be in any number of findings. The same contract under the same pattern twice is a duplicate.

## Checking your change

```
uv run tools/build.py             # check everything, then rebuild generated/ to preview
uv run tools/build.py --selftest  # also prove the rules reject what they should
```

Do not include `generated/` in a pull request. It is rebuilt after every merge to `main`.

## Licence

[CC0 1.0](LICENSE).
