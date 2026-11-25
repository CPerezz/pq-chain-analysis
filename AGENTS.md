# Rules for findings

Read this before you file, review or edit anything in `findings/`, `triage/` or `patterns.md`, person or agent. A
person reads every card, often someone who is not an engineer. A wrong fact misleads the team we contact; an empty one
does not. When you are not sure, leave the field empty and ask your owner.

## Which instructions you follow

- **You run the EIP-8151 review** (claim rows, start authors and refuters, settle, file): `review/README.md`.
- **You are an author or a refuter of one review row**: `review/AUTHOR.md` or `review/REFUTER.md`, and the rules
  below. Your brief names your row; touch nothing else.
- **You file a new contract outside the review**: "Filing one contract" below.

## A finding

One contract and one root issue: what is wrong with this contract, how bad it is and why, and what its team can do.
The part above `## Reviewer notes` is the card readers see: short, plain, about this contract only. The Reviewer notes
keep what someone re-checking the finding needs, and are never displayed. A new entry starts in `triage/` and moves to
`findings/` once someone other than its reporter has reviewed it.

### Levels

| Level | What it takes |
|---|---|
| `candidate` | A claim: the pattern, the contract, who reports it from which study. Judgment fields may be empty; open questions are listed under `### Questions` |
| `confirmed` | Every judgment field filled, the state read at `block`, the three sections complete, every part of the card backed by a check, no open question |
| `reproduced` | Confirmed, and executed: `repro` carries the command, the code at a full commit hash, the inputs and the result the command must give |
| `duplicate` | The same issue filed twice; `duplicate_of` names the other file |

A finding that turns out not to be affected is removed.

### Duplicates

A contract can appear in any number of findings. A duplicate is the same contract under the same pattern in two
findings, and `tools/build.py` refuses it. Two findings that really are different issues of one pattern on one
contract say so by naming each other in `related`.

## Filing one contract

1. Look it up: `uv run tools/find.py 0xADDRESS`. Already filed under the same pattern: create no file. A person adds
   an entry to that finding's `sources` and says in its History what was checked; an agent stops and reports it.
2. Scaffold it; never type a fact: `ETH_RPC_URL=<node> uv run tools/new_finding.py 0xADDRESS --pattern PQ-n
   --study STUDY --issue SLUG --block N --who "<you>"`. It reads the name, code, proxy, upgradeability, admin and
   holdings at block N and writes `triage/<id>.md` with the judgment left empty. Activity comes from the study's data
   (`--txs-90d`, `--last`), or stays empty.
3. Write only the judgment, in the style of the filled examples in `templates/examples/findings/`: `title`,
   `severity` (the reporter's proposal), `justification`, `category` (the pattern's), `impact`, `action`,
   `evidence_level`, `value.whose`, the three sections, and the `checks` that back them.
4. Run `uv run tools/build.py` (the format) and `ETH_RPC_URL=<node> uv run tools/verify.py triage/<id>.md` (the facts
   and the checks, re-read from an archive node), and fix what they report.
5. Report what you filed, and every question you left.

## Reviewing an entry in `triage/`

Anyone but the reporter, person or agent:

- re-read a sample of the facts at `block` (the code, the proxy slots, the admin, the holdings);
- check the severity against the category's rubric, and that the category is the pattern's;
- read the card as someone who has never seen the contract: is it clear what is wrong, how bad, and what the team
  can do? Is every Evidence bullet a fact with its link?
- then add a `reviews` entry: `who`, `date`, `by`, `verdict` (`confirmed` or `refuted`), `rating`, a one-line `note`.

Confirmed, with no question open: move the file to `findings/` and set `status` to `confirmed` or `reproduced`.
Refuted: the contract is not affected; delete the file from `triage/` and file it nowhere. The study keeps the record.

## The file (format 2)

`templates/finding.md` is the form. Empty means not established: the card shows "not established".

### Header

