# generated/

Built by `tools/build.py` from the headers of `findings/*.md`, `triage/*.md`, `studies/*/README.md` and `outreach/*.md`. Do not edit
by hand and do not include these files in a pull request: CI rebuilds them after every merge to `main`. To preview
locally, run `uv run tools/build.py`.

| File | Contents |
|---|---|
| `INDEX.md` | Every finding by severity, with pattern, trigger, impact, alternative, upgradeability, fix, protocol change, exposure, 30-day activity, level, the studies that found it and outreach status |
| `PATTERNS.md` | The same findings by class and pattern |
| `STUDIES.md` | The same findings by study |
| `findings.csv` | One row per finding: the columns above, plus who acts, the evidence level, the class, the studies and how many they are |
| `contracts.csv` | One row per affected contract: its finding, severity, implementation, admin, value with basis and date, last activity, 30-day transactions, project and outreach status. Search it for an address before adding a finding |
| `studies.csv` | One row per study: authors, status, topic, code link, spec commit, and its findings by level |
| `TRIAGE.md` | Entries of `triage/` not yet reviewed, by proposed rating, exposure and recoveries, then those discarded, with who and why |
| `triage.csv` | One row per triage entry, for sorting and filtering |
| `triage_contracts.csv` | One row per contract row of the triage pool: entry, rating, family, copies, name, public tag, value, recoveries, note. Search it for an address |
| `PROJECTS.md` | One row per project (the team that has to act), for outreach: its reviewed findings and its entries in triage, worst rating and exposure; then rows with no project, by public tag (unverified) |
| `projects.csv` | The projects table, for sorting and filtering |

Column meanings:

- **Level**: `candidate`, `confirmed` or `reproduced`; see `findings/README.md`.
- **Found by**: the studies named in the finding's `sources`, leaving out a source that refuted it. A finding found
  by two or more studies is marked.
- **Outreach**: the status in `outreach/<project>.md`; `not-contacted` when there is no such file.

- **Exposure**: the finding's measured value at risk. `held` = ETH and tokens the affected contracts hold (or, with
  basis `escrow`, what a forged message or proof could release elsewhere); `market cap` = circulating supply of a
  token whose permit is affected, an upper bound. Blank = not measured.
- **30-day txs / last active**: transactions that called the contract (directly or in any call frame, any function)
  in the 30-day window, and the date of the latest one; from Xatu, 2026-10-16 to 2026-11-16. This is
  how much the contract is used, not how often its pre-quantum check runs: Xatu call frames do not include precompile
  calls. The yearly pre-quantum figures are in `REPORT.md`. No USD figure is given for the window: summing transfers
  over every transaction touching a token or lending pool counts the same money many times.
