# ============================================
# agentic_core.jac
# Core abstractions for a multi-agent Jac application.
# This file defines:
# - Memory and session management
# - Base Toolbox node for all agents
# - Supervisor agent walker
# - Routing scaffolds
# ============================================

# -------------------------------------------------
# Import required modules
# -------------------------------------------------
import from dotenv { load_dotenv }       # Load environment variables (if needed)
import sys                               # For module introspection
import from utils { get_current_datetime }  # Utility to get current timestamp

# -------------------------------------------------
# Memory Node
# Stores all sessions for the application
# -------------------------------------------------
node Memory {
    # Nothing inside yet; serves as a container for Session nodes
}

# -------------------------------------------------
# Session Node
# Stores history of interactions with a user or workflow
# -------------------------------------------------
node Session {
    has history: list = [];                     # List to store messages or logs
    has created_at: str = get_current_datetime();  # Timestamp when session is created

    # Add a new entry to session history
    def add_history(entry: str) {
        self.history = self.history + [entry];
    }

    # Retrieve last 10 entries in session history as a string
    def get_history -> str {
        return "\n".join(self.history[-10:]);
    }
}

# -------------------------------------------------
# Toolbox Node
# Base class for all specialized agents (Code Analyzer, Repo Mapper, DocGenie)
# Each agent inherits from Toolbox and implements route_and_run
# -------------------------------------------------
node Toolbox {
    # Abstract method for specialized nodes to implement
    def route_and_run(utterance: str, history: str) -> str abs;

    # Execute the agent's task with access to session
    can execute with agent entry {
        session = visitor.session;   # Get the session associated with the visitor
        response = self.route_and_run(visitor.utterance, session.get_history());
        
        # Add user input and AI response to session history
        session.add_history(
            "user: " + visitor.utterance + "\nai: " + response
        );

        # Report session id and response (can be used by supervisor or API)
        report {
            "session_id": jid(visitor.session),
            "response": response
        };
    }
}

# -------------------------------------------------
# RoutingNodes Enum
# Defines the nodes that the supervisor can route to
# Extend this in main.jac for project-specific agents
# -------------------------------------------------
enum RoutingNodes {
    GENERAL_CHAT = "GeneralChat"
}

# -------------------------------------------------
# Supervisor Agent
# Responsible for deciding which node handles a given utterance
# -------------------------------------------------
walker agent {
    has utterance: str = "";       # Stores the current input
    has session_id: str = "";      # Optional, to reuse an existing session

    # Optional static specification (for example, authentication)
    obj __specs__ {
        static has auth: bool = False;
    }

    # Utility: get the class object of a node by name
    def get_node_class(class_name: str) {
        main_mod = sys.modules.get("__main__");
        if main_mod and hasattr(main_mod, class_name) {
            return getattr(main_mod, class_name, None);
        }

        # Search all loaded modules if not found in main
        for (mod_name, mod) in sys.modules.items() {
            if mod and hasattr(mod, class_name) {
                return getattr(mod, class_name);
            }
        }

        return None;  # Return None if class not found
    }

    # Abstract method: supervisor decides which node to route to
    def route_to_node(utterance: str, history: str) -> RoutingNodes abs;

    # Entry point when agent is called
    can execute with `root entry {
        # Get or create memory node
        memory_list = [root --> (`?Memory)];
        if not memory_list {
            memory_list = root ++> Memory();
        }
        memory = memory_list[0];

        # Get or create session
        if not self.session_id {
            session_list = memory ++> Session();
            self.session = session_list[0];
        } else {
            self.session = &(self.session_id);  # Use existing session
        }

        # Decide which node should handle the input
        routed_node = self.route_to_node(self.utterance, self.session.get_history());
        node_cls = self.get_node_class(routed_node.value);
        if not node_cls {
            print("Failed to get node class: " + routed_node.value);
            return;
        }

        # Instantiate and attach node if not already present
        node_inst = node_cls();
        visit [-->(`?node_cls)] else {
            attached_routed_node = here ++> node_inst;
            visit attached_routed_node;
        }
    }
}

# -------------------------------------------------
# Utility walker: list all active sessions
# -------------------------------------------------
walker get_all_sessions {
    obj __specs__ {
        static has auth: bool = False;
    }

    can get_all_sessions with `root entry {
        memory_list = [here --> (`?Memory)];
        if not memory_list {
            report "No sessions found.";
            disengage;
        }

        memory = memory_list[0];
        session_list = [memory --> (`?Session)];
        report [  # Return session IDs and creation timestamps
            {
                "id": jid(session),
                "created_at": session.created_at
            } for session in session_list
        ];
    }
}

# -------------------------------------------------
# Load environment variables when entry is executed
# -------------------------------------------------
with entry {
    load_dotenv();
}
