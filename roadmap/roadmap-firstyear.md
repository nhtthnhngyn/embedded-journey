# Embedded Systems + Semiconductor Roadmap — **DV-first + C-first** (Regina → Canada-wide → US MS-ready)
Student: University of Regina 
Start date: **2026-02-19**  
Time commitment: **~25–30 hours/week**  
Primary location focus: Regina, Saskatchewan (local → Saskatchewan-wide → Canada-wide → remote)  
Primary target: **MS in IC Design / Semiconductor (Top US programs)** — **Design Verification first**  
Secondary target: **Embedded Systems (C-first MCU firmware + drivers + reliability)**  
Primary OS/dev environment: **Windows 10 + WSL2 (Ubuntu)** ✅


## Weekly operating system (do every week, starting Week 1)
Budget: ~3.0–4.0 hrs/week. This keeps you moving locally while building exactly what DV/RTL/FPGA + embedded recruiters and professors respond to.

1) **Job sweep (45 min)**
   - Save 5–10 roles even if you don’t apply yet
   - Add them to `internship/target-companies.csv`
   - Tag each role as one of: **DV / RTL / FPGA / validation / embedded / test / controls**

2) **Apply (30–60 min)**
   - Apply to **2–5 roles** (local/regional first; Canada-wide if local is thin)

3) **Networking action (20 min)**
   - Connect/message **2 people/week**
     - 1 UofR alumnus or local engineer
     - 1 Canada-wide semiconductor/DV/FPGA engineer
   - Track in `internship/networking-tracker.csv`

4) **Professor/lab action (30–45 min)**
   - Read one lab page OR one publication abstract
   - Add notes to `professors/`
   - Keep a “How I can help in 2 weeks” bullet per professor

5) **DV-core action (30–45 min)** ✅ (signature habit)
   - Do one verification skill drill:
     - self-checking testbench improvements **OR**
     - randomized tests **OR**
     - “assertions mindset” notes (even before SVA)
   - Push to `weeks/week-XX/rtl-dv/` + add 5–10 lines of notes

---

## Toolchain (Windows 10 + WSL2) — **C-first + DV-first**
You will use Windows for editors + drivers, and WSL2 for a clean Linux-like build/sim experience.

### Stage 0 (Week 1): Windows essentials
- Git for Windows: https://git-scm.com/download/win  
- VS Code: https://code.visualstudio.com/  
- Python 3 (Windows): https://www.python.org/downloads/windows/  
- GitHub CLI (optional): https://cli.github.com/  

### Stage 1 (Weeks 1–2): WSL2 + C-first foundations (then DV)
- WSL2 install guide (Microsoft): https://learn.microsoft.com/windows/wsl/install  
- In WSL2 (Ubuntu): install build tools (`build-essential`, `gdb`, `python3`, etc.)
- C-first target: compile/run/debug C in WSL2 every week (even while doing DV)

### Stage 2 (Weeks 1–2): RTL/DV-first on PC (no hardware needed) ✅
- Icarus Verilog: https://steveicarus.github.io/iverilog/  
- GTKWave: https://gtkwave.sourceforge.net/  
- (Optional, powerful) Verilator: https://www.verilator.org/  

**Checkpoint (end of Week 2)**: run a Verilog testbench, get PASS/FAIL output, and open a waveform.

### Stage 3 (Weeks 4–6): Embedded hardware begins ✅
Buy hardware after your Week 2 DV toolchain and Week 1–3 C habit are stable.

**Recommended shopping list (cheap + useful)** — see “Purchases (Amazon Canada)” section.
- **[CORE]** Raspberry Pi Pico (or Pico W)
- **[CORE]** USB cable (data-capable)
- **[CORE]** Breadboard + jumper wires
- **[CORE]** One sensor module (choose one):
  - **BME280** (temp/pressure/humidity, I2C/SPI)
  - **MPU-6050** (IMU, I2C)
  - **DS18B20** (temp, 1-wire; simpler but less “I2C industry”)
- **[OPTIONAL]** USB logic analyzer later (Weeks 10–14)

**Pico docs hub**
- Raspberry Pi microcontroller docs hub: https://www.raspberrypi.com/documentation/microcontrollers/

**Checkpoint (end of Week 6)**: build + flash a Pico example and print UART logs.

---

## GitHub structure (professional + trackable)
You want your GitHub to serve:
1) Recruiters (internships)
2) Professors (RA/TA)
3) MS applications (evidence of research mindset + rigor)
4) Future you (study tracking + evidence)

### Repos
1) Hub repo: `embedded-journey`
- `README.md` (landing page)
- `weeks/week-01/` … `weeks/week-34/`
- `notes/`
- `reading-notes/`
- `paper/` (replication-style study + writeups)
- `resume/`
- `professors/`
- `internship/`

