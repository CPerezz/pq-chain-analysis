# Refuter: try to prove one card wrong

An author has written what this registry will say about **one** contract, or has proposed to remove it as not
affected. Your job is to prove the author wrong. You are not here to confirm: findings of this study were confirmed
in bulk before, and many were wrong. If you cannot break it after really trying, say so; that is the result that lets
it be published. A wrong card that you let through is the failure.

## What you are given

- `KEY`: `<root issue>|<address>`. `W` = `review/work` (paths below are from the registry's root).
- `W/out/<address>-<issue>/refuter_input.md`: the card as a reader sees it, its sentences, the checks the author
  ran with their results. **Read only this file from that folder.** Do not open `draft.json` or `finding.md`: the
  author's reasoning must not guide you.
- The dossier, `W/dossier/<address>-<issue>/`: `dossier.json` (`facts` read by a tool at block 26,438,999;
  `scan`, leads from the study's tables, never verdicts; `signers`; `use`; `notes`; `row`, the old claim,
  untrusted; `copies`, other addresses running the same code, whose state can differ; `dependents`, addresses whose
  code holds or calls this one), `source/…` (verified source), `decompiled.sol` (a decompiler's reading: a lead, it
  can be wrong).
- The rules: `findings/README.md` (format, severity, checks), `patterns.md`, `studies/eip-8151-impact/README.md`.

The change the study is about: `ecrecover` returns nothing when the recovered account has real code (an EIP-7702
delegation still recovers), and a recovery costs up to 6,100 gas instead of 3,000.

## Steps, in this order

1. **Cold read.** Open `refuter_input.md`, read only its first section (the card), and write down, before you look
   at anything else: what is wrong with this contract; how bad it is; whose money is at stake; what its team can do.
   If the card does not let you answer one of them, say so: that is a defect of the card. (A removal has no card:
   skip this step.)
2. **Read the code that runs** (the implementation, if the address is a proxy) and form your own view of what the
   recovered address is compared with and what follows.
3. **Judge every part**: each sentence of What happens (`what-1`, `what-2`, …), each Evidence bullet
   (`evidence-1`, …), `title`, `justification`, `severity`, `pattern`, `action`, `whose`, and `facts` if the author
   states any. For each: does it hold, and what did you read that says so? The question is never "does the check
   pass" (it does), but "could the check pass and the sentence still be false?" A function that exists is not a
   function that does what the card says.
4. **Make every attempt of the list**: `… -m review.refute --list`. Each is a way findings, or removals, of this
   study have been wrong. For each one:
   - `does-not-apply`, with the reason;
   - `tried-holds`: you tried and the card survives, with the check that shows it;
   - `refutes`: the card is wrong here, with what you saw;
   - `could-not-check`, with what would be needed.
5. **Verdict**: `agree` only if every part holds and no attempt refutes or stays unchecked; `disagree` if anything
   is wrong (say what the card should say instead); `unsure` if something could not be checked.

Node reads only through the gateway, at the pinned block: `cast call ADDR 'owner()(address)' --block 26438999
--rpc-url $ETH_RPC_URL` (also `cast storage`, `cast code`). It refuses `latest`, traces and wide log scans. Never
start other agents. Never guess: an attempt you could not make is `could-not-check`. Write nothing outside
`W/out/<address>-<issue>/refute.json`. An ETH balance is a `call` check: Multicall3
`0xcA11bde05977b3631167028862bE2a173976CA11`, `getEthBalance(address)`; a token balance, the token's
`balanceOf(address)`. A `replay` check cites only runs the dossier lists under `scan.families.*.replays`: you cannot
run the fork engine, and refuters have drafted replay results they never ran; the tool refuses them.

Rules the cards follow: one card describes one address in use, so a card about a copy other than this address, or
header facts of an unused implementation, is wrong. A dormant contract that a live owner could restart stays a notice
that states the dormancy. An Oraclize-dependent card must say the oracle has looked silent since early 2022. When the
only ETH exit is a 2,300-gas transfer, impact is `funds-locked`. A team multisig changing a setting is LOW; a wallet
is rated alone, never as its family. When the dossier's `scan.implementation_of` is empty, no proxy in the study's
table points at this address, and the `proxies` attempt may be `tried-holds` on that alone (say so in its note; no
check needed). A PQ-1 or PQ-2 fix must stop accepting ECDSA for owners whose accounts have code; reordering the checks
or "also accepting ERC-1271" is not a fix. An owner-only setter does nothing when the owner is zero or dead.

## Your answer: `W/out/<address>-<issue>/refute.json`

```json
{
 "cold_read": {"what_is_wrong": "…", "how_bad": "…", "whose_money": "…", "what_can_the_team_do": "…"},
 "parts": [
  {"part": "what-1", "holds": true, "why": "Signers.sol lines 96-123: each signature is recovered and its power added", "checks": []},
  {"part": "action", "holds": false, "why": "updateSigners needs the current quorum; a signer cannot rotate alone", "checks": ["quorum-needed"]}
 ],
 "attempts": {
  "erc1271": {"result": "tried-holds", "note": "no isValidSignature call anywhere in Signers.sol or Bridge.sol", "checks": ["no-1271"]},
  "unused-implementation": {"result": "does-not-apply", "note": "the address holds the funds itself; no proxy points to it"}
 },
 "verdict": "disagree",
 "objections": ["action: one signer cannot replace its own key; the card should say the signer set does it"],
 "checks": [
  {"id": "no-1271", "bytecode": "0x5427fefa711eff984124bfbb1ab6fbf5e3da1820", "has": "1626ba7e", "absent": true, "says": "the ERC-1271 selector is not in the code"}
 ]
}
```

Checks have the same kinds as the author's (`findings/README.md`, "Checks"); they are run, and must give what they
state. An attempt marked `tried-holds` names the check that shows it.

```
uv run --quiet --with pyyaml --with eth-abi --with pycryptodome python -m review.refute 'KEY' --who NAME --dry
uv run --quiet --with pyyaml --with eth-abi --with pycryptodome python -m review.refute 'KEY' --who NAME
```

You are done when it prints `ACCEPTED`. Your last message: that line, your verdict, and your objections.
