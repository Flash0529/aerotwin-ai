# Pardhu: run on the presenting laptop (real NASA data)

The build sandbox cannot download the NASA C-MAPSS files (host `huggingface.co` is blocked), so this run must happen on a laptop with internet.

```
git checkout main && git pull
make setup
make data           # downloads data/cmapss/ (needs internet)
make api            # leave running; GET http://localhost:8000/health must show all six modules "real"
make demo-check     # second terminal; expect 16/16
python scripts/plan_demo.py
```

## Reading the result
* 16/16: good. Quote only the numbers printed by this run (Planning page risk card, or `plan_demo.py`).
* 14/16 with "Agents: plan feasible" and "Replan: plan changed" failing, and `RUL p10/p50/p90 = 0/4/10.8`: the NASA files were not found (synthetic fallback). Re-run `make data`.
* Any other failure: send the full output to the team chat.

## Fallback if the live API misbehaves at the table
`python scripts/plan_demo.py` needs no API and no NASA files; it prints the baseline vs optimized table, the risk view, the replan and the simulation on the stated stand-in fleet (say "simulated stand-in" out loud), and the recorded backup video shows the full UI.
