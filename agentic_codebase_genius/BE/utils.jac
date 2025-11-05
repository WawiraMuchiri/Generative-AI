# ============================================
# utils.jac
# Utility functions for Codebase Genius agents
# ============================================

# -------------------------------------------------
# Import required modules
# -------------------------------------------------
import from datetime { datetime }   # To work with timestamps
import from os { path, makedirs }   # For file and directory handling

# -------------------------------------------------
# Function: get_current_datetime
# Returns the current date and time as a string
# -------------------------------------------------
def get_current_datetime() -> str {
    # Example format: 2025-11-05 18:30:00
    return str(datetime.now());
}

# -------------------------------------------------
# Function: ensure_dir_exists
# Creates a directory if it does not exist
# Useful for output folders like ./outputs/<repo_name>
# -------------------------------------------------
def ensure_dir_exists(dir_path: str) {
    if not path.exists(dir_path):
        makedirs(dir_path);
}

# -------------------------------------------------
# Function: clean_repo_name
# Converts a GitHub repo URL into a safe folder name
# Example: https://github.com/user/my-repo.git -> my-repo
# -------------------------------------------------
def clean_repo_name(repo_url: str) -> str {
    # Remove trailing .git if present
    repo_name = repo_url.split("/")[-1];
    if repo_name.endswith(".git"):
        repo_name = repo_name[:-4];
    return repo_name;
}

# -------------------------------------------------
# Function: is_valid_url
# Simple check to validate a GitHub repository URL
# -------------------------------------------------
def is_valid_url(url: str) -> bool {
    # Basic check for "https://github.com/"
    return url.startswith("https://github.com/") or url.startswith("git@github.com:");
}

# -------------------------------------------------
# Function: flatten_file_tree
# Converts nested file-tree structure into a flat list of file paths
# Useful for analysis or iteration
# -------------------------------------------------
def flatten_file_tree(tree: list, parent_path: str = "") -> list {
    flat_list = [];
    for node in tree:
        if isinstance(node, dict):
            for folder_name, subtree in node.items():
                folder_path = path.join(parent_path, folder_name);
                flat_list.extend(flatten_file_tree(subtree, folder_path));
        else:
            flat_list.append(path.join(parent_path, node));
    return flat_list;
}
