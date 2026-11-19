# triage/

New entries land here, never directly in `findings/`. Same format as a finding (`templates/finding.md`).

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

`generated/TRIAGE.md` and `generated/triage.csv` list the pool by proposed rating, exposure and activity.
