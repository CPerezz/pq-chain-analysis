# triage/

New entries land here, never directly in `findings/`. A new entry is one contract and one root issue in format 2
(`templates/finding.md`, field rules in `findings/README.md`), started with `tools/new_finding.py`. Agents follow
[`AGENTS.md`](../AGENTS.md). The root-issue entries `eip-8151-*.md`, with one row per contract, are format 1: the
review (`review/README.md`) turns each row into a format-2 finding or removes it, and the row leaves this folder.

Each row has its own `rating`; the entry's `severity` is only its highest row. A row's rating says how hard the fix
is, never how much is at stake (D-024 and D-026 of the EIP-8151 study). A consequence that needs a key holder to move
its own account to code is `INFORMATIONAL`, whatever it would lock; the other ratings are for what the change breaks
with nobody acting, and for a signature someone already relied on that its signer can void by migrating:

| Rating | Rule |
|---|---|
| INFORMATIONAL | Breaks only if a key holder moves its own account to code; the row says what to do first (rotate the key, upgrade, move the funds out, exit, enter) |
| LOW | A simple update fixes it: an upgrade by a live admin or owner, a setting, a gas limit. Or the same act stays open to the affected party by another path |
| MEDIUM | No update path, and only the operator's own money is at stake, or the affected function dies but nothing is locked (an owner, admin, disband or rescue path still moves the money, or none is held by design) |
| HIGH | No update path, and funds are locked with no way out |
| CRITICAL | No update path, and people who did nothing lose funds (a wrong verdict pays or punishes someone, or a party that relied on a signature loses) |

A family whose addresses differ is one row per answer: its proxies with a live admin are one row, its copies with
no update path another. Value and activity set the order, not the rating.

- **File.** `uv run tools/find.py 0xADDRESS` first. If the contract is already filed under the same pattern, add a
  `sources` entry there instead. Otherwise scaffold it with `tools/new_finding.py`. Here `severity` is the reporter's
  proposal; open questions go under `### Questions` and keep it a candidate.
- **Review.** Anyone but the reporter, person or agent:
  - re-read a sample of the facts at `block` (the code, the proxy slots, the admin, the holdings);
  - check the severity against the category's rubric, and that the category is the pattern's;
  - read the card as someone who has never seen the contract: is it clear what is wrong, how bad, and what the team
    can do? Is every Evidence bullet a fact with its link?
  - then add a `reviews` entry: `who`, `date`, `by`, `verdict` (`confirmed` or `refuted`), `rating`, a one-line `note`.
- **Promote.** Move the file to `findings/` once a review confirms it and no question is open; set `status` to
  `confirmed` or `reproduced`.
- **Refuted.** A contract that turns out not to be affected is deleted from triage and filed nowhere; the study keeps
  the record.
- **Be brief.** The card is short by rule; the Reviewer notes hold the rest.

`generated/TRIAGE.md` and `generated/triage.csv` list the entries; `generated/triage_contracts.csv` lists every row,
in priority order, to search for an address.