2) Project repos (clean/polished)
- `pico-data-logger` (Project #1)
- `rtl-uart-tx` (Project #2, **flagship DV repo**)

### Minimum quality bar for every “judgeable” repo
Each repo must have:
- `README.md` with:
  - what it is
  - how to build/run
  - demo output (log snippet / screenshot / waveform screenshot)
- `LICENSE` (MIT is common)
- clear structure (`src/`, `include/`, `docs/`)
- proof assets in `docs/` or `assets/`
- **reproducibility:** exact commands + tool versions

### Landing README structure (`embedded-journey/README.md`)
- About me (2–3 lines)
- Skills (**DV-first** + **C-first embedded**)
- Projects (links + 2 bullets each)
  - Pico Data Logger
  - RTL UART TX + DV testbench + regression
- Weekly progress table (Week 1–34)
- Research (replication study + results)
- Contact (email + LinkedIn)

---

## Weekly log template (use every week)
Create:
- `weekly-plan.md` (start)
- `weekly-report.md` (end)

**weekly-plan.md**
- Goals (3–5 bullets)
- Time plan (days)
- Risks (blockers)
- Deliverables to push
- 1 sentence: “How this helps internship/RA/MS goals”

**weekly-report.md**
- What I completed (with links/commits)
- What failed + why
- What I learned (5 bullets)
- Next week plan
- Proof (1–2 screenshots/logs/waveforms)

---

## Tracking templates (create in Week 1)
### `internship/target-companies.csv` columns
- company, location, role_keyword_fit, careers_url, notes, contact_person, last_checked_date, tags

### `internship/applications-tracker.csv` columns
- date_applied, company, role_title, url, resume_version, status, follow_up_date, notes, tags

### `internship/networking-tracker.csv` columns
- date, person, company_or_uofr, message_sent, response, next_step, tags

### `professors/outreach-tracker.csv` columns
- date_sent, professor, lab, email_used, link_to_custom_notes, follow_up_date, response, tags

---

## Free-first core resource library (MUST vs OPTIONAL) — links verified
### Git & workflow
- **[MUST]** Pro Git: https://git-scm.com/book/en/v2  
- **[MUST]** Missing Semester: https://missing.csail.mit.edu/  

### C / Embedded (C-first)
- **[MUST]** Learn-C interactive: https://www.learn-c.org/  
- **[OPTIONAL]** Beej’s C guide: https://beej.us/guide/bgc/  
- **[MUST]** Embedded Artistry: https://embeddedartistry.com/blog/  

### Digital logic / architecture
- **[MUST]** Nand2Tetris: https://www.nand2tetris.org/  
- **[OPTIONAL]** Ben Eater (YouTube channel): https://www.youtube.com/@BenEater  
- **[OPTIONAL]** CS61C (architecture hub): https://cs61c.org/  

### Verilog/DV
- **[MUST]** HDLBits: https://hdlbits.01xz.net/wiki/Main_Page  
- **[MUST]** Icarus Verilog: https://steveicarus.github.io/iverilog/  
- **[MUST]** GTKWave: https://gtkwave.sourceforge.net/  
- **[OPTIONAL]** Verilator: https://www.verilator.org/  
- **[OPTIONAL]** cocotb: https://www.cocotb.org/  

### Research
- **[MUST]** How to read a paper (Keshav PDF): https://web.stanford.edu/class/ee384m/Handouts/HowtoReadPaper.pdf  
- **[MUST]** Google Scholar: https://scholar.google.com/  
- **[OPTIONAL]** Zotero: https://www.zotero.org/  

### Pico docs (when you buy hardware)
- **[MUST]** Raspberry Pi microcontroller docs hub: https://www.raspberrypi.com/documentation/microcontrollers/  
- **[OPTIONAL]** SparkFun Learn: https://learn.sparkfun.com/  

---

## Purchases (Amazon Canada only) — practical project hardware list
> Use these **Amazon.ca search links** so you can choose reputable sellers with Prime shipping to Regina.  
> You do **not** need everything immediately; buy in phases (Weeks 4–6 first, then Weeks 10–14).

### Phase 1 (Weeks 4–6): minimum to start embedded work (MUST BUY)
1) **Raspberry Pi Pico or Pico W**
- https://www.amazon.ca/s?k=raspberry+pi+pico
- (Optional Wi‑Fi) https://www.amazon.ca/s?k=raspberry+pi+pico+w

2) **Micro-USB data cable (charge+data)**
- https://www.amazon.ca/s?k=micro+usb+data+cable

