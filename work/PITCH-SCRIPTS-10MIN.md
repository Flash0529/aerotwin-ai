# Spoken scripts, 10-minute version (four speakers)

Use this when you have about 10 minutes. At the judging table use the 3-minute version in `PITCH-SCRIPTS.md` (the rules give 3 min + 2 min Q&A).
Timing at about 150 words a minute: Aadhavan 2.5 min, Shamit 3 min, Pardhu 2.5 min, Aashirth 2 min.
Numbers come from `docs/DEVPOST.md` (run of 2026-10-10/11); read the numbers on screen if they differ. Say "simulated" out loud. Click actions: `docs/DEMO-SCRIPT.md`.

## 1. Aadhavan: problem statement, how the idea started, why it exists (about 2.5 min)

"Let me start with the problem. Keeping an aircraft safe and keeping it flying are two jobs that pull against each other, and maintenance is where they collide.

An aircraft component, say an engine, does not fail on a calendar. It wears out at its own pace. But most maintenance is planned on fixed schedules, so we either service it too early and waste money and ground time, or too late and risk an unexpected failure. That means an aircraft on the ground, flights delayed or cancelled, and an expensive scramble.

And even when you know a part is wearing out, fixing it is a puzzle. The aircraft, the hangar, the spare part and the qualified technician are in different cities. The aircraft has a flight schedule to keep. A kit may be in the wrong place or arrive late. Aircraft health, flight operations, parts and people live in separate systems, so planners stitch together an answer by hand, and every time something changes, a delayed part, a closed hangar, a new fault, they start again.

That is where the idea came from. I wrote a concept called the self-optimizing aircraft fleet, with one question: what if every aircraft had a living digital twin, a continuously updated virtual copy of its health, so that one connected system could predict a failure, simulate what happens next, and plan the fix around everything else?

Hacklanta's AI/ML track asks us to put models to work and take real tasks off someone's plate. Maintenance planning is exactly that: lots of data, hard constraints, and a person who has to decide fast. So we built it in 36 hours as four people. We built it for maintenance control and operations planners, and we built it so that a person approves every action. Everything you will see is simulated. Shamit will now show how it is built and where the AI sits."

## 2. Shamit: architecture and the use of AI (about 3 min)

"Architecture first. AeroTwin is one FastAPI backend with six module groups: the twin, the solver, what-if, the simulator, the agents and the copilot. They share a SQLite database, and a React console sits on top with role views for operations, maintenance, pilots, crew and administrators. We wrote one shared data contract on day one, so every module could be built in parallel and plugged into the same shapes. A health endpoint shows which modules are real, so nothing is silently mocked.

Now the AI, and I want to be precise about where we use it and where we do not.

First, prediction. A random-forest model estimates each engine's remaining useful life, from the last 30 readings of 14 sensors, trained on NASA's C-MAPSS run-to-failure data. It does not give one number. It gives a range: a conservative p10, a median p50 and an optimistic p90, calibrated on separate engines so the range can be trusted. A second model, an Isolation Forest, flags abnormal sensor behavior. A data-quality check says when to doubt an estimate. For example, the injected engine fault comes out at p10 20.2, p50 31.4, p90 57.8 flights.

Second, the digital twin. Those predictions feed a living state for each of 24 aircraft and 144 components: health, status, remaining-life band, sensor trends and a timeline. You see it as a 3D aircraft where each part shows its health. The twin is where prediction meets the fleet. And a scenario lab lets us change the world: inject a fault, delay a part, close a hangar.

Third, the agents and the copilot. Five agents, health, scheduling, logistics, operations and a coordinator, call deterministic tools and draft work orders. The copilot answers planner questions like why one aircraft is prioritized over another, or what changes if a facility closes. It answers using only numbers returned by those tools. A language model is optional: if one is switched on, every number it states is checked against the tool output, and if it fails the check, it falls back to the scripted answer. In this demo it runs scripted.

What the AI does not do: it never makes the schedule, and it never approves anything. A constraint solver plans, and a person approves. Pardhu will show why you can trust that plan."

## 3. Pardhu: the planner and validation (about 2.5 min)

"I built the scheduler and the what-if engine, and I will cover how we know the plan is right.

Take the engine fault. The health model says the engine has at least 20 flights left, as a conservative estimate. I turn that into a hard deadline: the aircraft's scheduled arrival of that flight. The planner may never miss it. It then searches every ground window of that aircraft, every technician with the right skill and shift, and every source of the spare part, on hand or shipped. If no safe slot exists, it says so and explains why. It never forces a plan.

We compare against a stated baseline: fix the fault at the aircraft's home base in the last window before the deadline. In this scenario cost ties, so a dollar comparison would hide the difference. Instead we show risk: the optimized plan fixes the engine in 42 hours, with 6 flights flown with the fault open and 73.6 hours of margin before the deadline. The baseline takes 86 hours, 14 flights and 29.6 hours of margin.

Then the world changes. Delay the borescope kit at Dallas by 36 hours and the first slot is no longer valid. The planner replans in a fraction of a second, moves only what it must, and shows before and after with the reason.

How do we know it is right? Over 300 automated tests pass. An independent checker re-verifies every plan against the hard rules. And I deliberately break 30 scheduling rules, one at a time, to prove the tests catch each one. The health model was tested on 100 held-out NASA engines: remaining-life error of about 11 cycles, and the p10 to p90 band covered 93 percent of cases against a nominal 80, so it errs on the cautious side. Aashirth will close with what it means."

## 4. Aashirth: real-world impact (about 2 min)

"What would this change for a real maintenance team?

First, faults get fixed sooner, and fewer flights fly with a known fault open, with a bigger margin before the hard deadline. That is the difference between a calm plan and a scramble.

Second, speed. When a part is late, a hangar closes or a technician is out, the plan is recomputed in a fraction of a second, with a plain-language reason for every move, instead of a planner redoing it by hand.

Third, one shared picture. The role views give operations control, maintenance planners, pilots, crew and dispatch and administrators what each of them needs, from one source of truth.

Fourth, accountability. Every work order is created pending approval. Only a named person can approve it, and every step is written to an audit log. The system is advisory only and certifies nothing.

Now the honest limits. The fleet, the parts and the task cards are simulated, and the results are relative to our stated baseline, not airline savings. Engine degradation uses NASA research data, not airline data.

What it would take to go further: connectors to real maintenance records, parts systems and rosters; validation on real airline sensor data; a live language-model copilot tested against the real service; and the regulatory approvals that aviation requires.

AeroTwin predicts the failure, simulates the future and plans the fix, with a person in charge. Thank you."

## Q&A: who answers
* Is the data real? Shamit. Does an LLM decide? Shamit. What if the model is wrong? Pardhu. Compared with what? Pardhu. Who is it for, what next? Aashirth. Why this idea? Aadhavan.
