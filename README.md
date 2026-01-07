# create-pr

A powerful GitHub Pull Request creation tool with Oh My Zsh plugin integration. Automates the tedious parts of PR creation while giving you full control over the process.

## 🚀 Features

- **Smart Branch Management**: Automatically creates branches from PR titles or uses existing branches
- **Template Support**: Integrates with `.github/PULL_REQUEST_TEMPLATE.md` with custom lyrics injection
- **Draft Mode**: Creates draft PRs by default for safer workflow
- **Intelligent Defaults**: Auto-detects titles from commit history
- **Dry Run Mode**: Preview what will happen before executing
- **Oh My Zsh Integration**: Rich plugin with aliases, completion, and convenience functions

## 📦 Installation

### Method 1: Oh My Zsh Plugin (Recommended)

```bash
# Clone this repository to your Oh My Zsh custom plugins directory
git clone https://github.com/snirsh/create-pr ~/.oh-my-zsh/custom/plugins/create-pr

# Add 'create-pr' to your plugins list in ~/.zshrc
plugins=(... create-pr)

# Reload your shell
source ~/.zshrc
```

### Method 2: Direct Installation

```bash
# Clone anywhere and add to PATH
git clone https://github.com/snirsh/create-pr ~/tools/create-pr
echo 'export PATH="$HOME/tools/create-pr:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Method 3: Manual Installation

```bash
# Download just the script
curl -o ~/bin/create-pr https://raw.githubusercontent.com/snirsh/create-pr/main/create-pr
chmod +x ~/bin/create-pr
```

## 🛠 Prerequisites

- **git**: Version control system
- **gh**: GitHub CLI tool (`brew install gh` or see [GitHub CLI installation](https://cli.github.com/))
- **bc**: Basic calculator (usually pre-installed on macOS/Linux)
- **perl**: For template processing (usually pre-installed)

Verify prerequisites:
```bash
git --version
gh --version
which bc perl
```

## 💡 Usage

### Basic Commands

```bash
# Create PR from current branch (auto-detects title)
create-pr

# Create PR with specific branch and title
create-pr feature/login-fix "Fix user login validation bug"

# Create PR with title (auto-generates branch name)
create-pr "" "Add user authentication system"

# Preview what would happen (dry run)
create-pr -n

# Create ready-to-merge PR (no draft, no template)
create-pr --no-draft --no-template
```

### Oh My Zsh Plugin Commands

When using the plugin, you get these additional conveniences:

#### Aliases
```bash
cpr                    # create-pr
cprn                   # create-pr -n (dry run)
cprd                   # create-pr --no-draft
cprt                   # create-pr --no-template
cpro                   # create-pr --no-open
```

#### Smart Functions
```bash
# Smart PR creation with auto-detection
quick-pr                           # Use current branch
quick-pr "Fix login bug"           # Create branch from title
quick-pr feature/auth "Add auth"   # Specific branch + title

# Explicit workflow functions
draft-pr feature/new               # Force draft mode
ready-pr                          # No draft, no template
preview-pr -b develop             # Dry run against develop

# Get help
cpr-help                          # Show plugin help
```

#### Tab Completion

The plugin provides intelligent tab completion:
- Branch names (existing branches)
- Recent commit messages as title suggestions
- Command flags and options
- Common PR title patterns (fix:, feat:, docs:, etc.)

### Command Line Options

```
Options:
  -t, -T              Use PR template (default: yes)
  -d, -D              Create as draft (default: yes)
  -o, -O              Open in browser (default: yes)
  -n, -N              Dry run (show what would happen)
  -b, -B <branch>     Base branch (default: master)
  --no-template       Don't use PR template
  --no-draft          Don't create as draft
  --no-open           Don't open in browser
  -h, --help          Show help message