3) **Breadboard + jumper wires kit**
- https://www.amazon.ca/s?k=breadboard+jumper+wires+kit
- Add male-female jumpers if needed: https://www.amazon.ca/s?k=male+female+jumper+wires

4) **2.54mm pin headers (for soldering Pico headers)**
- https://www.amazon.ca/s?k=2.54mm+pin+header

5) **One sensor module (pick ONE)**
- **BME280 (recommended I2C/SPI, industry-relevant):** https://www.amazon.ca/s?k=bme280+breakout
- **MPU-6050 (cheap IMU, common I2C):** https://www.amazon.ca/s?k=mpu-6050+module
- **DS18B20 (1-wire temperature):** https://www.amazon.ca/s?k=ds18b20

### Phase 2 (Weeks 10–14): debugging tools (HIGHLY RECOMMENDED)
6) **USB logic analyzer (8ch, 24MHz class)**
- https://www.amazon.ca/s?k=usb+logic+analyzer+24mhz
- Use with PulseView/sigrok (software is free).

7) **Digital multimeter**
- https://www.amazon.ca/s?k=digital+multimeter

### Phase 3 (Weeks 14–20): soldering + reliability parts (RECOMMENDED if serious)
8) **Soldering iron kit**
- https://www.amazon.ca/s?k=soldering+iron+kit

9) **Solder + flux**
- https://www.amazon.ca/s?k=solder+wire+electronics
- https://www.amazon.ca/s?k=solder+flux

10) **Resistor kit + capacitor kit (pull-ups, basic RC experiments)**
- https://www.amazon.ca/s?k=resistor+kit
- https://www.amazon.ca/s?k=ceramic+capacitor+kit

### Phase 4 (Weeks 16–24): “real data logging” upgrades (OPTIONAL)
11) **MicroSD card module (SPI)**
- https://www.amazon.ca/s?k=micro+sd+card+module+spi

12) **microSD card**
- https://www.amazon.ca/s?k=micro+sd+card

13) **RTC module (DS3231) for timestamps**
- https://www.amazon.ca/s?k=ds3231+rtc+module

---

# WEEK-BY-WEEK ROADMAP (34 Weeks) — 25–30 hrs/week, **DV-first + C-first**, MS (IC Design) optimized
Each week includes:
- **Must learn**
- **Free resources**
- **Career/RA/MS action**
- **Checkpoint**
- **Push** (to GitHub)

> Tags:
> - 🔥 IC/DV priority
> - ⚙️ Embedded (C-first)
> - 📚 Research (evidence for MS SOP + letters)
> - 🎯 Career/RA

---

## Week 1 — Setup + Git discipline + **C refresh (WSL2)** + Regina mapping
**Must learn**
- 🔥 Basic DV workflow concept: compile/run tests = “PASS/FAIL culture”
- ⚙️ C fundamentals refresher (compile + run + simple debug in WSL2)
- Git basics + README quality

**Free resources**
- **[MUST]** Pro Git: https://git-scm.com/book/en/v2  
- **[MUST]** Missing Semester (Lectures 1–2): https://missing.csail.mit.edu/  
- **[MUST]** Learn-C: https://www.learn-c.org/  

**Career/RA/MS action (🎯)**
- Create first draft of local/regional employer list.
- Start `professors/uofr-lab-map.md` (seed it early with at least 3 entries).

**Checkpoint**
- You can compile C (WSL2), use git, and push clean commits.

**Push (embedded-journey)**
- `weeks/week-01/weekly-plan.md`, `weekly-report.md`
- `weeks/week-01/hello-c/` (5 programs)
- `internship/regina-market-map.md` (start with 10 employers + links)
- Create all CSV trackers (empty with headers)
- `professors/uofr-lab-map.md` (v0)

---

## Week 2 — DV toolchain (no hardware) + bitwise C + first self-checking TB
**Must learn**
- 🔥 Install/run Icarus Verilog + GTKWave (prefer in WSL2)
- 🔥 Self-checking testbench pattern (PASS/FAIL)
- ⚙️ Bit ops, masking/shifting, error codes, `volatile`

**Free resources**
- **[MUST]** Icarus Verilog: https://steveicarus.github.io/iverilog/  
- **[MUST]** GTKWave: https://gtkwave.sourceforge.net/  
- **[MUST]** HDLBits: https://hdlbits.01xz.net/wiki/Main_Page  
- **[OPTIONAL]** Volatile article (Embedded Artistry): https://embeddedartistry.com/fieldmanual-terms/volatile/  

**Career/RA/MS action (🎯)**
- Expand Regina map to 15–25 entries.

**Checkpoint**
- Run a TB that prints PASS and generate a waveform.

**Push**
- `weeks/week-02/rtl-dv/adder_tb/` (tiny DUT + TB)
- `weeks/week-02/bit-utils/`
- `notes/week-02-dv-toolchain.md` (exact commands)
- Update `internship/regina-market-map.md`

