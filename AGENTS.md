# Rules for agents

Read this before you file, review or edit anything in `findings/`, `triage/` or `patterns.md`. A person reads every
card you write, often someone who is not an engineer. A wrong fact misleads the team we contact; an empty one does
not. When you are not sure, leave the field empty and ask your owner.

## The format

Every new or edited finding is format 2: the form is `templates/finding.md`, the rules are in `findings/README.md`.
Copy the style of the filled examples in `templates/examples/findings/`, one per category.

## Filing one contract

1. Look it up: `uv run tools/find.py 0xADDRESS`. Already filed under the same pattern: stop and report it.
2. Scaffold it; never type a fact: `ETH_RPC_URL=<node> uv run tools/new_finding.py 0xADDRESS --pattern PQ-n
   --study STUDY --issue SLUG --block N --who "<you>"`. It reads the name, code, proxy, upgradeability, admin and
   holdings at block N and writes `triage/<id>.md`. Activity comes from the study's data (`--txs-90d`, `--last`), or
   stays empty.
3. Write only the judgment: `title`, `severity`, `justification`, `category` (the pattern's), `impact`, `action`,
   `evidence_level`, `value.whose`, and the three sections.
4. Run `uv run tools/build.py --check` and fix what it reports.
5. Report what you filed, and every question you left.

## When you are not sure

- Never guess a fact or a judgment. Leave the field empty, write the question under `### Questions` in the Reviewer
  notes, keep `status: candidate`, and ask your owner.
- Do not change a fact the scaffold read. If you think it is wrong, ask.
- `contract.project` only from verified source, the chain or the team. An explorer tag goes in `contract.label`.

## Writing the card

- Plain English, short sentences, present tense, this contract only.
- `title` (20 to 80 characters): what is wrong, for whom. No amounts, addresses or pattern codes.
- `justification` (up to 120): why it is an issue, and why at this severity.
- `action` (up to 140): one thing the contract's team can do, starting with a verb. Empty if you do not know.
- `## What happens` (up to 300): what the contract does, where it trusts the signature, what goes wrong.
- `## Evidence` (one to three bullets, up to 200 each, each with a link): the facts that show the problem is real.
  Link the verified source at the line, a transaction, or an explorer page.
- Never in those: `CHECKED` or `INFERRED`, "read at block", decision numbers, pattern codes, file names, family ids,
  agent or tool names.
- `## Reviewer notes` (up to 3,000, never shown): `### Mechanism` (the path through the code), `### Checks` (what you
  read, how, and what you ruled out), `### History` (dated one-liners). Nothing else, and no pasted code.

## Severity

`patterns.md` gives each pattern's category; `findings/README.md` gives the rubric for each. A migration notice is
always `INFORMATIONAL`. Value and activity never change a rating. A key that never sent a transaction is presumed live.

## Code

Link verified code on Etherscan or Sourcify (`contract.code: verified`). If you decompiled unverified code to judge
the finding, add it under `code/` as `code/README.md` says and set `contract.code: decompiled`. Otherwise
`contract.code: bytecode` with the Etherscan link.

## Working

- Node: one RPC request at a time, at the pinned block; no wide `eth_getLogs`, no `trace_*`.
- No sub-agents unless your owner asks for them.
- Finish every contract you take: the check passes, or the file stays a candidate with its questions. Never leave a
  file that fails the check.
- Do not commit unless your owner asks. Before a filing commit, rebuild `generated/` with `uv run tools/build.py`.
