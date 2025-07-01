# create-pr.plugin.zsh
# Oh My Zsh plugin for create-pr tool
# 
# This plugin provides convenient aliases, functions, and completion
# for the create-pr GitHub PR creation tool.

# Get the directory where this plugin is located
PLUGIN_DIR="${0:A:h}"

# Add this directory to PATH if create-pr is here and not already in PATH
if [[ -f "$PLUGIN_DIR/create-pr" ]] && [[ ":$PATH:" != *":$PLUGIN_DIR:"* ]]; then
    export PATH="$PLUGIN_DIR:$PATH"
fi

# Convenient aliases
alias cpr='create-pr'
alias cprn='create-pr -n'              # dry run
alias cprd='create-pr --no-draft'      # no draft
alias cprt='create-pr --no-template'   # no template
alias cpro='create-pr --no-open'       # don't open browser

# Functions will be defined after _check_git_repo with git repo validation

# Function to check if we're in a git repo and give helpful feedback
_check_git_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "❌ Not in a git repository. Please run this command from within a git repository."
        return 1
    fi
    return 0
}

# Store original function definitions
_original_quick_pr() {
    local usage="Usage: quick-pr [branch_name] [title]
    
Creates a PR with smart defaults:
- No args: Use current branch and auto-detect title
- One arg: If it's a git branch, use it; otherwise treat as title
- Two args: branch_name and title

Examples:
  quick-pr                           # Use current branch
  quick-pr \"Fix user login bug\"      # Create branch from title
  quick-pr feature/login \"Fix bug\"   # Use specific branch and title"

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "$usage"
        return 0
    fi
    
    if [[ $# -eq 0 ]]; then
        # No args - use current branch and auto-detect title
        create-pr
    elif [[ $# -eq 1 ]]; then
        # One arg - check if it's an existing branch
        if git show-ref --verify --quiet "refs/heads/$1" 2>/dev/null || 
           git show-ref --verify --quiet "refs/remotes/origin/$1" 2>/dev/null; then
            # It's a branch name
            create-pr "$1"
        else
            # Treat as title, let create-pr generate branch name
            create-pr "" "$1"
        fi
    else
        # Multiple args - pass through to create-pr
        create-pr "$@"
    fi
}

_original_draft_pr() {
    create-pr -d "$@"
}

_original_ready_pr() {
    create-pr --no-draft --no-template "$@"
}

_original_preview_pr() {
    create-pr -n "$@"
}

# Wrapper functions that check git repo first
quick-pr() {
    _check_git_repo && _original_quick_pr "$@"
}

draft-pr() {
    _check_git_repo && _original_draft_pr "$@"
}

ready-pr() {
    _check_git_repo && _original_ready_pr "$@"
}

preview-pr() {
    _check_git_repo && _original_preview_pr "$@"
}

# Help function
cpr-help() {
    echo "🚀 create-pr Oh My Zsh Plugin Help"
    echo ""
    echo "Aliases:"
    echo "  cpr                    - create-pr"
    echo "  cprn                   - create-pr with dry run (-n)"
    echo "  cprd                   - create-pr without draft (--no-draft)"
    echo "  cprt                   - create-pr without template (--no-template)"
    echo "  cpro                   - create-pr without opening browser (--no-open)"
    echo ""
    echo "Functions:"
    echo "  quick-pr [branch] [title]  - Smart PR creation with auto-detection"
    echo "  draft-pr [...]             - Force draft mode"
    echo "  ready-pr [...]             - No draft, no template (quick merge)"
    echo "  preview-pr [...]           - Dry run mode"
    echo "  cpr-help                   - Show this help"
    echo ""
    echo "Examples:"
    echo "  cpr                        - Create PR from current branch"
    echo "  quick-pr \"Fix login bug\"   - Create branch and PR from title"
    echo "  draft-pr feature/new       - Create draft PR from specific branch"
    echo "  ready-pr                   - Create ready-to-merge PR"
    echo "  preview-pr -b develop      - Preview PR creation against develop"
    echo ""
    echo "For full create-pr options, run: create-pr --help"
}

# Tab completion for our functions
if [[ -f "$PLUGIN_DIR/_create-pr" ]]; then
    # Load completion if the completion file exists
    fpath=("$PLUGIN_DIR" $fpath)
    autoload -U compinit && compinit
fi 