---

## Week 3 — Digital logic + FSM thinking + HDLBits streak
**Must learn**
- 🔥 FSM thinking for DV (states, corner cases)
- 🔥 Solve 25 HDLBits problems (comb + seq starter; slightly more intensive)
- ⚙️ C simulation of an FSM

**Free resources**
- **[MUST]** HDLBits: https://hdlbits.01xz.net/wiki/Main_Page  
- **[MUST]** Nand2Tetris: https://www.nand2tetris.org/  
- **[OPTIONAL]** Ben Eater: https://www.youtube.com/@BenEater  

**Career/RA/MS action (🎯)**
- Grow `professors/uofr-lab-map.md` to **6 profs** with 1–2 projects each.

**Checkpoint**
- FSM module + TB passes and you can explain it.

**Push**
- `weeks/week-03/rtl-dv/fsm_exercise/` (FSM + self-check TB)
- `notes/week-03-fsm.md`
- Update `professors/uofr-lab-map.md`

---

## Week 4 — Verification patterns + **Research starts (replication mindset)** + Canada-wide targets
**Must learn**
- 🔥 Scoreboard concept (expected vs actual)
- 🔥 Edge cases + negative tests (“break it on purpose”)
- ⚙️ Python script to run tests + parse output

**Research (📚) — NEW (critical)**
- Define a replication-style question you can actually answer with your repos, e.g.:
  - “How much better do randomized tests + scoreboards catch UART bugs vs deterministic tests?”
- Create:
  - `paper/research-question.md`
  - `paper/research-log.md` (weekly entries)
  - `paper/method-notes.md` (what you will measure)

**Free resources**
- **[MUST]** Python tutorial: https://docs.python.org/3/tutorial/  
- **[MUST]** HDLBits (sequential): https://hdlbits.01xz.net/wiki/Main_Page  
- **[OPTIONAL]** cocotb: https://www.cocotb.org/  

**Career/RA/MS action (🎯)**
- Add Canada-wide semiconductor targets to `target-companies.csv` (10 entries).

**Checkpoint**
- One DV mini-project has:
  - at least 5 tests
  - 1 intentionally injected bug that tests catch
- Research docs created (even if rough).

**Push**
- `weeks/week-04/rtl-dv/scoreboard_exercise/`
- `internship/target-companies.csv` updated (Canada-wide entries)
- `notes/week-04-scoreboard.md`
- `paper/research-question.md`, `paper/research-log.md`, `paper/method-notes.md`

---

## Week 5 — UART protocol study + begin rtl-uart-tx planning (flagship)
**Must learn**
- 🔥 UART frame rules, timing math, sampling points
- 🔥 Write a UART TX spec (before code)
- ⚙️ Embedded UART logging format planning (no hardware yet)

**Free resources**
- **[MUST]** UART basics (YouTube search): https://www.youtube.com/results?search_query=uart+protocol+explained  
- **[MUST]** HDLBits practice: https://hdlbits.01xz.net/wiki/Main_Page  

**Career/RA/MS action (🎯)**
- Networking: message 2 people (1 alumni + 1 Canada DV/FPGA).

**Checkpoint**
- A written `rtl-uart-tx` spec + test plan exists.

**Push**
- `weeks/week-05/rtl-dv/uart-spec/uart_spec.md`
- `weeks/week-05/rtl-dv/uart-spec/test_plan.md`
- Update `internship/networking-tracker.csv`
- Add a paragraph to `paper/research-log.md` about how UART will be your experimental vehicle

---

## Week 6 — Buy hardware + Pico toolchain + first flash (embedded begins)
**Must learn**
- ⚙️ Pico bring-up basics (build + flash)
- ⚙️ Serial monitor basics (UART via USB)
- 🔥 Keep DV habit: 15 HDLBits problems

**Free resources**
- **[MUST]** Raspberry Pi microcontroller docs hub: https://www.raspberrypi.com/documentation/microcontrollers/  
- **[MUST]** HDLBits: https://hdlbits.01xz.net/wiki/Main_Page  

**Career/RA/MS action (🎯)**
- Apply to 2 roles (even test/controls).

**Checkpoint**
- You can build + flash a Pico example and print a UART banner.

**Push**
- `weeks/week-06/toolchain-setup.md` (your exact steps)
- `weeks/week-06/pico-hello-uart/` + log screenshot
- Update `internship/applications-tracker.csv`

---

## Week 7 — Pico GPIO + timing + non-blocking patterns (industrial style)
**Must learn**
- ⚙️ timers + non-blocking scheduler
- ⚙️ reliability patterns (timeouts, error codes)
- 🔥 DV: write 1 clean self-check TB with multiple testcases

