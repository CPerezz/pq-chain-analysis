---
id: crossl2proverv2-95cceae7-fixed-signer
title: "CrossL2ProverV2: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x95cceae71605c5d97a0ac0ea13013b058729d075"
  family: "eec603a312c7d7fcc50f0a9ff0e128c3"
  copies: 2
  name: "CrossL2ProverV2"
  label: "Polymer: Prover"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 18802
  last_active: 2026-11-18
  recoveries_14d: 3935
fix:
  layer: new-deployment
  who_acts: "Polymer (deploy a new CrossL2ProverV2 with a new SEQUENCER) and LI.FI/OIF (deploy a new PolymerOracleMapped on that prover; order builders put it in order.inputOracle); holders of unfinalised orders call refund after order.expires"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path exists in the prover or the oracle (both immutable), so this is not LOW at these addresses. It is not HIGH either: the escrow refunds after expiry without a proof, and each order picks its oracle, so nothing is locked. Only proof delivery dies, which makes it MEDIUM. A solver who filled on the remote chain just before the break could lose reimbursement for that one order (its own risk). This could be argued LOW, since a new oracle needs no change to the settler, only a new deployment plus order-builder config."
---

## Summary

Polymer CrossL2ProverV2 checks that the sequencer signature recovers to the immutable SEQUENCER 0x4632…6209. If that address held non-7702 code, validateEvent/validateSolLogs would revert. The main dependant is LI.FI's PolymerOracleMapped 0x008c38…ee17 (OIF), which hard-codes this prover, so new cross-chain fill attestations on Ethereum stop. The escrow behind it still refunds without a proof.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Polymer CrossL2ProverV2: the signer must be SEQUENCER, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Prover: source line 'address public immutable SEQUENCER', set in the constructor, no setter, EIP-1967 slots empty; SEQUENCER() at 26438999 = 0x4632e987c6f31d6351e39324dec6f1404af56209 (no code, nonce 0). All 8 sample txs in txs.json traced with callTracer: 3930 of 3935 recoveries come via 0x008c38…ee17 receiveMessage (0xf953cec7) / receiveSolanaMessage (0x78af9972). The other 5 come via 0xec0ded08…3ed6 (unverified; heimdall shows provenIntents/challengeIntentProof, an Eco-style intent prover, with the prover address hard-coded)
- Dependant 0x008c38…ee17 (Sourcify: PolymerOracleMapped, OIF): 'ICrossL2ProverV2 internal immutable CROSS_L2_PROVER', not a proxy (EIP-1967 slots zero). Its owner (slot 0 = 0x712e9003…f45a, EOA, nonce 77) can only call setChainMap and transferOwnership, so the oracle cannot switch prover. It holds no funds: it only writes _attestations read through isProven/efficientRequireProven
- Value sits in InputSettlerEscrowLIFI 0x00fc00ed…223e (Sourcify match; holds 0.6257 WETH at 26438999, 0 USDC/USDT/ETH). Traced txs 0xda0d…40fa, 0xda2c…db3c and 0x0192…be06 show finalise staticcalling 0x008c38 efficientRequireProven (0xae0dd770) and then paying the solver in USDC, WETH or USDT. The oracle is read per order from order.inputOracle (InputSettlerBase _validateFills), so no allowlist pins this oracle
- InputSettlerEscrow.refund(order): anyone may call it once order.expires has passed; it calls _resolveLock(..., order.user, Refunded) and needs no proof. So escrowed inputs go back to the user without the prover; only finalise (solver reimbursement) needs the proof

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 18,802 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,935 signature recoveries in the study's two-week trace window.

## Remediation

Before the SEQUENCER address gets code, Polymer deploys a new CrossL2ProverV2 with a new signer, LI.FI deploys a new PolymerOracleMapped pointing at it, and new orders name that oracle. Orders still in flight are refunded after order.expires.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
