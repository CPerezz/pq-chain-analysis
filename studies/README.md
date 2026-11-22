# studies/

A study says how something was investigated: the question, the setup, the procedure, how to repeat it, what came
out and what it cannot see. What it found goes in [`findings/`](../findings/), one file per issue, and each finding
names the studies that found it.

A study is a folder, `studies/<id>/`, with a `README.md` and, if it produced small tables, a `results/` folder.

## Adding a study

1. Copy `templates/study.md` to `studies/<id>/README.md`. A filled example is
   `templates/examples/studies/example-study/README.md`.
2. Fill the header and the six sections. A study can be added as `planned` before any work is done, so that others
   see it is under way.
3. Keep the code somewhere else: a repository or a gist you own. Link it in `code` with a full commit hash or gist
   revision, so the link always shows the code that was run. This repository holds no study code.
4. File what the study found as findings (see [`AGENTS.md`](../AGENTS.md)). If a finding is already
   in the list, add your own entry to its `sources` instead of creating a second file.
5. Run `uv run tools/build.py`: it checks the study and its findings.

Two studies of the same topic by different people are two folders. Give the second a distinguishing id.

## Header

| Field | Values | Meaning |
|---|---|---|
| `id` | slug, = folder name | Stable name. Findings refer to it in `sources[].study` |
| `title` | text | One line: the question the study answers |
| `authors` | list | GitHub logins or names |
| `status` | `planned`, `running`, `published` | Where the work stands |
| `started`, `published` | date or null | |
| `topic` | slug | What it is about. `eip-<number>` for a study of an EIP; studies with the same topic belong together |
| `code` | `none`, or a list of links | Where the code is. Every link carries a full commit hash or gist revision |
| `spec` | `repo`, `path`, `commit` | Required when the topic is an EIP: the text that was tested, at a commit. EIP texts change, so a study names the one it tested |

## Sections

In this order, with these headings:

| Section | What it says |
|---|---|
| Goal | The question, and why it matters |
| Setup | Data and where it lives, block range, node or service, the block at which state was read, tool versions. For a protocol change: the change in plain words |
| Procedure | What was done, step by step, with the script for each step |
| Reproduce | The commands, in order, at the linked commit; what they need |
| Results | What was found, with numbers. A study that found nothing says so |
| Limits | What the method cannot see, what was not covered, what could make a number wrong |

## Result tables

Small tables that a study produced (aggregates, the list of what it looked at) go in `results/` next to its README.
Large datasets stay outside, linked from Setup or Results with a commit or a checksum.
