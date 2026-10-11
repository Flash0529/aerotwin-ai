# Spoken scripts for the 3-minute pitch (one per teammate)

The whole team gets **3 minutes + 2 minutes Q&A**. Four speakers, about 45 seconds each (about 110 words). Click-by-click actions are in `docs/DEMO-SCRIPT.md`.
Numbers come from `docs/DEVPOST.md` (a run on 2026-10-10/11). **Read the numbers that are on screen in your final run; if they differ, say the on-screen ones.** Say "simulated" out loud.

## 1. Aadhavan: overview and problem statement (about 45 s)

"Aircraft maintenance is a coordination problem. A part starts to wear out, but the aircraft, the hangar, the spare part and the qualified technician are in different cities, and the plane still has to fly its schedule. Today planners juggle fixed schedules and separate systems, and when something changes, like a delayed part or a closed hangar, they re-plan by hand.

AeroTwin AI is a digital twin of a simulated fleet of 24 aircraft. It predicts how much life each component has left, simulates what happens when the world changes, and re-plans maintenance around flights, parts, technicians and hangar space. It serves maintenance control and operations planners, and a person approves every work order. Everything you will see is simulated."

## 2. Shamit: architecture and AI (about 45 s)

"Under the hood it is one FastAPI backend with six module groups: the twin, the solver, what-if, the simulator, the agents and the copilot, on a SQLite database, with a React console on top. We wrote the shared data contract first, so every module plugged into the same shapes, and the health endpoint shows which modules are real.

The AI is deliberately split. A random-forest model and an anomaly detector, trained on NASA C-MAPSS engine data, estimate remaining life with an uncertainty range. A constraint solver, not a language model, makes the schedule. Five agents call deterministic tools. A language model is optional for the copilot, and every number it states is checked against tool output. In this demo it runs in scripted mode, and no language model decides anything."

## 3. Pardhu: validation (about 45 s)

"I built the scheduler and the what-if engine, so let me say how we know they are right.

Every deadline comes from the conservative remaining-life estimate, the p10, and it is a hard constraint; if no safe slot exists the planner says why instead of forcing a plan. We compare against a stated baseline: fix at the home base in the last window before the deadline. On this scenario cost ties, so we show risk. Optimized fixes the engine in 42 hours with 6 flights flown with the fault open and 73.6 hours of margin; the baseline takes 86 hours, 14 flights and 29.6 hours of margin. Over 300 automated tests pass, an independent checker re-verifies every plan, and I deliberately break 30 scheduling rules to confirm the tests catch each one. The health model was tested on 100 held-out NASA engines: remaining-life error of about 11 cycles."

## 4. Aashirth: real-world impact (about 45 s)

"What would this change for a real maintenance team? Faults get fixed sooner, with fewer flights flown while a fault is open and a bigger safety margin before the deadline. When a part is late or a hangar closes, the plan is recomputed in a fraction of a second, with a plain-language reason for every move, instead of being redone by hand.

It is built to keep people in control: every work order waits for human approval and is written to an audit log, and the system is advisory only. To be clear about limits: the fleet, parts and task cards are simulated, the savings are relative to our stated baseline and are not airline results. Next steps are real airline data connectors, validation on airline sensor data, and the approvals real aviation requires."

## Hand-offs (one line each, so the 3 minutes flow)

* Aadhavan to Shamit: "Shamit will show how it is built and where the AI sits."
* Shamit to Pardhu: "Pardhu will show why you can trust the plan."
* Pardhu to Aashirth: "Aashirth will close with what it means in the real world."

## Likely Q&A (2 minutes), who answers

* **Is the data real?** (Shamit) Engine degradation is NASA C-MAPSS run-to-failure data. The fleet, flights, stations, parts and technicians are simulated and labeled SIMULATED.
* **Does an LLM decide maintenance?** (Shamit) No. The schedule comes from a constraint solver, the agents call deterministic tools, and a person approves every work order.
* **What if the model is wrong?** (Pardhu) Deadlines use the conservative p10 and are hard constraints; the p10-p90 band covered 92.9% of held-out cases against a nominal 80%; the system is advisory and certifies nothing.
* **Compared with what?** (Pardhu) A stated static baseline: service at the home base in the last window before the deadline. Only numbers the run printed.
* **Who is it for and what is next?** (Aashirth) Maintenance control and planners; next is real data connectors and validation on airline data.
