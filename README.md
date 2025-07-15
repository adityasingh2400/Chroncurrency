# ChronCurrency 🩺📲
**Edge-first copilot for ulcerative colitis and other chronic-condition warriors**

> _Track once, forget forever – and keep every byte on your own device._

---

## Why this project?
Living with a condition like UC means juggling meds, symptoms, diet tweaks, sleep hygiene and endless doctor updates. Most tracking apps are cloud-first, clunky, and still leave patients doing the heavy lifting. **ChronCurrency flips that script:**

* **Local AI, zero stigma** – All analysis runs on your phone or laptop, so no personal-health info leaves the device unless you say so.  
* **One-tap logging** – Voice, quick-emoji tap, or camera barcode scan in under three seconds. No more spreadsheet guilt.  
* **Doctor-ready briefs** – Clear trend lines and bullet-point summaries you can export as encrypted PDF / FHIR and drop straight into the visit.  
* **Actionable nudges** – Only the reminders that matter (“pack Budesonide before 8 AM class”). Silence the rest.  

---

## Key features (MVP scope)

| Category | What it does | Why it matters |
| -------- | ------------ | -------------- |
| **Logging** | Voice dictation, lock-screen widgets, pill-bottle OCR | Removes friction so you actually log every event |
| **Local AI** | Quantised 7-B LLM spots flare triggers, missed doses, sleep correlation | Fast, works offline, private |
| **Insight layer** | Daily and 30-day dashboards, deviation alerts | Doctors get signal not noise |
| **Exports** | FHIR JSON and PDF with charts | Drop-in for any EMR |
| **Privacy guardrails** | On-device encryption, zero analytics by default | HIPAA-friendly foundation |
| **Doctor messaging** | Auto-draft & send FHIR message through MyChart | Eliminates portal friction, preserves context |
| **Crowd insights** | On-device chort builder -> anonymised stats and inisightful trends | Users see evidence-based patterns without privacy leak |
| **Enhaced PUCAI** | Granular symptom capture, auto-calculates standard PUCAI plus extra metrics | Doctors keep familiar index while getting richer view |
---

## Roadmap

| Phase | Goal | Milestones |
| ----- | ---- | ---------- |
| **0 – Bootstrap** | Public repo skeleton | README, Contributing, MIT License |
| **1 – Local CLI** | Proven data model + basic stats | Rust or Python CLI, unit tests, CSV / JSON store |
| **2 – Edge AI** | On-device trigger detection | Llama-2-7B-Q4 quant run, CrewAI wrapper, benchmark battery draw |
| **2.5 – Spike detection** | Trend engine + PUCAI module | Bayesian baseline modeller; unit tests |
| **3 – iOS MVP** | Full capture → PDF flow | SwiftUI UI, Core ML quant-7B, local PDF export |
| **3.5 – MyChart pilot** | Secure portal messaging | OAuth2 flow, Epic sandbox certification |
| **4 – Pilot Study** | Real-world feedback | 10 UC patients, one GI clinic, iterate on UX |
| **5 – Anonymised cohort stats** | Opt-in aggregate insights | On-device k-anonymity check, cloud count store |

---

## High-level architecture

```mermaid
graph TD
  subgraph Device
    Input["Voice • Text • Photo • Sensor"]
    Core["ChronCurrency Core\n(Rust / Python)"]
    Model["Edge LLM\nQuantised 7-B"]
    Vault["Encrypted Vault"]
    Export["PDF & FHIR Export"]
  end

  Input --> Core
  Core  --> Model
  Model --> Core
  Core  --> Vault
  Core  --> Export
```
---

## 🧭 User flow

```mermaid
graph TD
    A["Quick-tap / Voice / MC-Q input"] --> B["Local Store<br/>(Vault)"]
    B --> C["Trend Engine"]
    C -- "Spike detected" --> D["Doctor Packet Builder"]
    D -- "FHIR or PDF" --> E["MyChart / Email Export"]

    B --> F["Aggregated Analytics<br/>(Opt-in)"]
    F -- "Counts only" --> G["Anonymised Cloud Cohort Stats"]
```

---

## Contributing

1. **Star** the repo to follow progress.  
2. **Open an issue** labelled `idea` or `bug`.  
3. **Fork & PR** – follow conventional-commit prefixes (`feat:`, `fix:`, `docs:`).  
4. **Join the chat** – Discord link coming with the first release.  

---

## License

Released under the [MIT License](LICENSE). You own your contributions; we credit every contributor.


