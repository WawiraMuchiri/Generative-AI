# ============================================
# main.jac
# Domain-specific nodes and routing for Codebase Genius
# Specialized agents inherit from Toolbox (defined in agentic_core.jac)
# ============================================

# -------------------------------------------------
# Imports
# -------------------------------------------------
import from agentic_core;                   # Import core nodes and walkers
import from utils { get_current_datetime };  # Utility function for timestamps
import from py_module { os, shutil };        # Python modules to clone repos or handle files

# -------------------------------------------------
# LLM Model (optional: for summarization or reasoning)
# This can be replaced by any LLM backend
# -------------------------------------------------
glob llm = Model(model_name="gpt-4o", verbose=False);

# -------------------------------------------------
# RoutingNodes Enum
# Extend the core enum to include all specialized agents
# -------------------------------------------------
enum RoutingNodes {
    GENERAL_CHAT = "GeneralChat",
    REPO_MAPPER = "RepoMapper",
    CODE_ANALYZER = "CodeAnalyzer",
    DOC_GENIE = "DocGenie"
}

# -------------------------------------------------
# Node: RepoMapper
# Responsible for cloning the repository, generating file-tree, summarizing README
# -------------------------------------------------
node RepoMapper(Toolbox) {
    has repo_url: str = "";

    # Generate a structured file-tree representation
    def generate_file_tree(repo_path: str) -> list abs;

    # Summarize README.md or entry-point docs
    def summarize_readme(repo_path: str) -> str abs;

    # Route and run: orchestrates RepoMapper tasks
    def route_and_run(utterance: str, history: str) -> str abs;
}

# -------------------------------------------------
# Node: CodeAnalyzer
# Parses source code and builds Code Context Graph (CCG)
# -------------------------------------------------
node CodeAnalyzer(Toolbox) {
    has repo_path: str = "";
    has ccg: dict = {};   # Stores relationships between functions, classes, modules

    # Parse source files using a parser like Tree-sitter
    def parse_source_files(repo_path: str) -> list abs;

    # Build the Code Context Graph
    def build_ccg(parsed_files: list) -> dict abs;

    # Query relationships in the CCG
    def query_ccg(query_str: str) -> str abs;

    # Route and run: orchestrates code analysis
    def route_and_run(utterance: str, history: str) -> str abs;
}

# -------------------------------------------------
# Node: DocGenie
# Converts structured data into human-readable markdown
# -------------------------------------------------
node DocGenie(Toolbox) {
    has repo_name: str = "";
    has markdown_path: str = "";

    # Generate markdown documentation from file-tree + CCG
    def generate_markdown(file_tree: list, ccg: dict, summary: str) -> str abs;

    # Route and run: orchestrates markdown generation
    def route_and_run(utterance: str, history: str) -> str abs;
}

# -------------------------------------------------
# Node: GeneralChat
# Simple chat agent for testing or user interaction
# -------------------------------------------------
node GeneralChat(Toolbox) {
    def chat(utterance: str, history: str) -> str by llm();
    def route_and_run(utterance: str, history: str) -> str by llm(
        method="ReAct",
        tools=([self.chat])
    );
}

# -------------------------------------------------
# Supervisor Walker: Code Genius
# Routes tasks to appropriate agents based on utterance and project state
# -------------------------------------------------
walker code_genius(agent) {
    def route_to_node(utterance: str, history: str) -> RoutingNodes {
        # Example routing logic (can be enhanced with LLM reasoning)
        if "clone repo" in utterance or "repo" in utterance {
            return RoutingNodes.REPO_MAPPER;
        }
        if "analyze code" in utterance or "build ccg" in utterance {
            return RoutingNodes.CODE_ANALYZER;
        }
        if "generate doc" in utterance or "documentation" in utterance {
            return RoutingNodes.DOC_GENIE;
        }
        # Fallback to general chat
        return RoutingNodes.GENERAL_CHAT;
    }
}

# -------------------------------------------------
# Utility walker: list all generated docs (optional)
# -------------------------------------------------
walker get_all_docs {
    obj __specs__ {
        static has auth: bool = False;
    }

    can get_all_docs with `root entry {
        # Fetch all DocGenie nodes and return their markdown paths
        doc_nodes = [here --> (`?DocGenie)];
        if not doc_nodes {
            report "No documentation found.";
            disengage;
        }

        report [node.markdown_path for node in doc_nodes];
    }
}