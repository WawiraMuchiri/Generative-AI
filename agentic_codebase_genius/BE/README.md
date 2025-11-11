
## **1. Functional Requirements (FRs)**

These define the **core capabilities of your multi-agent system**:

### **1.1 Supervisor Agent (Code Genius)**

* FR1: Accept a public GitHub repository URL via API or CLI.
* FR2: Validate the repository URL (reachable, correct format, public/private access).
* FR3: Orchestrate workflow between subordinate agents based on repository structure and progress.
* FR4: Aggregate intermediate outputs from subordinate agents and generate a final documentation report.
* FR5: Prioritize “high-impact” files first (e.g., main.py, app.py).
* FR6: Expose an API endpoint to trigger documentation generation and download results.

### **1.2 Repo Mapper Agent**

* FR7: Clone the repository into a temporary workspace.
* FR8: Generate a file-tree representation (folders/files), ignoring irrelevant directories like `.git` or `node_modules`.
* FR9: Summarize README.md or equivalent entry-point files into a concise overview.
* FR10: Provide file-tree and summary to the Supervisor for workflow planning.

### **1.3 Code Analyzer Agent**

* FR11: Parse source code files (Python and Jac) using Tree-sitter or similar parser.
* FR12: Construct a **Code Context Graph (CCG)**:

  * Nodes: functions, classes, modules.
  * Edges: function calls, inheritance, composition.
* FR13: Provide query APIs for Supervisor or DocGenie (e.g., “Which functions call X?”).
* FR14: Iterate over high-impact modules first, then utility modules.

### **1.4 DocGenie Agent**

* FR15: Convert structured data (file-tree + CCG) into markdown documentation.
* FR16: Include project overview, installation, usage, API reference sections.
* FR17: Include diagrams showing relationships between functions/classes.
* FR18: Ensure logical ordering, clear prose, bullet points, tables where necessary.
* FR19: Save output locally under `./outputs/<repo_name>/docs.md`.

### **1.5 System API / Interaction**

* FR20: Provide HTTP interface (Jac server with walkers) to supply repository URL.
* FR21: Return error messages if repository is invalid, inaccessible, or unsupported.

---

## **2. Non-Functional Requirements (NFRs)**

These define **how the system should behave**, including performance, usability, maintainability, and robustness:

### **2.1 Performance**

* NFR1: Should handle medium-sized Python/Jac repositories (up to ~50k lines) within reasonable time (<5 minutes for typical repos).
* NFR2: File-tree generation, CCG construction, and markdown generation should be memory-efficient.

### **2.2 Reliability & Robustness**

* NFR3: Gracefully handle invalid URLs, private repositories, unsupported languages, and parsing errors.
* NFR4: Ensure no partial or corrupt documentation is generated on failures; rollback or provide informative error.

### **2.3 Scalability & Extensibility**

* NFR5: Agents should be modular; new agents can be added without major rework.
* NFR6: Design should allow extension to other languages (e.g., JavaScript, Java).
* NFR7: CCG and file-tree structures should support arbitrarily deep repositories.

### **2.4 Usability**

* NFR8: API endpoint or CLI must return clear success/failure messages.
* NFR9: Generated markdown should be readable by humans, not just machines.

### **2.5 Maintainability & Code Quality**

* NFR10: Follow Jac best practices: modular nodes, walkers, utility functions.
* NFR11: Properly documented code for future developers.
* NFR12: Separate core abstractions (agentic_core.jac), domain logic (main.jac), implementation (main.impl.jac), utilities (utils.jac).

### **2.6 Security**

* NFR13: Temporary clone directories must be sandboxed and cleaned after execution.
* NFR14: No execution of untrusted code beyond safe parsing; no arbitrary remote code execution.

---

✅ **Strategic Takeaway:**

* Functional requirements define **what each agent does** and how the Supervisor orchestrates the workflow.
* Non-functional requirements ensure **robustness, modularity, and clarity**, which is crucial for a multi-agent system where LLMs and parsing tools interact.