**Free resources**
- **[MUST]** Raspberry Pi docs hub: https://www.raspberrypi.com/documentation/microcontrollers/  
- **[MUST]** Embedded Artistry: https://embeddedartistry.com/blog/  

**Career/RA/MS action (🎯)**
- Add 2 professors (total 8) + 1 abstract note each.

**Checkpoint**
- Embedded app runs periodic tasks without blocking.

**Push**
- `weeks/week-07/pico-scheduler/`
- `weeks/week-07/rtl-dv/multi_test_tb/`
- Update `professors/uofr-lab-map.md`

---

## Week 8 — I2C sensor bring-up plan + **early RA positioning**
**Must learn**
- ⚙️ I2C basics, register maps, error handling
- 🔥 DV: constrained randomness idea (simple random bytes / gaps)

**Free resources**
- **[MUST]** SparkFun Learn: https://learn.sparkfun.com/  
- **[MUST]** I2C explained (YouTube search): https://www.youtube.com/results?search_query=i2c+explained  

**Career/RA/MS action (🎯)**
- Canada-wide sweep: add 10 more targets + tag as DV/RTL/FPGA.
- Draft 1 *professor meeting request* message (not necessarily send yet): show your Week 4–7 proof.

**Checkpoint**
- You have a sensor choice + wiring diagram + driver skeleton ready.

**Push**
- `weeks/week-08/i2c-driver-plan.md`
- `weeks/week-08/rtl-dv/random_stimulus_intro/`
- Update `internship/target-companies.csv`
- `professors/meeting-request-draft.md`

---

## Week 9 — Start **rtl-uart-tx repo**: implement TX + deterministic TB (flagship begins)
**Must learn**
- 🔥 Implement UART TX RTL (parameterized)
- 🔥 Deterministic self-checking TB
- Waveform proof discipline

**Free resources**
- **[MUST]** HDLBits (FSM/sequential): https://hdlbits.01xz.net/wiki/Main_Page  
- **[OPTIONAL]** Icarus Verilog docs: https://steveicarus.github.io/iverilog/  

**Career/RA/MS action (🎯)**
- Apply to 2 roles; 2 networking messages.
- Update `paper/method-notes.md`: define what bugs you’ll inject and how you’ll measure catch rate.

**Checkpoint**
- UART TX passes deterministic tests + waveform screenshots exist.

**Push**
- **rtl-uart-tx repo:** RTL + TB + `README.md`
- **embedded-journey:** `weeks/week-09/project-link.md` linking repo
- Update trackers + `paper/` method notes

---

## Week 10 — Randomized TB + scoreboard (DV signature) + buy logic analyzer (optional)
**Must learn**
- 🔥 Random tests (random bytes, random idle gaps)
- 🔥 Scoreboard compare + failure reporting
- 🔥 Seed logging (reproducibility)

**Free resources**
- **[MUST]** HDLBits: https://hdlbits.01xz.net/wiki/Main_Page  
- **[OPTIONAL]** cocotb: https://www.cocotb.org/  

**Career/RA/MS action (🎯)**
- Start RA pipeline seriously: pick 3 prof targets and tailor “how I can help in 2 weeks.”

**Checkpoint**
- TB catches at least 1 intentional bug.
- Failures include: test name, seed, minimal reproduction steps.

**Push**
- `rtl-uart-tx`: randomized TB + scoreboard notes in `docs/`
- `professors/uofr-target-profs.md` (3 targets + “how I can help”)
- Update outreach tracker (planned dates)

---

## Week 11 — Assertions mindset + regression runner script (without SVA)
**Must learn**
- 🔥 “Properties” as checks in TB (invariants)
- 🔥 Regression runner script in Python (run all tests, summarize)
- Bonus: make it CI-friendly (GitHub Actions later if you want)

**Free resources**
- **[MUST]** Python tutorial: https://docs.python.org/3/tutorial/  
- **[OPTIONAL]** Verilator: https://www.verilator.org/  

**Career/RA/MS action (🎯)**
- Apply 5 roles this week (volume push).

**Checkpoint**
- One command runs tests and prints summary.

**Push**
- `rtl-uart-tx`: `scripts/run_tests.py` + README “How to run tests”
- Update applications tracker
- `paper/research-log.md`: record baseline vs random testing observations

---

## Week 12 — Add FIFO + ready/valid style interface concept (IC relevance)
**Must learn**
- 🔥 FIFO basics + why buffering matters
- 🔥 Simple ready/valid handshake concept
- 🔥 DV: ordering, overflow/underflow, backpressure tests

