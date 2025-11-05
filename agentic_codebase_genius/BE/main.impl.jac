# ============================================
# main.impl.jac
# Concrete implementations of all nodes in main.jac
# Implements logic for RepoMapper, CodeAnalyzer, DocGenie
# ============================================

# -------------------------------------------------
# RepoMapper Implementations
# -------------------------------------------------
impl RepoMapper.generate_file_tree {
    # Traverse the cloned repo and build a nested list/dictionary representing the file structure
    tree = [];

    def walk_dir(path: str, tree_ref: list) {
        for entry in os.listdir(path):
            full_path = os.path.join(path, entry);

            # Ignore irrelevant directories
            if entry in [".git", "node_modules", "__pycache__"]:
                continue;

            if os.path.isdir(full_path):
                subtree = [];
                walk_dir(full_path, subtree);
                tree_ref.append({entry: subtree});
            else:
                tree_ref.append(entry);
    }

    walk_dir(repo_path, tree);
    return tree;
}

impl RepoMapper.summarize_readme {
    readme_path = os.path.join(repo_path, "README.md");
    if not os.path.exists(readme_path):
        return "No README.md found.";

    with open(readme_path, "r", encoding="utf-8") as f:
        content = f.read();

    # Use LLM to summarize README (mock example)
    summary = llm(f"Summarize the following README content concisely:\n{content}");
    return summary;
}

impl RepoMapper.route_and_run {
    # Expect utterance to contain repository URL
    self.repo_url = utterance.strip();

    # Example: clone repo into ./tmp/<repo_name>
    repo_name = self.repo_url.split("/")[-1].replace(".git", "");
    repo_path = os.path.join("./tmp", repo_name);

    # Remove existing folder if exists
    if os.path.exists(repo_path):
        shutil.rmtree(repo_path);

    # Clone repository (using git CLI)
    result = os.system(f"git clone {self.repo_url} {repo_path}");
    if result != 0:
        return f"Failed to clone repository: {self.repo_url}";

    # Generate file tree and summarize README
    file_tree = self.generate_file_tree(repo_path);
    readme_summary = self.summarize_readme(repo_path);

    # Save paths for later agents
    self.repo_path = repo_path;

    return f"Repository cloned successfully. File-tree and README summary generated.\nREADME Summary: {readme_summary}";
}

# -------------------------------------------------
# CodeAnalyzer Implementations
# -------------------------------------------------
impl CodeAnalyzer.parse_source_files {
    parsed_files = [];

    # Walk through repo_path
    for root, dirs, files in os.walk(repo_path):
        for file in files:
            if file.endswith(".py") or file.endswith(".jac"):
                full_path = os.path.join(root, file);
                with open(full_path, "r", encoding="utf-8") as f:
                    code = f.read();
                parsed_files.append({
                    "path": full_path,
                    "code": code
                });
    return parsed_files;
}

impl CodeAnalyzer.build_ccg {
    # Construct a simple Code Context Graph as a dict
    ccg = {};
    for file in parsed_files:
        code_lines = file["code"].splitlines();
        for line in code_lines:
            # Example parsing: identify function definitions
            if line.strip().startswith("def "):
                func_name = line.strip().split()[1].split("(")[0];
                ccg[func_name] = {"calls": [], "file": file["path"]};
            # Could extend: identify function calls, class relationships, etc.
    self.ccg = ccg;
    return ccg;
}

impl CodeAnalyzer.query_ccg {
    # Return information about function/class relationships
    if query_str in self.ccg:
        info = self.ccg[query_str];
        return f"{query_str} is defined in {info['file']}. Calls: {info['calls']}";
    return f"No information found for {query_str}";
}

impl CodeAnalyzer.route_and_run {
    # Parse files and build CCG
    parsed_files = self.parse_source_files(self.repo_path);
    ccg = self.build_ccg(parsed_files);
    return f"Code Analyzer completed. CCG contains {len(ccg)} functions/classes.";

# -------------------------------------------------
# DocGenie Implementations
# -------------------------------------------------
impl DocGenie.generate_markdown {
    # Simple markdown generation
    markdown_lines = [];

    markdown_lines.append(f"# Project Documentation: {self.repo_name}\n");
    markdown_lines.append("## Overview\n");
    markdown_lines.append(summary + "\n");

    markdown_lines.append("## File Tree\n");
    def format_tree(tree, indent=0):
        lines = [];
        for node in tree:
            if isinstance(node, dict):
                for k, v in node.items():
                    lines.append("  " * indent + f"- {k}/");
                    lines.extend(format_tree(v, indent + 1));
            else:
                lines.append("  " * indent + f"- {node}");
        return lines;

    markdown_lines.extend(format_tree(file_tree));

    markdown_lines.append("\n## API Reference / Functions\n");
    for func_name, details in ccg.items():
        markdown_lines.append(f"- **{func_name}** (defined in `{details['file']}`)")

    # Save markdown
    output_dir = os.path.join("./outputs", self.repo_name);
    if not os.path.exists(output_dir):
        os.makedirs(output_dir);
    markdown_path = os.path.join(output_dir, "docs.md");
    with open(markdown_path, "w", encoding="utf-8") as f:
        f.write("\n".join(markdown_lines));

    self.markdown_path = markdown_path;
    return f"Markdown documentation generated at {markdown_path}";
}

impl DocGenie.route_and_run {
    # Expect input to include summary, file_tree, and ccg from previous agents
    return self.generate_markdown(visitor.file_tree, visitor.ccg, visitor.summary);

# -------------------------------------------------
# GeneralChat Implementations
# -------------------------------------------------
impl GeneralChat.chat {
    # Simple echo or LLM call
    response = llm(f"User said: {utterance}. Provide a helpful response.");
    return response;
}

impl GeneralChat.route_and_run {
    return self.chat(utterance, history);
}
