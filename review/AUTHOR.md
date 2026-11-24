# Author: one row, from its dossier to an accepted draft

You review **one** contract under **one** root issue of this registry, and write what the registry will say about
it. Thousands of earlier findings were filed by rules and in bulk, and many are wrong. Your job is to find out what is
true for this contract, and to write only what you can back with a check that anyone can run again. A wrong card is
worse than no card.

## What you are given

- `KEY`: `<root issue>|<address>`. `W` = `review/work` (paths below are from the registry's root).
- The dossier, `W/dossier/<address>-<issue>/` (a `/` in the issue becomes `_`):
  - `dossier.json`:
    - `row`: what was claimed before. **Untrusted.** It is the lead you test, not a fact.
    - `facts`: what the scaffold tool read at block 26,438,999 (code, proxy, upgradeable, admin, name, verified,
      value). These go into the finding as they are. `implementation`: the same for the code behind a proxy.
    - `scan`: leads from the study's tables: the scanner's counts for the code, real recoveries in a two-week trace
      window, replays on the fork engine (`families.*.replays`), proxies that point here, the family's size and
      value. **Leads, never verdicts**: the scanner has been wrong in both directions.
    - `signers`: addresses recovered in real transactions, with their code at the block.
    - `use`: leads about this address's own use before the block: transactions that called it in the last 90 days,
      the recoveries it made in its latest transactions (with the address recovered), and the recoveries a public
      table holds up to March 2026. An address nobody called, or one whose signed function was last used years ago,
      is where to start asking whether the claim still applies. A recovery shows which address came back, not that
      the contract accepted it: a wrong signature recovers a random address. **Leads**: cite a transaction only after
      reading it.
    - `notes`: where the tool and the study's tables disagree, and other things to settle first.
    - `copies`: other addresses that run the same code; their state can differ from this address's. `dependents`:
      addresses whose code holds this address as a constant or calls it.
  - `source/<address>/…`: verified source of the address and of the code it runs. `decompiled.sol`: a decompiler's
    reading of unverified code; it can be wrong, treat it as a lead.
- The rules: `AGENTS.md` (the format, the severity rules, the checks), `patterns.md` (PQ-14 to
  PQ-21 for the EIP-8151 study), `studies/eip-8151-impact/README.md` (what the change does), and the filled examples
  in `templates/examples/findings/`. Read them before you write.

## What EIP-8151 changes, in two lines

`ecrecover` returns nothing when the recovered account has real code (an EIP-7702 delegation still recovers), and a
recovery costs up to 6,100 gas instead of 3,000. So a contract that trusts a recovered address stops accepting
signatures of accounts that moved to code, and a call that gives the precompile a fixed 3,000 gas fails for everyone.

## Which root issue it is

Decide from the code what the recovered address is compared with, and what happens when the comparison fails.

| What the code does | Root issue | Pattern | Rated? |
|---|---|---|---|
| Gives the precompile a constant amount of gas below 6,100 | `fixed-gas-recovery` | PQ-14 | Yes |
| Checks on chain a signature another party already holds and acted on (voucher, channel state, DKG result, fraud proof), unless the signer can already take that back without migrating | `signature-rechecked` | PQ-15 | Yes |
| A real transaction fails only because of the sender's own gas limit | `sender-gas-limits` | PQ-18 | Yes, LOW |
| Releases a party's funds or rights only on that party's own signature | `own-signature-only-exit` | PQ-16 | No |
| Trusts a stored key or set of keys that a function can replace | `rotate-signer-before-migrating` | PQ-17 | No |
| Trusts a key that only a code upgrade can replace | `signer-upgrade-only` | PQ-17 | No |
| Trusts a key fixed in the code, with no way to replace it | `fixed-signer` (a wallet's owners: `wallets-fixed-signers`) | PQ-17 | No |
| Lets a user act by signature or by a direct call (permit, signed order, relayed call) | `signed-shortcut-lost` | PQ-19 | No |
| Account logic that accepts only the account's own key | `7702-own-key-only` | PQ-20 | No |
| Lets an account enter or register only with its own signature | `entry-by-own-signature-only` | PQ-21 | No |
| A wallet whose owners are ECDSA keys a quantum computer could forge (no EIP-8151 effect; a lead from a wallet's migration notice) | `wallet-owner-keys` | PQ-12 | Yes, by the `quantum-exposure` table |

"No" means a migration notice: severity `INFORMATIONAL`, and the action says what the key holder does **before**
moving its account to code. The rated ones follow the table in `AGENTS.md`, "Categories of a protocol
change". The row's old root issue may be wrong: use the one the code shows. When more than one row fits,
`patterns.md`, "Choosing between patterns", decides; a pattern is its In words line and description, and its
Detection notes are search hints. A row from the first study (key `first/…`) keeps its `quantum-exposure` pattern
(PQ-1 to PQ-13) and is rated by that category's table.

## Three possible verdicts

1. `finding`: the contract is affected and you can show it.
2. `not-affected`: you can show it is **not**, with a disproof that a check re-runs. Ways rows have turned out not
   affected: no recovery is reachable at all; a signer with code is asked through ERC-1271; the address is
   implementation code that only proxies use, and was never initialized itself; the key is unset; the path is closed
   for good. Each of these has also been claimed wrongly: one contract removed for "no call to the precompile"
   recovered signers in real transactions. If `scan.window` or `scan.recovered` shows recoveries, the code recovers.
3. `question`: you cannot settle it. Say exactly what is missing. This is a good answer; a guess is not.

## How to work

1. Read the dossier's `notes` first, then the code that runs (the implementation, if it is a proxy).
2. Find the recovery and follow the recovered address: what is it compared with (a stored value, a constant, the
   caller, the account itself, an argument)? Where is that value set? What does the function do when it matches?
3. Test the claim against the chain at block 26,438,999, through the gateway only:
   `cast call ADDR 'signer()(address)' --block 26438999 --rpc-url $ETH_RPC_URL`, `cast storage`, `cast code`. The
   gateway refuses `latest`, traces and wide log scans; you do not need them. Use no other node address.
4. Try to disprove your own finding before you write it: run through `… -m review.refute --list`.
5. Write the draft, run `submit`, fix what it reports, until it prints `ACCEPTED`.

Never: start other agents; guess a fact, an owner, a project or a value; change a fact the tool read (if you think
it is wrong, state yours under `facts` with the check that shows it); write anything outside `W/out/<address>-<issue>/`.

If `W/out/<address>-<issue>/feedback.md` exists, this row was sent back: read it first. It lists what a refuter and
the reader found wrong in an earlier draft. Fix exactly those points, check each one yourself (the refuter can be
wrong too), and keep what was not disputed.

## The draft: `W/out/<address>-<issue>/draft.json`

You write judgment and checks. The tool writes the finding file from the dossier's facts and your draft.

```json
{
 "verdict": "finding",
 "pattern": "PQ-17",
 "issue": "rotate-signer-before-migrating",
 "severity": "INFORMATIONAL",
 "impact": "liveness",
 "evidence_level": "source",
 "title": "Celer bridge signers must rotate their keys before moving to real code",
 "justification": {"text": "Works until a signer moves to real code; the other signers can then replace that key.", "checks": ["ecdsa", "rotate"]},
 "whose": {"value": "users", "checks": ["ecdsa"]},
 "action": {"text": "Replace any signer key with updateSigners before moving that signer's account to real code.", "checks": ["rotate"]},
 "what": [
  {"text": "Celer's bridge releases transfers when signers holding two thirds of the voting power sign with ECDSA.", "checks": ["ecdsa", "quorum"]},
  {"text": "A signer that moves its account to real code stops counting; an EIP-7702 delegation keeps working.", "checks": ["ecdsa"]}
 ],
 "evidence": [
  {"text": "[verifySigs](https://etherscan.io/address/0x5427fefa711eff984124bfbb1ab6fbf5e3da1820#code) recovers each signature with ECDSA and requires two thirds of the power plus one.", "checks": ["ecdsa", "quorum"]}
 ],
 "facts": {"project": "celer-network", "label": "Celer Network: cBridge V2"},
 "mechanism": "verifySigs (Signers.sol, lines 96-123) recovers every signature with ECDSA, adds the power of those in the stored set and requires two thirds of the total plus one. updateSigners installs a new set when the current quorum signs it.",
 "ruled_out": ["an ERC-1271 path for signers with code: verifySigs has none (lines 96-123)."],
 "questions": [],
 "checks": [
  {"id": "ecdsa", "source": "0x5427fefa711eff984124bfbb1ab6fbf5e3da1820", "file": "contracts/Signers.sol", "line": 106, "has": "address signer = _hash.recover(_sigs[i]);", "says": "each signature is recovered with ECDSA and matched against the signer list"},
  {"id": "quorum", "source": "0x5427fefa711eff984124bfbb1ab6fbf5e3da1820", "file": "contracts/Signers.sol", "line": 100, "has": "uint256 quorum = (totalPower * 2) / 3 + 1;", "says": "the signers that sign must hold two thirds of the power plus one"},
  {"id": "rotate", "source": "0x5427fefa711eff984124bfbb1ab6fbf5e3da1820", "file": "contracts/Signers.sol", "lines": [51, 60], "has": "function updateSigners(", "says": "updateSigners installs a new signer set approved by the current one"}
 ]
}
```

- `what`: one entry per sentence of What happens (300 characters in all): what the contract does, where it trusts
  the signature, what goes wrong. `evidence`: one to three bullets (200 characters each), each with a link: the
  contract's code page, or a transaction (`https://etherscan.io/tx/0x…`).
- **Every sentence, bullet, the justification, the action and `whose` name the checks that back them.** The check
  kinds are in `AGENTS.md`, "Checks": `source` (text at lines of the verified source), `call`, `storage`,
  `code`, `bytecode`, `selector`, `tx`, `nonce`, `logs`, `replay` (a transaction and run listed in the dossier's
  `scan.families.*.replays`), `ref`. Leave `for` out; the tool fills it. Reads are at block 26,438,999 unless the
  check has `at`. An ETH balance is a `call` to Multicall3 `0xcA11bde05977b3631167028862bE2a173976CA11`,
  `getEthBalance(address)`; a token balance, the token's `balanceOf(address)`.
- A check proves a fact, not your sentence. For each sentence ask: could every check pass and the sentence still be
  false? A function that exists is not a function that does what you say: cite the lines that do it. "The owner can
  replace the key" needs the setter's lines **and** who the owner is at the block: a zero or dead owner means nobody
  can call an owner-only setter.
- A sentence no check can back is not written. Move it to `questions`, or drop it.
- `facts`: only to add `project` (a slug, only when verified source, the chain or the team shows it; otherwise leave
  it out) and `label` (an explorer's public tag, as a lead), or to state `proxy_of`, `upgradeable`, `admin` or
  `name` where the tool read nothing or something else: `{"value": …, "checks": [ids]}`.
- `whose`: `users`, `operator` or `mixed`, with the check that shows it; `null` if you cannot show it.
- `action`: one line for the contract's team, starting with a verb; `null` if you are not sure.
- `evidence_level`: `source` (verified source), `bytecode` (unverified code: the finding stays a candidate),
  `executed` (a replay or a simulation shows it), `onchain`, `trace`. Set `"used_decompiled": true` if you judged
  from `decompiled.sol`.
- `mechanism` (up to 1,500 characters): the path through the code, for a reviewer. `ruled_out`: what you tried in
  order to disprove it and what you saw.
- The card is for someone who does not know the study: plain English, short sentences, present tense, this contract
  only, no pattern codes, no file names, no "CHECKED", no tool names, no hedging.
- **Words that claim everything** are where cards have been wrong: "only", "nobody", "every", "must", "no other
  way", "works". Before you write one, look for the exception: an owner function that does the same without a
  signature, a direct call from the key's own address, a second path. If there is one, say it.
- **Say the state at the block.** If the contract is paused, its sale closed, its signer unset, its feed retired or
  its cap reached, the card says so, and does not speak as if it were running. A dormant contract that a live owner
  could restart is still a finding: the card states the dormancy. A path is closed for good, and the contract not
  affected, only when no function and no live key can open it again (`patterns.md`, "Choosing between patterns").
- **One card describes one address in use.** If this row's own address is not in use (an implementation never
  initialized or used alone, a retired copy) while copies of its code are, the verdict is `not-affected`: the disproof
  says the code is not in use here, backed by checks, and names the copies in use (the reader adds each as a row).
  If this address is in use, the card is about it alone: the header facts are its own, and other copies go in
  `ruled_out`.
- **Say "real code", never just "code".** EIP-8151 still recovers an account that holds an EIP-7702 delegation, and
  many users have one. "Holders with code lose permit" misleads them; write "holders whose accounts take real code",
  and where a reader could worry, add that an EIP-7702 delegation keeps working. The same in the title.
- **Address the action to whoever holds the key.** If the source, a comment, or the chain shows the key is someone
  else's (an oracle service, a relayer, the users themselves), say what the team can do about that party; do not
  ask the team to manage a key it does not hold. If you cannot tell who holds it, leave the action empty.
- **When the contract holds nothing, say who relies on it** if a check shows it (a vault that reads this price, the
  buyers of a sale, accounts that registered a key), so that a reader can tell whose money or service is at stake.
- **A notice can sit beside a rated issue on the same contract** (for example a real transaction that fails under
  the change on its sender's gas limit). Do not fold it into the notice; name it in `ruled_out`, and the reader
  links the two findings.
- **A replay is evidence about this contract only if this contract's own check is what fails.** Two cards cited a
  real transaction that bundled other signed steps (a CoW settlement whose order the same account signed; a
  multicall whose first call went through the user's own wallet). Code at the signer broke those other steps too,
  so the revert proved nothing about this contract. Before you cite a replay, read the transaction's calls: check
  that it reaches this address or its code at all (a family's replays once belonged to an unrelated proxy that only
  shared a 4-byte selector), and if any other step checks the same signer, do not cite it, and set `evidence_level`
  to `source`.
- **Oraclize (Provable) callbacks:** the oracle's two known callback senders have sent nothing since January 2022.
  Back it with `nonce` checks using `at`: `0x26588a9301b0428d95e6fc3a5024fce8bec12d51` is at 584,553 at blocks
  12,000,000 and 26,438,999; `0x000042425e06b0B1E8E20A811C91D6864608324B` is at 63,418 at block 13,000,000
  (2021-08-10), 63,426 at block 14,000,000 (2022-01-13) and 63,426 at block 26,438,999. A sender nobody can list may
  still exist (the connector's list needs logs), so never claim there is none. A contract that waits on its
  callbacks is still a finding: say in What happens that the oracle's known senders have sent nothing since January
  2022, beside the code fault.
- **Impact when the only ETH exit is a 2,300-gas transfer** (`transfer`, `send`) and the other paths need the
  holder's signature: `funds-locked`, and the card adds "unless the new code accepts a 2,300-gas transfer".
- **A fact only event logs show** (who holds a role, which prover or app is enabled, what points at this address):
  you cannot read logs. Put the exact question in `questions`; the reader reads the logs and answers in
  `feedback.md` with a check you can cite.
- **A gas amount fixed in the code with no update path is CRITICAL** whatever the contract holds or locks today;
  with an update path it is LOW. Show which case it is from the bytecode and the upgrade path.
- **Ratings to keep consistent:** a team multisig or one known operator changing a setting is LOW; a wallet is rated
  as one wallet, never as its family. A key holder that must move its own account to code before anything breaks is
  a migration notice (INFORMATIONAL), whatever it would lock.
- **A sender-gas-limits action** tells whoever sets the gas limit to re-estimate it under EIP-8151. Give a number only
  from the replay: the gas the `eip8151_more_gas` run used minus what the `today` run used (the dossier records
  both), as what this transaction used more, and how far above its limit that is. Never a flat figure per signature,
  and do not divide the difference by the signature count: call layers and memory add an unmeasured share (a relay
  with 13 guardian signatures used about 48,700 more, above 13 x 3,100).
  "More gas fixes it" needs a `replay` check of run `eip8151_more_gas` when the dossier lists one (or
  `eip8151_more_gas_1m`, 1,000,000 more, for a transaction with about a hundred recoveries, where 300,000 is not
  enough); otherwise say it rests on the code forwarding all gas, and keep the card a candidate.
- **A sender-gas-limits card belongs to the contract the failing transaction calls**, whose senders set its gas
  limit. If the only failing transaction is another account's (a relayer calling USDC for a signer whose account runs
  this code), that contract gets the card; a wallet or account row then proposes `not-affected` unless a transaction
  of this address's own fails at its sender's limit. Code that forwards all gas to the recovery fixes no gas amount
  itself. A replay that fails under EIP-8151 alone and that you do not cite: name it in `ruled_out`.
- **A first-study permit or authorisation card (PQ-1, PQ-2)** says what this contract adds: a holder who moves to
  post-quantum authorisation at the same address is still drained through the signed path, because it never asks
  the account itself (a stolen key alone would move the tokens anyway). The fix it names stops accepting ECDSA for
  owners whose accounts have code and asks them through ERC-1271 only; "also accept ERC-1271" leaves the hole open.
  The money is the token's supply (basis market-cap), which the tool computes for priced tokens and Aave aTokens.
- **A Safe multisig card (PQ-12):** Safe 1.1.1, 1.3.0 and 1.4.1 ask an owner that is a contract through the legacy
  `isValidSignature(bytes,bytes)` (magic `0x20c13b0b`); the final ERC-1271 selector `0x1626ba7e` is absent from
  those singletons (1.5.0 asks the final one), so a signer contract that answers only final ERC-1271 does not count
  and could drop the Safe below its threshold. Read the version (`VERSION()`), check both selectors on the singleton,
  and name in the action the interface this Safe really asks. Swapping the singleton alone (`changeMasterCopy`) is
  not a fix: the ECDSA owners stay. An owner that upgrades its own account in place stays forgeable: the Safe recovers
  its address, never asks it.
- **A Safe owner's migration notice is PQ-19 (`signed-shortcut-lost`), not PQ-17:** an owner whose account takes real
  code loses only its off-chain ECDSA signature; it still approves on-chain (`approveHash`, or by sending the
  transaction itself), so the Safe does not refuse it.
- **A fault someone could use today** (a replay across wallets, a missing check that lets anyone take funds now) is
  not this review's output. Do not write it in the draft, the card or your message, and do not investigate it
  further; say only "a fault usable today needs the owner's attention" in your final message, and the reader tells
  the owner privately.

`not-affected`: `{"verdict": "not-affected", "disproof": {"text": "…", "checks": [ids]}, "checks": […]}`.
`question`: `{"verdict": "question", "questions": ["…"], "checks": […]}`.

## Submit

```
uv run --quiet --with pyyaml --with eth-abi --with pycryptodome python -m review.submit 'KEY' --who NAME --dry   # check only
uv run --quiet --with pyyaml --with eth-abi --with pycryptodome python -m review.submit 'KEY' --who NAME         # accept
```

It runs every check, writes the finding from the tool's facts and your draft, and runs the registry's format rules.
You are done when it prints `ACCEPTED`. Your last message: that line, your verdict in one sentence, and anything you
want the reader to look at.
