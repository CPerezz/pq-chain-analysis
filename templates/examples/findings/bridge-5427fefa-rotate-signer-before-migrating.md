---
id: bridge-5427fefa-rotate-signer-before-migrating
format: 2
title: Bridge stops relaying if its signers move their accounts to code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless signers move their accounts to code, and they can rotate their keys first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: "0x5427fefa711eff984124bfbb1ab6fbf5e3da1820"
  name: Bridge
  project:
  label: "Celer Network: cBridge V2"
  code: verified
  code_url: https://etherscan.io/address/0x5427fefa711eff984124bfbb1ab6fbf5e3da1820#code
  proxy_of:
  copies: 5
  family: f3969f727e902e067e61f557b2769805
  upgradeable: "no"
  admin: "0xf380166f8490f24af32bf47d1aa217fba62b6575"
value:
  usd: 1488582
  whose: users
  basis: held
activity:
  txs_90d: 4379
  last: 2026-11-18
impact: liveness
action: Replace any signer key with updateSigners before moving that signer's account to code.
evidence_level: source
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: Claude, reviewer assigned by Anon
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: signer set replaced by updateSigners or reset by the owner
related: []
---

## What happens

Transfers out of this bridge need ECDSA signatures from signers holding two thirds of its voting power. If signers
holding more than a third move their accounts to code without rotating, relays and withdrawals stop until the owner
resets the signer set after a 7-day notice.

## Evidence

- The [verified source](https://etherscan.io/address/0x5427fefa711eff984124bfbb1ab6fbf5e3da1820#code) checks each
  signature with ECDSA against the signer list and needs two thirds of the power plus one.
- `updateSigners` replaces the set with the current signers' signatures; the
  [owner](https://etherscan.io/address/0xf380166f8490f24af32bf47d1aa217fba62b6575) can reset it after a 7-day notice.

## Reviewer notes

### Mechanism

`verifySigs` takes the signers in ascending order, recovers each signature with ECDSA and sums the power of the
matched signers, which must exceed two thirds. `updateSigners` installs a new set signed by the current one;
`notifyResetSigners` then `resetSigners` (both `onlyOwner`) replace the set after `noticePeriod`.

### Checks

- Block 26,438,999: not a proxy; owner 0xf380…6575 is a 10,262-byte contract, not identified; `noticePeriod` is
  604,800 seconds; `resetTime` is unset, so no reset is pending.
- Value and activity cover the 5 addresses that run this code; 522 signature recoveries in the study's two-week window.
- The verified source does not name its project; the label is the explorer's tag.

### History

- 2026-11-19: reported as a row of the rotation root issue (study eip-8151-impact).
- 2026-11-20: reviewed, LOW; INFORMATIONAL under the severity boundary decided that day.
