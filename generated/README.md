# generated/

Built by `tools/build.py` from the headers of `findings/*.md`; do not edit by hand.

| File | Contents |
|---|---|
| `INDEX.md` | Every finding by severity, with pattern, trigger, impact, alternative, upgradeability, fix, protocol change, exposure and 30-day activity; then counts by pattern |
| `findings.csv` | One row per finding (same columns, plus who acts and the evidence level) |
| `contracts.csv` | One row per affected contract: its finding, severity, implementation, admin, value with basis and date, last activity, 30-day transactions |

Column meanings:

- **Exposure**: the finding's measured value at risk. `held` = ETH and tokens the affected contracts hold (or, with
  basis `escrow`, what a forged message or proof could release elsewhere); `market cap` = circulating supply of a
  token whose permit is affected, an upper bound. Blank = not measured.
- **30-day txs / last active**: transactions that called the contract (directly or in any call frame, any function)
  in the 30-day window, and the date of the latest one; from Xatu, window in `evidence/<id>/activity.json`. This is
  how much the contract is used, not how often its pre-quantum check runs: Xatu call frames do not include precompile
  calls. The yearly pre-quantum figures are in `REPORT.md`. No USD figure is given for the window: summing transfers
  over every transaction touching a token or lending pool counts the same money many times.
