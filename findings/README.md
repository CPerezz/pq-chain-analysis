# findings/

One file per finding, for every study. A finding is one issue: one project and one mechanism with every affected
mainnet contract, or one situation that holds across many contracts, where each contract row names its project. The
files are the source of truth; `generated/` is built from them by `tools/build.py`.

A finding says what the issue is, where it is (contract and function; transaction and inputs when there are any), why
it is an issue, and how to reproduce it. It is one self-contained file: there is nothing beside it.

## Adding a finding

1. **Look first.** Search `generated/contracts.csv` and `triage/` for every address you have. If the issue is already
   there, do not create a file: add your own entry to that finding's `sources`, with your study, and say in History
   what you checked. The lists then show the finding as found by both studies.
2. Copy `templates/finding.md` to `triage/<id>.md`, not here. Filled examples for each level are in
   `templates/examples/findings/`. A file moves here when someone other than the reporter has reviewed it
   (`triage/README.md`).
3. Pick the pattern in [`patterns.md`](../patterns.md). If none fits, add a pattern, or a class, there in the same
   pull request. What counts as a finding is up to the study that reports it.
4. Run `uv run tools/build.py`.

Write as little as the claim allows: a Summary of one to three sentences, each section only as long as its evidence
needs.

## Levels

Every finding has one level, in `status`. The level is a label, not a gate: a finding can be filed at any level and
moves up when someone adds what the next level needs.

| Level | What it takes |
|---|---|
| `candidate` | A written claim. Reading-only is fine. It needs a title, a pattern, where it is, a `## Summary`, and who reports it from which study. Nothing else |
| `confirmed` | The code is quoted in the finding and the state it depends on was read at a stated block (`evidence.block`). It is rated, and all six sections are filled |
| `reproduced` | It was executed. The header carries `repro`: the command, a link to the code at a full commit hash, the inputs (block, transaction) and the result the command must give |

`not-affected` (with `severity: NONE`) and `duplicate` (with `duplicate_of`) keep a file that turned out wrong or
redundant, so links to it keep working.

## Duplicates

A contract can appear in any number of findings. A duplicate is the same contract under the same pattern in two
findings, and `tools/build.py` refuses it. Two findings that really are different issues of one pattern on one
contract say so by naming each other in `related`.

## Evidence lives in the finding

Quote the code that decides the issue in `## Evidence`, up to 150 lines; link anything longer. Give the block for
every state read. Do not commit raw reads, traces or scripts: anyone can read the chain again at the block you name,
and code lives with the study. Bulk material that a reader may still want is linked with `evidence.raw`, at a full
commit hash.

The 225 findings of the `top-callers-classification` study carry their source excerpts and review notes as appended
documents after `## History`, exactly as the study wrote them. Excerpts longer than 150 lines and the raw reads are
linked at the commit that held them.

## Threat model for class `exposure`

A finding of class `exposure` answers: **if someone has a cryptographically relevant quantum computer (CRQC), what can they do through
this contract, and what can the people who run it change without a protocol change?**

- A CRQC recovers a secret from public data for every pre-quantum scheme on Ethereum: secp256k1 and P-256 private keys
  from public keys (any key that has signed on-chain), BLS secret keys from public keys, RSA keys from moduli, and the
  trapdoor of a pairing-based trusted setup (the KZG/Groth16/PLONK "toxic waste") from its public parameters. With the
  trapdoor, proofs and KZG openings for false statements verify.
- User accounts can move to post-quantum authorisation (EIP-8141 frame transactions with PQ verification, or smart
  accounts with PQ signers). Protocol changes that would protect contracts without their cooperation (EIP-8151, which
  makes `ecrecover` fail for accounts with real code) are not assumed; a finding says when one would help.
- No CRQC exists today. Severity ranks what to fix first so that nothing depends on a protocol rescue, not how soon.

Scope: Ethereum mainnet contracts that verify pre-quantum cryptography on a path that moves, releases or locks value,
or gates a user action. User EOAs themselves are out of scope; wallet contracts whose owners are ECDSA keys are in
scope (pattern PQ-12), because the wallet code decides what an owner can change.

## Fields

