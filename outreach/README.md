# outreach/

One file per affected project: where contact with its team stands, and a dated log of every attempt and reply.

There is no file for a project that nobody has contacted. The lists show such a project as `not-contacted`.

## Adding or updating a file

1. The file is `outreach/<project>.md`, where `<project>` is the `project` of at least one finding (or of one of its
   contract rows). One file per project, never per finding. Start from `templates/outreach.md`.
2. Add one line to `## Log` for every attempt and every reply, oldest first:
   `- YYYY-MM-DD (who, channel): what was sent or received.` Never edit or delete an earlier line; correct it with a
   new one.
3. Set `status` to match the last line.
4. Run `uv run tools/build.py`.

## Fields

| Field | Values | Meaning |
|---|---|---|
| `project` | slug, = file name | The project named in the findings |
| `status` | `not-contacted`, `contacted`, `acknowledged`, `fix-planned`, `fixed`, `unresponsive`, `declined` | Where it stands. Anything but `not-contacted` needs a dated log line |
| `channel` | text or null | How the team is reached |
| `fix_eta` | date or null | The fix date the team agreed to |

`contacted`: a message was sent, no reply yet. `acknowledged`: the team replied and accepts the issue. `fix-planned`:
the team named a fix and a date. `fixed`: the fix is live; the log says how that was checked. `unresponsive`: no reply
after repeated attempts. `declined`: the team disputes the issue or will not fix it; the log has its reason.

## What does not go here

This repository is public. Record only public routes (a `security@` address, a bug bounty page) and what was said in
summary. No personal handles, no private groups, no message text.