| Field | Values | Rule |
|---|---|---|
| `id` | slug | The file name: `<contract name>-<first 8 hex of the address>-<issue>`. Published ids stay |
| `format` | `2` | |
| `title` | text | 20 to 80 characters: what is wrong, for whom. No amounts, addresses or pattern codes |
| `status` | `candidate`, `confirmed`, `reproduced`, `duplicate` | See "Levels" |
| `severity` | `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`, `INFORMATIONAL` | See "Severity" |
| `justification` | text | Up to 120 characters: why it is an issue, and why at this level |
| `category` | from `patterns.md` | The pattern's category |
| `pattern` | `PQ-n` | One pattern from `patterns.md`; the card shows its "In words" line, not its code |
| `study` | slug | The study that flagged it (a folder in `studies/`); later studies go in `sources` |
| `as_of` | date | The date of `block`. Every amount and count on the card is as of it, and no other date is shown |
| `block` | integer | The block every state read in the file is pinned to |
| `contract.address` | address | Lowercase `0x` and 40 hex: the address users call (a proxy, not its implementation) |
| `contract.name` | identifier | From verified source or the chain |
| `contract.project` | slug | The team that has to act; only from verified source, the chain or the team |
| `contract.label` | text | The explorer's public tag: a lead for outreach, never a name |
| `contract.code` | `verified`, `decompiled`, `bytecode` | Where a reader sees the code (see "Code") |
| `contract.code_url` | link | `verified` and `bytecode`: the Etherscan or Sourcify page; `decompiled`: `code/<code hash>.sol` (`code/README.md`) |
| `contract.proxy_of` | address | The implementation, when the address is a proxy |
| `contract.copies` | integer | Addresses running the same code; above 1 with `contract.family`. The site and the board show what the family holds beside `value.usd` |
| `contract.upgradeable` | `yes`, `no`, `config-only` | The card shows only yes or no |
| `contract.admin` | address or `none` | Who can upgrade or reconfigure. Not shown |
| `value.usd` | integer | What this address holds, its copies not included: ETH and the priced tokens of `tools/tokens.json`, on-chain prices |
| `value.whose` | `users`, `operator`, `mixed` | Whose money it is |
| `value.basis` | `held`, `market-cap`, `escrow` | `held`: what it holds; `market-cap`: the supply of a token whose permit is affected, an upper bound; `escrow`: what a forged message could release elsewhere |
| `activity.txs_90d` | integer | Transactions with a call to it, any function, in the 90 days to `block` |
| `activity.last` | date | The last of them. Not shown |
| `impact` | `funds-loss`, `funds-locked`, `liveness` | What happens if nobody acts; for a migration notice, if the key holder migrates unprepared |
| `action` | text | Up to 140 characters, for the contract's team, starting with a verb. Empty when nobody is sure |
| `evidence_level` | `source`, `bytecode`, `onchain`, `trace`, `executed` | The strongest evidence behind it |
| `primitive` | `ecrecover`, `bn254`, `kzg`, `bls12381`, `p256`, `sw_*`, `rsa` | For search; not shown |
| `duplicate_of`, `repro` | | As in "Levels" |
| `checks[]` | see "Checks" | What `tools/verify.py` re-runs. Not shown |
| `sources[]` | `study`, `who`, `date`, `by`, `verdict`, `rating`, `pattern` | One entry per study that found or checked this card's issue, the card's own `study` first: another issue a study finds on the same contract is a card of its own, never a source here. An entry from another study names the `pattern` it found or checked, which is this card's. `by` is `ai-assisted`, `project-team` or `other` |
| `reviews[]` | `who`, `date`, `by`, `verdict`, `rating`, `note` | Checks by someone other than the reporter |
| `related` | ids | Other findings on the same contract or code |

### Body

Exactly three sections, in plain English: short sentences, present tense, this contract only.

- `## What happens`: up to 300 characters of prose about this contract: what it does, where it trusts the
  signature, what goes wrong. No lists, tables or code blocks.
- `## Evidence`: one to three bullets of up to 200 characters, each with a link: the source line (link the verified
  source), a transaction, an explorer page.
- `## Reviewer notes`: never shown, up to 3,000 characters: `### Mechanism` (the path through the code), `### Checks`
  (what was read, how, and what was ruled out), `### History` (dated one-liners), and `### Questions` while a
  question is open, which keeps the finding a `candidate`. Nothing else, and no pasted code.

What readers see carries no working notes: no `CHECKED` or `INFERRED`, no "read at block", no decision numbers,
pattern codes, file names, code family ids, or agent and tool names. Nothing follows the Reviewer notes.

### Checks

Every part of the card rests on something anyone can run again. `checks` is a list; each entry is one read with the
result it must give, a line on what it shows (`says`), and the parts of the card it supports (`for`: `what`,
`evidence-1` to `evidence-3`, `justification`, `action`, `notes`). From `confirmed` up, every part needs one.