**Free resources**
- **[MUST]** FIFO design (YouTube search): https://www.youtube.com/results?search_query=verilog+fifo+tutorial  
- **[OPTIONAL]** CS61C: https://cs61c.org/  

**Career/RA/MS action (🎯)**
- Read 2 abstracts in your target lab area; log notes.

**Checkpoint**
- FIFO module + TB verifies ordering and full/empty behavior.

**Push**
- `weeks/week-12/rtl-dv/fifo/`
- `notes/week-12-fifo-ready-valid.md`
- `reading-notes/abstract-01.md`, `abstract-02.md`

---

## Week 13 — Research: reading list + related-work matrix v0 (but tied to your repos)
**Must learn**
- 📚 Related-work matrix (DV for serial protocols, randomized testing, coverage, embedded reliability)

**Free resources**
- **[MUST]** Keshav PDF: https://web.stanford.edu/class/ee384m/Handouts/HowtoReadPaper.pdf  
- **[MUST]** Google Scholar: https://scholar.google.com/  
- **[OPTIONAL]** Zotero: https://www.zotero.org/  

**Career/RA/MS action (🎯)**
- Draft 1 tailored RA email (not sent yet) that links:
  - your flagship repo
  - your research question
  - a 2-week deliverable proposal

**Checkpoint**
- 10-paper list + matrix with 8+ entries.

**Push**
- `reading-notes/reading-list.md`
- `paper/related-work-matrix.csv`
- `professors/email-prof-lastname.md` (draft)

---

## Week 14 — Embedded: Pico UART + logging + error handling (and connect to DV mindset)
**Must learn**
- ⚙️ UART on Pico, structured logs
- ⚙️ error codes + robustness patterns
- (Optional) Use logic analyzer to validate UART frames

**Free resources**
- **[MUST]** Raspberry Pi docs hub: https://www.raspberrypi.com/documentation/microcontrollers/  
- **[MUST]** Embedded Artistry: https://embeddedartistry.com/blog/  

**Career/RA/MS action (🎯)**
- Apply 2 roles + 2 networking messages.

**Checkpoint**
- Pico prints stable logs and responds to a simple command.

**Push**
- `weeks/week-14/pico-uart-cli-mini/`
- Update trackers

---

## Week 15 — I2C sensor driver bring-up + datasheet summary
**Must learn**
- ⚙️ I2C transactions + WHO_AM_I style checks
- Driver API + error handling

**Free resources**
- **[MUST]** SparkFun Learn: https://learn.sparkfun.com/  
- **[MUST]** I2C explained (YouTube search): https://www.youtube.com/results?search_query=i2c+explained  

**Career/RA/MS action (🎯)**
- Update employer map with sensor/industrial companies (controls, instrumentation).

**Checkpoint**
- Read sensor ID reliably and stream basic measurements.

**Push**
- `weeks/week-15/i2c-sensor-driver/`
- `weeks/week-15/datasheet-summary.md`
- Update `internship/target-companies.csv`

---

## Week 16 — Start **pico-data-logger repo**: spec + architecture + skeleton
**Must learn**
- ⚙️ Define interfaces (sensor → buffer → log)
- ⚙️ non-blocking sampling plan
- 🔥 DV: keep 15 HDLBits problems

**Free resources**
- **[MUST]** README guide: https://www.makeareadme.com/  
- **[MUST]** Raspberry Pi docs hub: https://www.raspberrypi.com/documentation/microcontrollers/  

**Career/RA/MS action (🎯)**
- Prepare RA meeting packet outline (what you can do in 2 weeks).

**Checkpoint**
- Project builds, logs banner, has spec + demo plan.

**Push**
- **pico-data-logger repo:** README + scaffold
- **embedded-journey:** `weeks/week-16/project-plan.md` linking repo
- `professors/meeting-packet-outline.md`

---

## Week 17 — Data Logger robustness: buffers, timeouts, fault states
**Must learn**
- ⚙️ ring buffer + overflow strategy
- ⚙️ fault state machine + retry/backoff

**Free resources**
- **[MUST]** Embedded Artistry: https://embeddedartistry.com/blog/  

**Career/RA/MS action (🎯)**
- Apply to 5 roles (volume week).

**Checkpoint**
- Logger runs 10+ minutes with clean fault reporting.

**Push**
- `pico-data-logger`: robustness changes + sample logs
- Update applications tracker

---

## Week 18 — Data Logger CLI + config + Python parser (verification mindset in embedded)
**Must learn**
- ⚙️ UART CLI commands
- Python parser for logs (validation mindset)

**Free resources**
- **[MUST]** Python tutorial: https://docs.python.org/3/tutorial/  

**Career/RA/MS action (🎯)**
- Draft final RA email for 1 professor (highly tailored).