| Field | Values | Meaning |
|---|---|---|
| `id` | slug = file name | Stable name, `<project>-<mechanism>` |
| `title` | text | One line: what breaks, or what an attacker can do, and for whom |
| `project` | slug | The team that has to act. May be left out when every contract row has its own `project` |
| `status` | `candidate`, `confirmed`, `reproduced`, `not-affected`, `duplicate`, `discarded` | The level; see "Levels". `discarded` exists only in `triage/` |
| `severity` | `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`, `NONE`, `UNRATED` | See "Severity". A candidate may leave it out |
| `patterns` | list of `PQ-n` | From `patterns.md`. The class of the first one is the finding's class |
| `primitives` | list | `ecrecover`, `bn254`, `kzg`, `bls12381`, `p256`, `sw_p256`, `sw_secp256k1`, `sw_bn254`, `sw_ed25519`, `sw_bls12381`, `rsa` (`sw_` = curve maths done in software via `modexp`) |
| `trigger` | `user-key`, `operator-key`, `committee-keys`, `trusted-setup`, `owner-keys`, `issuer-key`, `none` | What the attacker must break |
| `impact` | `funds-loss`, `funds-locked`, `liveness`, `none`, `unknown` | Worst effect if nobody acts. `liveness`: post-quantum users cannot use the path, nothing is taken |
| `alternative` | `sole`, `key-rotation-only`, `alternative-exists`, `configurable-verifier` | Whether the pre-quantum check can be avoided: the only way in; signers rotate but the scheme is fixed; another path exists (ERC-1271, pre-sign, on-chain approval); the consumer can point at a new verifier |
| `role` | `core`, `auxiliary` | Whether the contract's main purpose needs the check |
| `contracts[]` | see below | One entry per affected deployment: the address users call (the proxy, not its implementation) |
| `families[]` | see below | Many deployments of the same code (Safe proxies, clones), as one entry |
| `fix.layer` | `contract-upgrade`, `onchain-config`, `new-deployment`, `account-migration`, `offchain`, `protocol`, `none`, `unknown` | Where the fix happens |
| `fix.who_acts` | text | Who must act, with the address of the admin or owner where known |
| `fix.protocol_change` | `required`, `helps`, `not-needed` | Whether an Ethereum protocol change is needed (`required`), would protect users without the team (`helps`, e.g. EIP-8151), or is irrelevant |
| `evidence.level` | `onchain-read`, `source-read`, `bytecode`, `trace`, `executed` | Strongest evidence: `source-read` = the check was read in verified source; `bytecode` = unverified, inferred from selectors and constants; `trace` = only seen calling a precompile; `executed` = run before and after a change |
| `evidence.block` | number | The block at which state was read. Required from `confirmed` up |
| `evidence.raw` | link | Optional: raw reads kept elsewhere, at a full commit hash |
| `repro` | `code`, `command`, `inputs`, `expect` | Required for `reproduced`; see "Levels" |
| `sources[]` | `study`, `who`, `date`, `by`, `ref`, `verdict`, `rating` | One entry per study that found or checked it. `study` is a folder in `studies/`; `by` is `ai-assisted`, `project-team` or `other`; `verdict` is `reported`, `confirmed` or `refuted`; `rating` is that source's own rating |
| `related` | list of ids | Findings that share contracts, code or a stack, or were split from one another. Links go both ways |
| `reviews[]` | `who`, `date`, `by`, `verdict` (`confirmed`, `refuted`), `rating`, `note` | Checks by someone other than the reporter, made in `triage/`; kept when the file moves here |

`primitives`, `trigger`, `alternative`, `role` and `fix.protocol_change` describe an exposure. They are required, from
`confirmed` up, only for findings of class `exposure`.