| Kind | Fields | What is re-run |
|---|---|---|
| `code: "0x…"` | `is` (`empty`, `contract`, `delegation`), `bytes`, `target` | The code at the address |
| `bytecode: "0x…"` | `has` (hex), `absent` | A byte sequence in the runtime code |
| `selector: "0x…"` | `fn`, `absent` | A function's selector in the runtime code |
| `storage: "0x…"` | `slot`, `is` | A storage slot |
| `call: "0x…"` | `fn` as `name(types)(return types)` with `args`, or raw `data` (0x calldata, for a function known only by its selector); `is`, `reverts` or `reverts_with` (text of the revert reason or its hex data); `from` | A read-only call. With `data`, `is` is the raw returned hex |
| `source: "0x…"` | `file`, `line` or `lines: [first, last]`, `has` | Text at those lines of the verified source |
| `tx: "0x…"` | `to`, `ok` | A transaction and its outcome |
| `nonce: "0x…"` | `is` or `min` | An account's transaction count |
| `logs: "0x…"` | `topic` (the event's topic 0), `from` (first block), `to` (last block, else `block`), more `topics`; `count`, `min` or `has` (hex in the logs) | One emitter's logs of one event in that range |
| `replay: "0x…"` | `run` (`today`, `eip8151`, `eip8151_signer_code`, `eip8151_signer_delegated`, `eip8151_self_real_code`, `eip8151_more_gas`: EIP-8151 with 300,000 more gas, which tells a sender's gas limit from a budget fixed in code; `eip8151_more_gas_1m`: with 1,000,000 more, for a transaction that recovers about a hundred signatures), `ok` | A real transaction replayed on the study's fork engine |
| `ref: "https://…"` | | A written record of an execution, pinned to a commit. Not re-run |

Reads are at the finding's `block` unless the check has `at`. Addresses and hashes are quoted.

- Write a sentence only after its check passes. If no check can back a sentence, drop the sentence or make it a
  question.
- A check proves a fact, not your conclusion. Ask of each sentence: could the check pass and the sentence still be
  false? A function that exists is not a function that does what you say; read its lines and cite them.
- The header facts come from `tools/new_finding.py`. Where a reviewer states a fact the tool does not read, or reads
  differently (`proxy_of`, `upgradeable`, `admin`, `name`), a check names that fact in its `for`; `whose` may be
  backed the same way. `tools/verify.py` fails a file whose facts differ from the tool's without such a check.

### Code

Code is linked, never pasted: verified code on Etherscan or Sourcify (`verified`), with the Evidence pointing at the
line; decompiled code that someone used to judge the finding, added under `code/` as `code/README.md` says
(`decompiled`); otherwise the explorer's bytecode page (`bytecode`).

## Stating a fact

1. **Names from the chain or verified source**, not explorer labels: the label is only a lead.
2. **Upgradeability from storage**, not from a name: the EIP-1967 slots, `owner()`, the Safe singleton, at `block`.
3. **Value with its basis.** Never present a market cap or a 30-day flow as funds held.
4. **Unverified code is `bytecode` evidence**, confirmed only after a second check (a review, a replay).
5. **Never guess** a fact or a judgment: an owner, a value, a fix. Leave the field empty, write the question under
   `### Questions` in the Reviewer notes, keep `status: candidate`, and ask your owner.
6. **Do not change a fact the scaffold read.** If you think it is wrong, ask.

## Severity

`patterns.md` gives each pattern's category. `INFORMATIONAL` is used only by the migration notices; the other ratings
follow one of two rubrics, by category. Value and activity never change a rating: they order the findings.

### Category `quantum-exposure`

A finding answers: **if someone has a cryptographically relevant quantum computer (CRQC), what can they do through
this contract, and what can the people who run it change without a protocol change?**

- A CRQC recovers a secret from public data for every pre-quantum scheme on Ethereum: secp256k1 and P-256 private keys
  from public keys (any key that has signed on-chain), BLS secret keys from public keys, RSA keys from moduli, and the
  trapdoor of a pairing-based trusted setup (the KZG/Groth16/PLONK "toxic waste") from its public parameters. With the
  trapdoor, proofs and KZG openings for false statements verify.
- User accounts can move to post-quantum authorisation (EIP-8141 frame transactions with PQ verification, or smart
  accounts with PQ signers). Protocol changes that would protect contracts without their cooperation (EIP-8151, which
  makes `ecrecover` fail for accounts with real code) are not assumed.
- No CRQC exists today. Severity ranks what to fix first so that nothing depends on a protocol rescue, not how soon.

Scope: Ethereum mainnet contracts that verify pre-quantum cryptography on a path that moves, releases or locks value,
or gates a user action. User EOAs themselves are out of scope; wallet contracts whose owners are ECDSA keys are in
scope (pattern PQ-12), because the wallet code decides what an owner can change.

| Rating | Rule |
|---|---|
| CRITICAL | Pooled funds (what the contract holds or can release) can be taken by forging one operator key, a committee, or a proof, **and** no fix can be counted on: the verification cannot be changed (immutable, no admin) and its users cannot all move |
| HIGH | No fix without a protocol change can be counted on, and funds can be taken or stuck: pooled funds whose fix needs an owner nobody can reach or many independent parties; or users' own funds that stay forgeable after they migrate their account, in a contract that cannot change; or a dependency on KZG blobs that neither an existing path nor an upgrade can replace |
| MEDIUM | Fixable without a protocol change, but the fix is a contract upgrade, a governance vote, a new deployment that users move to, owners migrating their accounts, or several parties acting. Also: post-quantum users are locked out of a core function with no alternative |
| LOW | An alternative path already exists and nothing can be taken through the check; or one known operator changes a setting; or the check guards only an auxiliary feature through which nothing can be taken |

Apply in order, from the finding's checked facts: (1) the impact: what a CRQC holder can do if nobody acts; (2) who
can fix it, and how; (3) rate by the fix, as in the table; (4) if it is not established who can change the
verification, rate as if nobody can; (5) when the team says whether and how it can fix it, that replaces step 2;
record it in History. A re-rating keeps the old rating in History with the step that decided the new one. A team
multisig changing a setting is one known operator (LOW). A wallet is rated as one wallet: a family of wallets is
never rated as a whole.

### Categories of a protocol change (`breaks-at-activation`, `voided-by-migration`, `migration-notice`)

Decided by Anon for the EIP-8151 study. First question: does the change break it by itself? A consequence that needs
a key holder to move its own account to code is the same as that holder no longer signing, which any holder can
already do; it is a migration notice, `INFORMATIONAL`, whatever it would lock. The ratings below apply to what the
change breaks with nobody acting (a gas cost), and to a signature another party already holds and acted on, which the
contract checks later on chain, so that its signer can void it by migrating (a payment voucher, a channel balance
proof, a DKG result, a fraud proof). When the signer can already take back what that party relies on without
migrating (a channel past its timeout), migrating adds nothing: a migration notice. `patterns.md`, "Choosing between
patterns", picks the pattern.

| Rating | Rule |
|---|---|
| CRITICAL | No update path, and people who did nothing lose funds: a wrong verdict pays or punishes someone, or a party that relied on a signature loses |
| HIGH | No update path, and funds are locked: nothing gets them out |
| MEDIUM | No update path, and only the operator's own money is at stake; or the affected function dies but nothing is locked (an owner, admin, disband or rescue path still moves the money, or the contract holds none by design) |
| LOW | A simple update fixes it (a live admin or owner upgrade, a setting, a sender's gas limit), or the same act stays open to the affected party by another path |
| INFORMATIONAL | Breaks only if a key holder moves its own account to code. The finding says what to do first (rotate the key, upgrade, move the funds out, exit, enter); `impact` says what happens if the holder migrates unprepared |

A gas amount fixed in the code (pattern PQ-14) with no update path is `CRITICAL` whatever the contract holds or locks
today: nobody can know whether value arrives later, and the function is dead for good. With an update path it is
`LOW`. The `HIGH` and `MEDIUM` rows above do not apply to it.

A key that has never sent a transaction is presumed live; an admin is unable to act only when that is shown (zero or
dead address, renounced, a contract with no way to call). For a migration notice, when the holder's only ETH exit
is a 2,300-gas transfer (`transfer`, `send`) and every other path needs its signature, `impact` is `funds-locked`.

One finding describes one address in use. A row whose address is not in use (an implementation never used alone, a
retired copy) is not affected there; each copy in use is its own finding. An address that held nothing (ETH and the
priced tokens) at the block and received no call in the study's 30- or 90-day window has no finding: it is dropped
without review, whatever its code would do. A finding whose value is an escrow or a token supply is about money in
other contracts and is not dropped that way.

## Working

- Node: one RPC request at a time, at the pinned block; no wide `eth_getLogs`, no `trace_*`.
- No sub-agents unless your owner asks for them.
- Finish every contract you take: the check passes, or the file stays a candidate with its questions. Never leave a
  file that fails the check.
- Do not commit unless your owner asks.
- A fault someone could use today (not a post-quantum or EIP-8151 effect: funds anyone can take now) never goes into
  this public repository: not in a card, a note, a commit or a message. Tell your owner privately and name the
  contract only.

## Format 1

Files without `format: 2` are format 1 (the field reference is `findings/README.md` at commit
`0ca5495cb3b79559c72e805ec0798d07b90e39fa`): the EIP-8151 study's bulk entries, not yet reviewed. `review/` converts
them, one contract at a time; a format-1 file leaves when the last of its contracts
is filed or removed. The build accepts them until then. Do not create new format 1 files.

The EIP-8151 root-issue entries, `triage/eip-8151-*.md`, list one row per contract. Each row has its own `rating`, by
the rubric for a protocol change, and the entry's `severity` is its highest row. A family whose addresses differ is
one row per answer: its proxies with a live admin are one row, its copies with no update path another.
