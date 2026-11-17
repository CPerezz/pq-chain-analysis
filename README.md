# pq-chain-analysis

How many Ethereum mainnet contracts rely on pre-quantum cryptography (ecrecover, elliptic curves incl. precompiles, RSA; plus a scan for lattice verifiers), whether they can change, whether they have an alternative path, and how much value goes through them.

**Findings registry: [`generated/INDEX.md`](generated/INDEX.md)** — one markdown file per affected project and mechanism in [`findings/`](findings/), each with a severity, the contracts, who can fix it, value at risk and evidence. Narrative: [REPORT.md](REPORT.md). Check any address: **https://kevaundray.github.io/pq-chain-analysis/**

| Path | Content |
|---|---|
| `findings/` | One file per finding. Threat model, fields and the severity rubric: [`findings/README.md`](findings/README.md) |
| `patterns.md` | The ways contracts depend on pre-quantum cryptography (`PQ-1` … `PQ-12`) |
| `evidence/<id>/` | Per finding: the classification, on-chain state (proxy, admin, holdings, at a block), 30-day activity, and verified-source excerpts of the checks |
| `generated/` | `INDEX.md`, `findings.csv`, `contracts.csv`, built by `tools/build.py` |
| `templates/finding.md` | Blank finding |
| `REPORT.md` | The census report |
| `data/report/*.csv` | Report tables; `curated_contracts.csv` is the per-contract classification of the 433 largest callers |
| `data/curation/` | Raw per-contract classifications (`out_*.jsonl`) and their grouping into findings (`findings_map.csv`) |
| `docs/` | GitHub Pages site: `index.html`, `data.json` (from `scripts/10_site_data.py`), and `lookup/` — a per-address index of every contract seen using pre-quantum crypto, sharded by address prefix (from `scripts/11_lookup_index.py`). The page also reads each looked-up address's current code from a public RPC in the browser |
| `research/pq-research.md` | PQ verifier landscape, EIP status, replacement options and gas costs, with sources |
| `scripts/` | Pipeline |

## Working on findings

Edit or add `findings/<id>.md` (copy `templates/finding.md`), keep evidence under `evidence/<id>/`, then run
`python3 tools/build.py` until it prints `OK` and commit `generated/` with it. `tools/build.py --check` validates without
writing and fails if `generated/` is stale.

## Reproducing

Requires Python 3.13, `duckdb pyarrow pandas requests`, and a mainnet RPC that supports `eth_call` state overrides (`ETH_RPC_URL`, default publicnode).

1. Get the [precompile-usage](https://s3-dcl1.ethquokkaops.io/evm-parquet/) parquet corpus (≈56 GB, produced by [precompile-tracer](https://github.com/CPerezz/precompile-tracer)). `scripts/01_precompile_agg.py` expects it in `~/work/xatu/precompile-usage/`.
2. Run, in order:
   ```
   python scripts/01_precompile_agg.py      # per-caller aggregates, modexp moduli
   python scripts/02_contracts_pass.py 0 17999 && python scripts/02_contracts_pass.py 18000 <head/1000>  # Xatu contracts
   python scripts/03_probe_callers.py       # code/balance at head
   python scripts/03b_caller_family.py      # code families
   python scripts/04_families.py            # proxy resolution, selectors, fingerprints
   python scripts/05_code_scan.py           # chain-wide bytecode fingerprint scan (EC / lattice)
   scripts/download_sample.sh && python scripts/06_value_flows.py   # 1-in-10 transfer sample, USD flows
   python scripts/blockscout.py address <list> ; python scripts/sourcify.py <list>  # labels, sources
   python scripts/07_classify.py            # rule-based role / mutability
   python scripts/08_holdings.py            # current holdings
   python scripts/09_report_tables.py       # data/report/*.csv
   python scripts/10_site_data.py           # docs/data.json for the site
   python scripts/11_lookup_index.py        # docs/lookup/ address index for the site's checker
   # findings registry; 12-14 are network- and data-heavy and run on a remote box (see below)
   python scripts/12_state.py               # on-chain state of the classified contracts -> data/state/
   python scripts/13_activity.py            # 30-day activity and last-active from Xatu -> data/activity/
   python scripts/14_excerpts.py            # verified-source excerpts of each check -> data/excerpts/
   python scripts/15_findings.py            # draft findings/<id>.md and evidence/<id>/ (never overwrites a finding)
   python tools/build.py                    # validate, build generated/
   python scripts/10_site_data.py           # again, so the site shows each contract's finding
   ```

Remote runs: scripts 12–14 read ~45 GB from Xatu and make thousands of RPC/Blockscout/Sourcify calls. They were run on a
96-core box with 60 MB/s to Xatu (about 200× this laptop): clone the repo there, `rsync` the derived `data/` files it
reads (`data/agg`, `data/sourcify`, `data/blockscout`, `data/state`), run the scripts under `tmux`, and `rsync` back
`data/{state,activity,excerpts}`. `data/activity/raw/` (the matched Xatu rows, several GB) can stay on the remote.

The curated classifications in `data/curation/` were produced by reading verified source and bytecode per contract; they are inputs, not regenerated by the scripts.
