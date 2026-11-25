# Area S: systems that reuse `ecrecover`'s answer outside the call that produced it

Such systems leave no trace on mainnet: the fault-proof oracles below have never received a transaction. The
population therefore comes from code and state, not from the traced window. All reads are on an archive node; nothing
is sent.

| File | What |
|---|---|
| `s1-check-at-block.txt` | The executed check, at block 26,438,999: one valid recovery loaded into each oracle in use, today, under EIP-8151, and under EIP-8151 with code at the signer (`scripts/s1_check.py`, `eth_simulateV1` with the behaviour wrapper at `0x01`) |
| `sweep-summary.json`, `sweep-keepers.csv` | Manufactured calls. The population is every code alive at the block with a `CALL`/`STATICCALL` to a target taken from calldata (and storage writes, or a static call whose failure is tolerated). Every function taking an address is called once per address argument, with that argument set to `0x01` and a valid recovery in every bytes argument. The recovered address is then followed into storage, logs, hashes, calls and the return data (`scripts/runner.py`). `sweep-keepers.csv` lists the codes where it reached storage, logs or a hash, with a class |
| `consumers-at-block.json`, `live-games.csv`, `oracles.csv` | Every dispute game factory on mainnet and what its games answer precompiles with (`scripts/consumers.py`, `scripts/consumers_h.py`): at the block, for chains that created games in the 90 days to it; and today, for chains with a game in the last 60 days. Every `PreimageOracle` deployment with its creation date |
| `escrow.json` | What a false root could release, per oracle in use at the block: each served chain's portal, ETH lockbox and standard bridge, valued as the registry values a card (`scripts/escrow.py`) |
| `aa-bundle-replays.jsonl`, `aa-paymasters.json` | ERC-4337: one real bundle per entry point, replayed on the study's fork engine today, with code at a signer its operations recover, and with a 7702 delegation there (`runs` is what `tools/verify.py --replays` reads); and every paymaster whose validation recovered a signer in the traced window |
| `inventory.csv` | 662 L2s, bridges, provers and other projects (L2BEAT, DefiLlama, dispute-game events, a manual list), each with a verification class and a verdict for L1 activation |
