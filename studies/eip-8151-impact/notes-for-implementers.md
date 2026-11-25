# EIP-8151: notes for implementers outside contracts

Under EIP-8151, `ecrecover` gives a different answer for the same input once the recovered address holds real code.
The systems below rely on the opposite: an answer that is a pure function of `(hash, v, r, s)`, the same on every
chain and at any time. They have no contract address of their own, so the registry cannot hold them as cards. The
contracts where the effect lands on chain have cards (patterns PQ-22 and PQ-23). Every link is pinned to a commit.
Checked on 2026-11-25.

## 1. ERC-4337 and ERC-7562: one code change voids many pending operations

**What the rules assume.**
- ERC-7562 allows precompiles during validation only because they read no state. [OP-062](https://github.com/ethereum/ERCs/blob/63e961eda74ecb84dc224473452821eddbb451c2/ERCS/erc-7562.md?plain=1#L204-L206):
  "Only known, accepted precompiles on the network that do not access anything in the blockchain state or environment
  are allowed."
- ERC-7562 bounds mass invalidation by limiting which storage validation may read. Its rationale names the attack
  itself: front-running valid operations with an economically viable state change that invalidates them.

**What bundlers do.** They hard-code the rule: Alto
([`isAllowedPrecompiled`](https://github.com/pimlicolabs/alto/blob/a30e96b40e4fea65b59151649056552f40676fe1/src/rpc/validation/BundlerCollectorTracerV07.ts#L310-L317))
and Rundler
([tracer](https://github.com/alchemyplatform/rundler/blob/b8b7642f14e66c56ba6107d3191bad31ffacdf7c/crates/sim/tracer/src/validationTracerV0_7.ts#L340-L349))
let `0x01` through without tracking anything. The reference bundler, Stackup and Voltaire use the same tracer.
Reputation is kept only for the entities a UserOperation names (factory, paymaster, aggregator, staked account). A
signer that validation recovers is none of these.

**What changes under EIP-8151.**
- A UserOperation's validity depends on the code of whatever address its signature recovers to. That address is
  outside the operation's storage, and no rule tracks it.
- One transaction that gives a shared signer real code invalidates every pending operation that depends on it, and
  nobody is charged. The signer can be the owner of many accounts, a paymaster's signer, or an attacker's key that
  many attacker accounts recover.
- The entry point checks validation again on chain and reverts the whole bundle on the first failure. A code change
  landed between a bundler's last simulation and its bundle therefore costs the bundler the whole bundle's gas.
- EIP-8151's own mempool rules (signer dependencies, pending limits, the canonical paymaster signer) cover only
  EIP-8141 frame transactions
  ([text](https://github.com/ethereum/EIPs/blob/ade9e9cab7e148bba4cd293f916a4a189cd7a8aa/EIPS/eip-8151.md?plain=1#L66)).

**Measured and executed** (study block range 26,339,000 to 26,438,999):
- Validation recovered 153,474 distinct signers: 434,633 recoveries in account validation and 307,842 in paymaster
  validation.
- 60 paymasters recover one signer each. One paymaster signer was recovered 215,822 times in 14 days, across three
  paymasters.
- Real bundles were replayed on the study's fork engine three ways: today, under EIP-8151 with code at a signer that
  their operations recover, and with a 7702 delegation there. Every bundle passes today and with the delegation; with
  code at the signer, every one reverts whole.

| Entry point | Bundle | Operations recovering the signer | With code at the signer |
|---|---|---|---|
| v0.6 | `0xce9afa8f…` | 8 (a paymaster's signer) | reverts after 127,875 gas |
| v0.7 | `0x8843c889…` | 5 (a paymaster's signer) | reverts after 214,362 gas |
| v0.8 | `0xca4949f1…` | 10 (a paymaster's signer) | reverts after 290,490 gas |
| v0.9 | `0xe1247287…` | 1 (a paymaster's signer) | reverts after 94,101 gas |

**What ERC-7562 would need:**
- record every address whose code a validation-phase precompile reads, as a dependency of the operation;
- re-validate when that address's code class changes;
- cap how many pending operations may share one recovered address, as EIP-8151 does for frame transactions;
- give tracers a way to see that read. Opcode-level tracers cannot see inside a precompile, so the client has to
  report it.

## 2. Clients: precompile result caches keyed by input

- go-ethereum opts `ecrecover` into its precompile result cache, keyed by the normalized input
  ([`Cacheable() = true`](https://github.com/ethereum/go-ethereum/blob/bbafd66b66f5e37e877bf1efe3506ad74a6eda98/core/vm/contracts.go#L346)).
- Erigon ([#25037](https://github.com/erigontech/erigon/pull/25037), merged) and ethrex
  ([#6249](https://github.com/lambdaclass/ethrex/pull/6249) merged, [#7308](https://github.com/lambdaclass/ethrex/issues/7308))
  added caches of the same kind.
- A cached recovery goes stale the moment the recovered address takes code.
- Nethermind applies the code check after the cached pure result, so its cache cannot go stale. It also records the
  recovered address as an EIP-7928 account read ([#13959](https://github.com/NethermindEth/nethermind/pull/13959),
  merged).
- Block access lists and stateless witnesses must carry that read even when the output does not change.

## 3. zkVM provers of L1

The standard accelerator interface takes the message, the signature and the recovery id, and returns a public key. It
has no state parameter
([`zkvm_secp256k1_ecrecover`](https://github.com/eth-act/zkvm-standards/blob/f433d48d56e8a454a06c24f6c8a02f7156d9bfe1/standards/c-interface-accelerators/zkvm_accelerators.h#L207-L210)).
A guest that proves L1 has to apply the code check itself, from its witness; otherwise its proofs diverge from L1.

## 4. SDKs and off-chain verifiers

Libraries recover signers locally (viem, ethers, alloy, eth-account). "Valid off chain" therefore no longer predicts
"valid on chain" for an address with code. Relayers, solvers and order books that check a signature once and rely
on it later inherit the same gap.

## 5. Formal and symbolic tools

Solidity's SMTChecker abstracts `ecrecover` as an uninterpreted function of its arguments
([docs](https://github.com/argotorg/solidity/blob/2c85e1d212501476c492766764f78c55f5bb25c8/docs/smtchecker.rst?plain=1#L939-L942)).
Under EIP-8151 that model is not sound for properties that depend on the signer's code.

## 6. Chains that adopt the rule at different times

A chain that copies L1's EVM on its own schedule answers the same signature differently until it adopts the rule.
That matters for signatures verified on several chains, and for any system that answers one chain's `ecrecover` with
another chain's precompile. OP Stack fault proofs do exactly that: see the PQ-22 cards.