**Checkpoint**
- Start/stop logging, set sampling rate, parse output.

**Push**
- `pico-data-logger`: CLI + parser + DEMO.md
- `professors/email-prof-lastname.md` (final for 1 prof)

---

## Week 19 — DV polish: coverage mindset + bug diary
**Must learn**
- 🔥 Coverage mindset (simple counters ok)
- Bug diary writing
- “Reduction” skill: make failing random test minimal and reproducible

**Free resources**
- **[MUST]** HDLBits: https://hdlbits.01xz.net/wiki/Main_Page  

**Career/RA/MS action (🎯)**
- Message 2 DV engineers asking what they test day-to-day.

**Checkpoint**
- TB reports which cases ran; bug diary has 2 entries.

**Push**
- `rtl-uart-tx`: coverage-like reporting + `docs/bug-diary.md`
- Update networking tracker

---

## Week 20 — RA outreach week (send 2–3 tailored emails)
**Must learn**
- 📚 Emailing professors effectively
- 📚 Prepare meeting agenda + deliverables

**Free resources**
- **[MUST]** Columbia career ed: https://www.careereducation.columbia.edu/resources/emailing-professors  
- **[MUST]** Keshav PDF: https://web.stanford.edu/class/ee384m/Handouts/HowtoReadPaper.pdf  

**Career/RA/MS action (🎯)**
- Send 2–3 tailored emails + set follow-up dates.

**Checkpoint**
- Emails sent + follow-ups scheduled.

**Push**
- Update `professors/outreach-tracker.csv`
- `professors/meeting-prep.md`

---

## Week 21 — Research experiments start (small measurable result)
**Must learn**
- 📚 experiment design: baseline vs improved
- simple plotting/reporting

**Free resources**
- **[MUST]** Python tutorial: https://docs.python.org/3/tutorial/  
- **[OPTIONAL]** Matplotlib (YouTube search): https://www.youtube.com/results?search_query=matplotlib+tutorial  

**Career/RA/MS action (🎯)**
- Apply to 2 roles + 2 networking messages.

**Checkpoint**
- First result figure/table exists.

**Push**
- `paper/experiment-01-plan.md`
- `paper/experiment-01-results.md`

---

## Week 22 — Paper writing: outline + contributions + method draft v0
**Must learn**
- 📚 paper structure and “claims”

**Free resources**
- **[MUST]** Paper writing (YouTube search): https://www.youtube.com/results?search_query=how+to+write+a+research+paper+engineering  

**Career/RA/MS action (🎯)**
- Follow up on RA emails; request short meeting.

**Checkpoint**
- Outline + contributions written.

**Push**
- `paper/outline.md`
- `paper/contributions.md`

---

## Week 23 — Advanced IC topic: CDC + reset strategies (interview edge)
**Must learn**
- 🔥 CDC pitfalls + synchronizers (conceptual)
- 🔥 reset strategy + metastability awareness

**Free resources**
- **[MUST]** CDC basics (YouTube search): https://www.youtube.com/results?search_query=clock+domain+crossing+cdc+basics  
- **[MUST]** Setup/hold basics (YouTube search): https://www.youtube.com/results?search_query=setup+hold+time+explained  

**Career/RA/MS action (🎯)**
- Apply to 5 roles (volume week).

**Checkpoint**
- Explain CDC + reset hazards in 5 minutes.

**Push**
- `notes/week-23-cdc-reset.md`
- Update applications tracker

---

## Week 24 — Portfolio packaging week (recruiter + professor-ready repos)
**Must learn**
- documentation + reproducibility standard

**Free resources**
- **[MUST]** README guide: https://www.makeareadme.com/  

**Career/RA/MS action (🎯)**
- Update `embedded-journey/README.md` landing page.

**Checkpoint**
- Both project repos have clean READMEs + demo proof + folder structure.

**Push**
- `embedded-journey/README.md` updated
- `pico-data-logger` README polish + assets
- `rtl-uart-tx` README polish + assets

---

## Week 25 — Embedded interview prep + DV interview prep
**Must learn**
- 🔥 DV interview themes: corner cases, debugging, waveforms
- ⚙️ embedded pointers/bitwise/interrupt basics review

**Free resources**
- **[MUST]** Embedded interview (YouTube search): https://www.youtube.com/results?search_query=embedded+c+interview+questions  
- **[MUST]** Verilog interview (YouTube search): https://www.youtube.com/results?search_query=verilog+interview+questions  

**Career/RA/MS action (🎯)**
- 1 mock interview recorded.

**Checkpoint**
- 30 Q&As written.

**Push**
- `weeks/week-25/interview-qa-dv.md`
- `weeks/week-25/interview-qa-embedded.md`

---