```

## 🎯 Workflow Examples

### Scenario 1: Feature Development
```bash
# Start from master, make changes, create PR
git checkout master
# ... make changes and commit ...
quick-pr "Add user profile page"
# Creates branch 'add-user-profile-page', pushes, creates draft PR
```

### Scenario 2: Hotfix
```bash
# Quick fix that's ready to merge
git checkout master
# ... make urgent fix ...
ready-pr hotfix/critical-bug "Fix critical security vulnerability"
# Creates non-draft PR without template, ready for immediate review
```

### Scenario 3: Existing Branch
```bash
# Working on existing feature branch
git checkout feature/authentication
# ... make changes ...
cpr  # Creates PR from current branch with auto-detected title
```

### Scenario 4: Preview Mode
```bash
# Check what would happen before creating PR
preview-pr feature/new-api "Add REST API endpoints"
# Shows all actions without executing them
```

## 📝 Template Integration

### PR Template Support
Place your template at `.github/PULL_REQUEST_TEMPLATE.md`:

```markdown
## Description
Brief description of changes

## Changes
- [ ] Feature A
- [ ] Feature B

## Testing
‼️ ➡️ Enter long description here ⬅️

## Checklist
- [ ] Tests added
- [ ] Documentation updated
```

### Custom Lyrics Integration
The special marker `‼️ ➡️ Enter long description here ⬅️` gets replaced with content from the `lyrics` file in the same directory. This allows for fun, personalized PR descriptions.

## 🧪 Testing

### Manual Testing
```bash
# Test in dry run mode
create-pr -n "test-branch" "Test PR Creation"

# Test with different options
create-pr -n --no-draft --no-template feature/test "Test"

# Test plugin functions
preview-pr "test-branch" "Test Title"
```

### Integration Testing
```bash
# Create a test repository
mkdir test-create-pr && cd test-create-pr
git init
echo "test" > README.md
git add . && git commit -m "Initial commit"
gh repo create --private

# Test the tool
preview-pr "test-feature" "Test PR"  # Should show what would happen
```

### Testing Checklist
- [ ] Dry run mode works correctly
- [ ] Branch creation from title works
- [ ] Existing branch detection works
- [ ] Template processing works
- [ ] GitHub CLI integration works
- [ ] Plugin aliases work
- [ ] Tab completion works
- [ ] Error handling is graceful

## 🔧 Maintenance

### Automatic Cleanup

The tool automatically handles git housekeeping:
- **Prunes stale remote-tracking branches** before each PR creation
- **Cleans up orphaned commits** when branching from master (expires reflog + runs gc)

This prevents accumulation of stale refs and unreachable objects that would otherwise require manual `git prune` or `git gc`.

### Regular Updates
```bash
# Update the tool
cd ~/.oh-my-zsh/custom/plugins/create-pr  # or wherever you cloned it
git pull origin main

# Reload zsh to get updates
source ~/.zshrc
```

### Configuration
The tool uses these default settings:
- **Template**: Enabled by default
- **Draft**: Enabled by default  
- **Open browser**: Enabled by default
- **Base branch**: master

These can be overridden with command flags or by modifying the script's default values.

### Customization

#### Adding Custom Aliases
Add to your `~/.zshrc`:
```bash
alias my-pr='create-pr --no-draft --no-template'
alias urgent-pr='create-pr --no-draft -b master'
```

#### Custom Base Branch
```bash
# Always use 'main' as base branch
alias cpr='create-pr -b main'
```

### Troubleshooting

#### Common Issues

**"Error: GitHub CLI (gh) is not installed"**
```bash
# Install GitHub CLI
brew install gh  # macOS
# or follow https://cli.github.com/
```

**"Error: Not in a git repository"**
```bash
# Initialize git repo
git init
# or navigate to existing repo
cd /path/to/your/repo
```

**"No commits found against master"**
```bash
# Make sure you have commits
git log --oneline
# Or specify a different base branch
create-pr -b main
```

**"Plugin functions not working"**
```bash
# Check if plugin is loaded
echo $plugins | grep create-pr
# Reload zsh
source ~/.zshrc
# Check if create-pr is in PATH
which create-pr
```

#### Debug Mode
Use the dry run flag to debug issues:
```bash
create-pr -n  # Shows debug output
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test with `create-pr -n`
5. Commit: `git commit -m "Add amazing feature"`
6. Create PR: `create-pr feature/amazing-feature "Add amazing feature"`

## 📜 License

MIT License - feel free to use and modify as needed.

## 🙏 Acknowledgments

- GitHub CLI team for the excellent `gh` tool
- Oh My Zsh community for the plugin framework
- Michael Jackson for the smooth criminal lyrics 🕺 