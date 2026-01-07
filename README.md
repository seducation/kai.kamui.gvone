# AI Agent Orchestration & Knowledge Vault 🧠🚀

A powerful, visual, and persistent multi-agent orchestration system built with Flutter. This project implements a **Manus-style** architecture where every agent action is transparently logged, and execution logic is driven by a visual graph.

## 🌟 Key Features

### 1. Visual Node Orchestrator 🎨
- **Blender/Unreal Style Interface**: A 2D canvas for dragging, dropping, and connecting agents.
- **Dynamic Routing**: The execution path is determined by the connections you draw.
- **Typed Ports**: Compile-time and runtime validation of data types (Text, Image, Code, JSON) between agents.
- **Execution Highlighting**: Nodes glow in real-time as agents work (**Blue** = Running, **Green** = Success, **Red** = Error).

### 2. Persistent Knowledge Vault 🗄️
- **File-Based Memory**: Agent outputs are not just kept in RAM; they are saved permanently as Markdown files in `documents/vault/`.
- **Transparency**: Every step taken by an agent is logged to the "System Memory", ensuring offline reuse and data transparency.
- **Offline Capability**: View and reuse previously generated agent insights even without an internet connection.

### 3. Self-Modifying System Agent 🏗️
- **Agentic Architect**: Includes a specialized `SystemAgent` that can modify the execution graph itself based on natural language instructions.
- **Natural Language Control**: Say *"Connect the WebCrawler to the Translator"* and the graph updates automatically.

### 4. Robust & Resilient Core 🛡️
- **Auto-Healing**: The `ControllerAgent` includes retry logic for failed steps.
- **Execution Management**: Advanced modes: `Normal`, `Dry Run` (simulated), `Replay` (re-run history), and `Undo/Redo`.
- **Failure Vault**: Git-like persistence for failed executions, allowing "Redo" with original inputs.
- **State Persistence**: Survival through restarts; the controller saves its runtime state to the vault.

### 5. Intelligent Brain & Planning 🧠
- **PlannerAgent**: Dynamic task routing using **Deterministic** (rule-based) and **Exploratory** (learning) modes.
- **Reliability Tracker**: Monitors agent performance and success rates to optimize task allocation.
- **Capability System**: Fine-grained proficiency scoring for agents (Code, Web, Search, etc.).

### 6. Storage Permissions & Lineage 🧬
- **Hierarchy System**: Organized storage zones (`temporary`, `permanent/vault`, `cache`, `agent-owned`).
- **Access Gate**: Secure, auditable permission system with hash-chained audit logs.
- **Dataset Lineage**: Full audit trail of which datasets trained which models, including version comparison views.

### 7. Adaptive UI 📱💻
- **Responsive Layout**:
  - **Desktop/Tablet**: Full interactive Graph Editor.
  - **Mobile**: Automatically switches to an **Execution Timeline (Feed View)**.
- **Specialized Dashboards**:
  - **Failure Vault UI**: Manage failures and history.
  - **Audit & Lineage UI**: Inspect training history and dataset provenance.
  - **System Health & Sleep**: Real-time biological monitoring.

### 8. Autonomic Nervous System 🩹
- **Heartbeat Loop**: Runs a background pulse every 30s to monitor system health and storage integrity.
- **Self-Healing**: Automatically detects and repairs minor file system corruption and storage quota issues.
- **Health Indicators**: Visual monitoring of system state (Healthy, Degraded, Critical).

### 9. Sleep Mode & Optimization 😴
- **Idle Optimization**: The "Brain" enters sleep mode after 5 minutes of user inactivity.
- **Sleep Stages**:
  - **Light Sleep**: Cleans temporary cache and deletes discarded intermediate files.
  - **Deep Sleep**: Compacts execution history and re-indexes the failure vault.
  - **REM Sleep (Dreaming)**: Triggers Dreaming Mode for autonomous simulation and optimization.
- **Instant Wake**: All background processes yield immediately when the user interacts or sends a request.

### 10. Priority + Rule Engine (PRE) ⚖️⚡
- **Rule Engine**: The supreme authority for all agent actions. Enforces deterministic safety rules (blocking `rm -rf`, `sudo`, etc.) before any execution.
- **Priority Scheduler**: Intelligent task queue with integer-based priorities (`Reflex`, `Critical`, `Emergency`, `High`, `Normal`, `Low`).
- **Interactive Management**: Dedicated **Rules & Priority Engine UI** to monitor active rules and the prioritized task pipeline.