## Week 26 — Research draft: intro + related work v1
**Must learn**
- 📚 writing clarity + citations discipline

**Free resources**
- **[MUST]** Google Scholar: https://scholar.google.com/  
- **[OPTIONAL]** Zotero: https://www.zotero.org/  

**Career/RA/MS action (🎯)**
- Send 1 draft section to professor/mentor for feedback.

**Checkpoint**
- 2–4 pages exist.

**Push**
- `paper/intro.md`
- `paper/related-work.md`

---

## Week 27 — Research draft: method + experiments section v1
**Must learn**
- 📚 reproducibility: describe exactly how you ran experiments

**Free resources**
- **[MUST]** Methodology writing (YouTube search): https://www.youtube.com/results?search_query=how+to+write+methodology+section+research  

**Career/RA/MS action (🎯)**
- RA meeting: prepare agenda + 2-week deliverables plan.

**Checkpoint**
- Method section replicable.

**Push**
- `paper/method.md`
- `paper/experiments.md`
- `professors/2-week-deliverables.md`

---

## Week 28 — Research draft: results + discussion v1
**Must learn**
- 📚 honest reporting + limitations

**Free resources**
- **[MUST]** Discussion section (YouTube search): https://www.youtube.com/results?search_query=how+to+write+discussion+section+research  

**Career/RA/MS action (🎯)**
- Follow up with RA targets with updated results.

**Checkpoint**
- Results story exists with figures/tables.

**Push**
- `paper/results.md`
- `paper/discussion.md`

---

## Week 29 — Final paper assembly: abstract + full draft
**Must learn**
- 📚 abstract writing + positioning

**Free resources**
- **[MUST]** Abstract writing (YouTube search): https://www.youtube.com/results?search_query=how+to+write+an+abstract+for+a+research+paper  

**Career/RA/MS action (🎯)**
- Ask for RA start date or volunteer plan.

**Checkpoint**
- Full draft exists (workshop-level).

**Push**
- `paper/abstract.md`
- `paper/full-draft.md` (or link sections)

---

## Week 30 — DV advanced: mini regression dashboard (text-based)
**Must learn**
- 🔥 regression reporting: pass rate, failing tests, seeds used
- 🔥 basic trend tracking (history file)

**Free resources**
- **[MUST]** Python tutorial: https://docs.python.org/3/tutorial/  

**Career/RA/MS action (🎯)**
- Apply to 5 roles.

**Checkpoint**
- Regression summary shows history or seed-based reproducibility.

**Push**
- `rtl-uart-tx`: improved `run_tests.py` reporting + docs
- Update applications tracker

---

## Week 31 — Capstone polish: refactor + documentation + diagrams
**Must learn**
- writing architecture diagrams and clean docs

**Free resources**
- **[MUST]** README guide: https://www.makeareadme.com/  

**Career/RA/MS action (🎯)**
- Ask 2 people to review your portfolio README.

**Checkpoint**
- Landing page reads like a professional engineering portfolio.

**Push**
- `embedded-journey/README.md` final polish
- Add diagrams/screenshots in `notes/` or project repos

---

## Week 32 — RA conversion: meeting + start task (if accepted)
**Must learn**
- how to present work briefly

**Free resources**
- **[MUST]** Research meeting prep (YouTube search): https://www.youtube.com/results?search_query=how+to+prepare+for+research+meeting+with+professor  

**Career/RA/MS action (🎯)**
- Attend meeting(s); agree on first task.

**Checkpoint**
- Defined RA task with a 2-week deadline.

**Push**
- `professors/meeting-notes-YYYY-MM-DD.md`
- Update outreach tracker with outcomes

---

## Week 33 — Execute RA task or independent replication extension
**Must learn**
- lab-specific tools or replication details

**Free resources**
- depends on topic; use Scholar + lab references

**Career/RA/MS action (🎯)**
- Show progress to professor/grad student.

**Checkpoint**
- Deliverable produced (code/data/summary).

**Push**
- `paper/experiment-03-results.md` (or lab deliverable notes)
- `reading-notes/paper-03-summary.md`

---

## Week 34 — Final integration: retrospective + next 6-month plan
**Must learn**
- evaluate what worked and what didn’t

**Free resources**
- **[MUST]** Missing Semester (review): https://missing.csail.mit.edu/  

**Career/RA/MS action (🎯)**
- Set next targets: internships + deeper DV/RTL specialization + MS application timeline.

**Checkpoint**
- You have:
  - portfolio
  - paper draft (replication-style, tied to your repos)
  - RA pipeline outcome (even “in progress”)
  - next plan

**Push**
- `weeks/week-34/final-retrospective.md`
- `resume/resume-v2.pdf`
- `paper/full-draft.md` updated