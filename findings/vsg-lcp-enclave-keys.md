---
id: vsg-lcp-enclave-keys
title: "VSG redeem bridge (Vector Smart Chain): a quantum attacker who recovers the SGX enclave key of LCP client 0x21fd9803 can forge redeem packets that release VsgBridgeAppV2's USDT (about USD 0.5k)"
project: vector-smart-chain
status: confirmed
severity: LOW
patterns: [PQ-5]
primitives: [ecrecover, rsa]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x21fd9803336f9800241122ee1e6bd1849f537549"
  implementation: null
  name: LCPClient
  upgradeable: "no"
  admin: none on the client; its IBC handler 0xb82d91d14e95d6b6364a85f1dfc7a9656341ea72 (OwnableIBCHandler, no proxy) and the app's ProxyAdmin 0x97c9d0855781646bbe7e144582dda7af7dee434d are owned by EOA 0x7b88f333935cd1d38893d15fe9d77e86447bda4e, read at block 26431590
  value_usd: 497
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-03-23
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: the bridge operator, EOA 0x7b88f333935cd1d38893d15fe9d77e86447bda4e (owner of handler 0xb82d91d1… and of the app's ProxyAdmin), deploys a client that verifies post-quantum enclave signatures and moves the redeem channel to it
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/vsg-lcp-enclave-keys/classification.jsonl
  - evidence/vsg-lcp-enclave-keys/onchain.json
  - evidence/vsg-lcp-enclave-keys/activity.json
  - evidence/vsg-lcp-enclave-keys/source-excerpts.md
  - evidence/vsg-lcp-enclave-keys/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: [datachain-lcp-enclave-keys]
---

## Summary

`LCPClient` `0x21fd9803…7549` is an IBC light client built from Datachain's LCP code: it accepts counterparty state
updates and packet proofs signed by secp256k1 keys generated in an SGX enclave, registered from an Intel attestation
report checked with RSA (PQ-5). It serves a USDC redeem bridge between Ethereum and a chain with `vsc1` addresses
("VSG Redeem Bridge (ETH -> VSC)"). A quantum attacker who recovers the enclave key can sign a false counterparty
state and prove redeem packets that make `VsgBridgeAppV2` pay out: 496.9 USDT (USD 497) at 2026-11-17. The client is
immutable; one operator EOA controls the handler and the app. Rated LOW: MEDIUM by step 4 (new deployment by one
operator), lowered one level by step 5 (under USD 50k measured).

## Mechanism

- `LCPClientBase.updateClient` (`@datachainlab/lcp-solidity/contracts/LCPClientBase.sol`) calls `verifySignatures`
  on `keccak256(proxy_message)`: with no operators one signature must recover (`verifyECDSASignature` →
  `ECDSA.recover`, lines 650–655) to an active enclave key; with operators, a threshold of operator-bound enclave
  keys. `verifyMembership` checks packet commitments with the same signatures.
- Enclave keys are registered from an Intel IAS attestation report verified with `RSAVerify` (ENS
  `ModexpPrecompile`, `modexp`); a recovered Intel signing key would also let an attacker register a fresh enclave key.
- The client is called only by handler `0xb82d91d1…` (`onlyIBC`); the handler routes `recvPacket` on port `redeem`
  to `VsgBridgeAppV2` `0x9cae1b2e…a588`, which releases tokens.
- Pattern PQ-5. Excerpts: [`source-excerpts.md`](../evidence/vsg-lcp-enclave-keys/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify): `LCPClient` `0x21fd9803…`, functions above; no proxy, no owner.
- CHECKED (Sourcify constructor arguments): `ibcHandler` = `0xb82d91d1…ea72` (`OwnableIBCHandler`, no proxy).
- CHECKED (on-chain reads at block 26,431,590): handler `owner()` = EOA `0x7b88f333…da4e` (nonce 7,758), which
  deployed the client, the handler and the app and relays packets; `getIBCModuleByPort("redeem")` = `0x9cae1b2e…a588`
  (ERC1967 proxy → `VsgBridgeAppV2` `0x1bfde5e5…842f`, ProxyAdmin `0x97c9d085…434d` owned by the same EOA), which
  holds 496,900,000 USDT units (496.9 USDT) ([`escrow.json`](../evidence/vsg-lcp-enclave-keys/escrow.json)).
- CHECKED (Blockscout logs of the handler): port `redeem`, channel-4 packets with ICS-20-style JSON, e.g.
  `{"denom":"uusdc","memo":"VSG Redeem Bridge (ETH -> VSC)","receiver":"vsc1…"}` and "Bridge from VSC to Ethereum";
  last handler transaction 2026-01-29.
- CHECKED (precompile trace to March 2026): 4,063 transactions with `ecrecover`/`modexp`/`sha256` (last block
  24,682,737); 5 with RSA.
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16; last 2026-03-23
  ([`activity.json`](../evidence/vsg-lcp-enclave-keys/activity.json)).
- INFERRED: "VSG" is Vector Smart Chain's native token (thirdweb lists Vector Smart Chain, chain ID 420042, with VSG
  as its currency), so the counterparty is Vector Smart Chain; no Vector Smart Chain document naming these contracts
  was found.

## Impact and exposure

| Contract | Upgradeable | Escrow (VsgBridgeAppV2) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x21fd9803…` LCPClient | no | USD 497 (2026-11-17) | 2026-03-23 | 0 |

- Escrow: `VsgBridgeAppV2` proxy `0x9cae1b2e…a588`, 496.9 USDT plus 190 micro-USDC and unpriced tokens. The client
  and handler hold nothing.
- `usd_tx_y1` (USD 1.36M) is the year's bridge flow, not funds at rest.
- Wider: the same operator EOA can upgrade the app and reassign the handler's port with its own ECDSA key.

## Remediation

- Post-quantum replacement: enclave keys that sign with a post-quantum scheme verified in a new client, attestation
  verified without RSA (for example a STARK of the DCAP check), or a hash-based ZK light client of the counterparty.
- Who must act: the operator EOA `0x7b88f333…da4e`: deploy the new client and connection through handler
  `0xb82d91d1…` (or a new handler) and point the app at it; moving the operator to a post-quantum account closes the
  upgrade-key path. Datachain maintains the LCP library. No protocol change needed.
- Users: do not leave funds waiting in the bridge app.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`), as part of
  `datachain-lcp-enclave-keys`.
- 2026-11-17: created by review (Review05), split from `datachain-lcp-enclave-keys` (MEDIUM there): `0x21fd9803…` is
  operated by EOA `0x7b88f333…` for a VSG/Vector Smart Chain redeem bridge, not by TOKI. Rated LOW, step 5: MEDIUM by
  step 4 (immutable client; new deployment by one operator), escrow USD 497 measured at block 26,431,590.