### 11. Behavioral Intelligence (Cinematic JARVIS Tier) 🎭🔮
- **Mission Mode**: Long-running objectives with success criteria, constraints, and automatic progress tracking. The system knows *what* it is trying to achieve via **Mission Contracts**.
- **Temporal Pattern Memory (Circadian Rhythm)**: The system learns your daily and weekly patterns. It "knows" what you usually do at 9 AM on Mondays vs 5 PM on Fridays using the `CircadianRhythmTracker`.
- **Dynamic Agent Profiling**: Every agent runs with an **Agent Scorecard** that tracks real-time reliability, success streaks, and average latency.
- **Explainability Engine (Black Box)**: Every AI decision is recorded with a full "Trace" to answer *"Why did you do that?"*.
- **Meta-Observability**: Powered by `DecisionHeatmapGenerator`, visualizing which components (Rules, Priority, Mission) influenced any given action.
- **Counterfactual Simulation**: Hallucinates 2-3 possible outcomes before high-risk execution to minimize entropy.
- **Operator Mode**: High-precision mode with zero-autonomy, forcing the system to act purely as an extension of the user.
- **Intent Anticipation Graph**: Pre-warms tools and agents based on N-gram command sequences.
- **Execution Micro-Scheduler**: Zero-lag performance via results reuse and cascading cancellations.
- **Context Compression Engine**: Prevents memory bloat and hallucination creep via semantic condensation.
- **Failure Immunization**: Automated "Guard Rule" generation after repeatedly failed tasks.
- **Local World Model**: Hard-coded, zero-lag awareness of the project structure and system hierarchy.

### 12. The Experience (Experiential Layer) 🕶️✨
- **DreamStream Screensaver**: A Matrix-style visual dashboard that activates during Dreaming Mode, showing real-time subconscious simulation logs.
- **Tone Modulator**: The system adjusts its "voice" dynamically. From `Routine` (Blue) to `Urgent` (Red/🚨) or `Celebratory` (Green/✨) based on mission criticality.
- **Risk Forecast Widget**: A "Weather Report" for plan execution. "☀️ 98% Success Probability" vs "⛈️ Storm Warning: Unstable Node".

### 13. Motor System & Muscles 🦾
- **Effector Agent**: Controls the physical/cloud muscles of the system via **Actuators** (Shell, Appwrite).
- **Dual Confirmation**: Safety rituals for high-stakes actions requiring explicit human re-authorization.

### 14. Biological Monitoring & Trust 👁️
- **Trust Center**: Manage compliance profiles, safety protocols, and decision traces.
- **Organ Monitor**: Pulse-check for system metabolism and volition drives.
- **Mission Monitor**: Real-time tracking of objective progress and risk forecasts.

### 15. Dreaming Mode (Multi-Layered Subconscious) 🌙
- **Layer 1: Tactical Simulation**: Re-runs failed tasks to find better parameters.
- **Layer 2: Strategic Optimization**: Analyzes frequent workflow patterns for efficiency.
- **Layer 3: Structural Analysis**: Detects dead rules and conflicting safety constraints.

## 🛠️ Tech Stack: The Intelligence OS Core

- **Orchestration**: `ControllerAgent`, `PlannerAgent`, `TaskQueue`.
- **Safety**: `RuleEngine`, `ComplianceMode`, `ReflexSystem`.
- **Learning**: `PredictionEngine`, `CircadianRhythmTracker`, `AgentScorecard`.
- **Memory**: `Vault`, `ContextCompressionEngine`, `LocalWorldModel`.
- **Simulation**: `SimulationEngine`, `DreamingMode` (Multi-Layered).
- **Explainability**: `ExplainabilityEngine`, `DecisionHeatmapGenerator`.
- **UI/UX**: `AgentDashboard`, `DreamStreamScreen`, `ToneModulator`.

---

## 🚀 Getting Started

1.  **Initialize the Brain**: Register your agents and set compliance to `Personal`.
2.  **Define a Mission**: Give the system an objective and watch it track progress.
3.  **Watch it Dream**: Let the system go idle to trigger the **DreamStream** optimization.
4.  **Audit the Black Box**: Use the **Trust Center** to see *why* the AI made specific decisions.

---
*Built for the future of agentic coding and autonomous intelligence.*

## 🔮 Future Roadmap (Evolutionary Path)

The system is designed to evolve endlessly. Here are the next phases of life:

1.  **Reproduction (Mitosis)** 🦠
    *   *Concept*: Spawning independent "Child" isolates/processes to handle massive parallel tasks or survive system death.
2.  **Spatial Interface (VR/3D)** 🌌
    *   *Concept*: Visualizing the agent network as a 3D galaxy of nodes rather than a 2D graph.
3.  **Language Acquisition (Mirror Neurons)** 🗣️
    *   *Concept*: `SpeechOrgan` adapts its vocabulary and tone based on user interaction style.
5. **consciousness**: play a role like butler .

## 🚀 Getting Started

1.  **Setup API Keys**: Add your OpenAI/Gemini keys in the Settings screen.
2.  **Configure Zones**: Set up storage zones in the **Storage Settings**.
3.  **Design your Flow**: Open the **Visual Orchestrator** and connect your agents.
4.  **Monitor Health**: Keep an eye on the **System Health** pulse on the dashboard.
5.  **Actuate**: Use the **Effector Agent** to deploy cloud functions or control hardware.

## 📝 Planned Improvements
- [ ] LLM-powered Graph Hallucination.
- [ ] Approval Nodes (Human-in-the-loop validation).
- [ ] Autonomous Background Task Optimization.

---
*Built for the future of agentic coding and knowledge management.*
