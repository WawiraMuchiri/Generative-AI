
```markdown
# 🧠 Codebase Genius

## Overview
Codebase Genius is an agentic system built to autonomously analyze, understand, and document software repositories. The system uses a multi-agent architecture where each agent performs specialized tasks — from repository mapping and code graph generation to intelligent markdown documentation.

Given a GitHub repository URL, Codebase Genius:

- Clones and scans the repository.  
- Maps the folder and file structure.  
- Extracts and analyzes classes, functions, and relationships.  
- Generates a clean, readable markdown documentation file.

## Features

- Automates repository analysis and mapping.  
- Generates a Code Context Graph (CCG) for functions, classes, and modules.  
- Produces high-quality markdown documentation.  
- Supports Python and Jac codebases.  
- Modular agent design for extensibility.

## Project Structure

The project is organized into multiple files:

```

Codebase-Genius/
│
├── main.jac               # Supervisor and main entry point
├── agentic_core.jac       # Core abstractions and utilities
├── main.impl.jac          # Implementation of workflow and analysis
├── utils.jac              # Helper functions
├── outputs/               # Generated documentation output
│   └── generated_docs/
└── README.md              # Documentation

````

### 1. Supervisor & Main (main.jac)
- Orchestrates all agents.  
- Receives GitHub repository URL.  
- Delegates tasks and aggregates results into final output.

### 2. Core (agentic_core.jac)
- Defines reusable nodes, walkers, and utilities.  
- Shared abstractions for all agents.

### 3. Implementation (main.impl.jac)
- Implements workflow logic for repository mapping, code analysis, and documentation generation.

### 4. Utilities (utils.jac)
- Helper functions for parsing, file handling, and formatting.

## Prerequisites
Before running Codebase Genius, make sure you have the following installed:

- Python 3.12+  
- JAC language runtime (`jaclang`)  
  ```bash
  pip install jaclang
````

* byLLM package (if using LLM integration)

  ```bash
  pip install byllm
  ```
* An LLM provider (e.g., OpenAI, Gemini) configured in your environment.

## How to Run

Clone this repository:

```bash
git clone https://github.com/WawiraMuchiri/Generative-AI.git
cd Codebase-Genius
```

Run the JAC program:

```bash
jac serve main.jac
```

Provide a GitHub repository URL as input. The system will:

* Clone the repository.
* Map the folder/file structure.
* Generate documentation based on analysis.

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute it as long as proper attribution is provided.

````
---