`contracts[]` entries: `address`, `project` (only when it differs from the finding's), `implementation` (current, for a proxy), `name`, `upgradeable` (`yes`, `no`,
`config-only`, `unknown`), `admin` (who can upgrade or reconfigure), `value_usd` and `value_basis` (`held` = ETH and
tokens it holds; `market-cap` = circulating supply of a token whose permit is affected, an upper bound; `escrow` =
what a forged message or proof could release elsewhere), `value_as_of`, `last_active` (last transaction that called the
contract, any function), `txs_30d` (transactions that called it in the 30-day window, any function; see
`generated/README.md`), `txs_90d` (transactions with a call frame to it, any function, in the 90 days before the
value's block; Xatu call frames, holes traced on a node).

A finding about one root issue across many contracts leaves `project` out and gives each row what is known of it.
Optional row fields, one row per code family:
- `family`: the study's code family;
- `copies`: how many addresses run that code; `address` is one of them, and `value_usd` is the total;
- `label`: a block explorer's public tag. A lead for outreach, never a name: `project` is set only from the chain,
  verified source or the team;
- `rating`: that row's own rating. The finding's `severity` is the worst row;
- `recoveries_14d`: recoveries in the study's two-week trace window;
- `note`: one line on what decides it and how that is known.

A row's `project` is never `unidentified-…`: an unknown project is left out.

`families[]` entries: `code`, `name`, `instances`, `list`, `upgradeable`, `value_usd`, `value_basis`, `value_as_of`.

## Severity

The rubric below was written for class `exposure`. Classes `regression` and `migration-hazard` have theirs below it.
All use the same six ratings and the same first question: who can fix it, and how hard is that.

Rated by whether the exposure can be removed without an Ethereum protocol change, and how hard that is. Value and
activity never change a rating: they are columns to sort and filter by. Each source's own rating is kept in
`sources[].rating`.

| Rating | Rule |
|---|---|
| CRITICAL | Pooled funds (what the contract holds or can release) can be taken by forging one operator key, a committee, or a proof, **and** no fix can be counted on: the verification cannot be changed (immutable, no admin) and its users cannot all move |
| HIGH | No fix without a protocol change can be counted on, and funds can be taken or stuck: pooled funds whose fix needs an owner nobody can reach or many independent parties; or users' own funds that stay forgeable after they migrate their account, in a contract that cannot change (only every user moving, or a protocol change such as EIP-8151, protects them); or a dependency on KZG blobs that neither an existing path nor an upgrade can replace (for example with calldata data availability), so only a protocol change replaces it |
| MEDIUM | Fixable without a protocol change, but the fix is a contract upgrade, a governance vote, a new deployment that users move to, owners migrating their accounts, or several parties acting. Also: post-quantum users are locked out of a core function with no alternative |
| LOW | An alternative path already exists and nothing can be taken through the check (for an operator, committee or prover: one known party switches to it); or one known operator changes a setting; or the check guards only an auxiliary feature through which nothing can be taken |
| NONE | No exposure beyond the user's own account key (for example: account code checked first, full-length ERC-1271 for contracts) |
| UNRATED | Not enough established to apply the steps |

### Applying the rubric

Apply in order, from the finding's checked facts.

1. *(Removed 2026-11-19: dormancy no longer lowers a rating.)*
2. **Impact.** What a CRQC holder can do if nobody acts: take pooled funds (forged operator, committee or proof);
   take users' own funds through their signatures (forged user key); lock funds; or only lock post-quantum users out
   of the path (`liveness`). Sets `impact`.
3. **Who can fix it, and how.** From `upgradeable`, `alternative`, `fix.layer`, `fix.who_acts`: an admin upgrade, a
   governance vote, a new verifier the consumer points at, a new deployment users move to, owners migrating.
4. **Rate by the fix.** Pooled loss with no fix that can be counted on: CRITICAL. User-key loss in a contract that
   cannot change, pooled loss whose fix depends on many parties or an unknown owner, or a KZG dependency with no
   fallback: HIGH. A fix by upgrade, vote, release, new deployment or migration (including an upgrade that adds or
   restores calldata data availability): MEDIUM. An existing alternative through which nothing can be taken (such as a
   calldata path the operators can already use in the deployed contracts, when a forged opening only withholds data),
   one operator's setting, or an auxiliary feature that cannot move funds: LOW.
5. *(Removed 2026-11-19: value no longer lowers a rating.)*
6. **Unknown fixability.** If it is not established who can change the verification, rate as if nobody can.
7. **The team's answer.** When the team says whether and how it can fix it, that replaces step 3. Record it in History.

A re-rating keeps the old rating in History with the step that decided the new one.

### Classes `regression` and `migration-hazard`

Decided by Anon for the EIP-8151 study (D-024): the rating says how hard the fix is; value and activity only order
the findings.

| Rating | Rule |
|---|---|
| CRITICAL | No update path, and people who did nothing lose funds: a wrong verdict pays or punishes someone, or a party that relied on a signature loses |
| HIGH | No update path, and funds are locked: nothing gets them out |
| MEDIUM | No update path, and only the operator's own money is at stake; or the affected function dies but nothing is locked (an owner, admin, disband or rescue path still moves the money, or the contract holds none by design) |
| LOW | A simple update fixes it (a live admin or owner upgrade, a setter that replaces the key, a 7702 re-delegation, a setting, a sender's gas limit), or the same act stays open to the affected party by another path |
| NONE | Checked and not affected |

## Checks before you state a fact

1. **Names from the chain or verified source**, not explorer labels: quote the contract or function name from the
   source, or the selector.
2. **Upgradeability from storage**, not from a name: read the EIP-1967 slots, `owner()`, the Safe singleton; record
   the block.
3. **Value with its basis and date.** Never present a market cap or a 30-day flow as funds held.
4. **Unverified code is `bytecode` evidence**, and the finding stays `candidate` unless a second check confirms it.
5. **Never invent** an owner, a value or a fix: use `null` or `unknown`, and say in the body what is missing.

## Do not

- Do not delete a published finding that turns out wrong: set `status: not-affected` with `severity: NONE`, or
  `duplicate` with `duplicate_of`, so links to it keep working.
- Do not edit `generated/`; run `tools/build.py`.
