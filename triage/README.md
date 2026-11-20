# triage/

New entries land here, never directly in `findings/`. Same format as a finding (`templates/finding.md`). An entry is
one root issue (an issue family, a broken invariant), not one per project: every affected contract is a row inside it,
with its own facts (`findings/README.md`, row fields).

Each row has its own `rating`; the entry's `severity` is only its highest row. A row's rating says how hard the fix
is, never how much is at stake (D-024 of the EIP-8151 study):

| Rating | Rule |
|---|---|
| LOW | A simple update fixes it: an upgrade by a live admin or owner, a 7702 re-delegation, a key rotation, a setting, a gas limit. Or the same act stays open to the affected party by another path |
| MEDIUM | No update path, and only the operator's own money is at stake, or the affected function dies but nothing is locked (an owner, admin, disband or rescue path still moves the money, or none is held by design) |
| HIGH | No update path, and funds are locked with no way out |
| CRITICAL | No update path, and people who did nothing lose funds (a wrong verdict pays or punishes someone, or a party that relied on a signature loses) |

A family whose addresses differ is one row per answer: its proxies with a live admin are a LOW row, its copies with
no update path are another. Value and activity set the order, not the rating: `generated/triage_contracts.csv` lists
every row by value held, then by recoveries in the window.

- **File.** Search `generated/contracts.csv` and this folder first. If the contract is already listed under the same
  pattern, add a `sources` entry there instead. Otherwise copy the template to `triage/<id>.md`. Here `severity` is
  the reporter's proposal.
- **Review.** Anyone but the reporter, person or agent. Add a `reviews` entry with `who`, `date`, `by`, `verdict`
  (`confirmed` or `refuted`), `rating` and a one-line `note`.
- **Promote.** A pull request that moves the file to `findings/` once a review confirms it. The reviewer sets the
  final `severity` and the level (`confirmed` or `reproduced`).
- **Discard.** Set `status: discarded` and add a `refuted` review that says why. The file stays here so that nobody
  files it again.
- **Be brief.** A Summary of one to three sentences. Expand only where the claim needs it: the code that decides
  it, the transaction, the state read.

`generated/TRIAGE.md` and `generated/triage.csv` list the entries; `generated/triage_contracts.csv` lists every row,
in priority order, to search for an address.
