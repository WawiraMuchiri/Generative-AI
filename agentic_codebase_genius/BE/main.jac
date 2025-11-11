# ================================================================
# main.jac
# Entry point of the agentic multi-agent system
# ------------------------------------------------
# Coordinates all agents using the supervisor agent
# ================================================================

# -------------------------------------------------
# Includes and Imports
# -------------------------------------------------
include agentic_core;      # brings in agentic_core.jac
include utils;             # brings in helper utilities

# -------------------------------------------------
# Enum for routing agent tasks
# -------------------------------------------------
enum RoutingNodes {
    GENERAL_CHAT = "GeneralChat";
    REPO_MAPPER = "RepoMapper";
    CODE_ANALYZER = "CodeAnalyzer";
}

# -------------------------------------------------
# Main supervisor node (entry point)
# -------------------------------------------------
walker SupervisorEntry {
    has supervisor_agent;

    can init {
        print("🚀 Initializing Supervisor System...");
        spawn here -> SupervisorAgent as supervisor_agent;
        supervisor_agent.setup_agents();
        print("✅ Supervisor system initialized successfully.\n");
    }

    can handle_request(task_type: str, task_input: str) {
        print(f"📩 Handling request of type: {task_type}");
        supervisor_agent.route_task(task_type, task_input);
    }
}

# -------------------------------------------------
# Entry execution
# -------------------------------------------------
walker main {
    can run {
        print("🧠 Starting main workflow...\n");

        # Create supervisor entry walker
        spawn here -> SupervisorEntry as entry;
        entry.init();

        # Example simulation
        entry.handle_request(RoutingNodes.GENERAL_CHAT, "Explain the concept of multi-agent systems.");
        entry.handle_request(RoutingNodes.REPO_MAPPER, "Analyze directory structure for missing modules.");
        entry.handle_request(RoutingNodes.CODE_ANALYZER, "Review code quality in utils.jac");

        print("\n✅ All tasks processed successfully.");
    }
}
