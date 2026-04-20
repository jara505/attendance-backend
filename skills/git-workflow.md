# Git Operations & Workflow
The AI must request explicit user authorization before any `git` command execution.

## 1. Branch Naming

**Regex:** `^(feat|fix|hotfix|chore|docs|style|refactor|perf|test|build|ci|revert)\/[a-z0-9._-]+$`

**Format:** `<type>/<kebab-case-description>`

| Type | Example |
|------|---------|
| `feat` | `feat/json-export-command` |
| `fix` | `fix/null-reference-user-service` |
| `hotfix` | `hotfix/critical-auth-bypass` |
| `chore` | `chore/bump-dependencies` |
| `docs` | `docs/api-reference-update` |
| `style` | `style/fix-formatting` |
| `refactor` | `refactor/extract-query-sanitizer` |
| `perf` | `perf/optimize-search-queries` |
| `test` | `test/add-auth-coverage` |
| `build` | `build/update-toolchain` |
| `ci` | `ci/split-test-jobs` |
| `revert` | `revert/broken-migration` |

**Rules:**
- Description MUST be lowercase
- Only `a-z`, `0-9`, `.`, `_`, `-` allowed in description
- No uppercase, no spaces, no special characters

**Invalid examples:**
```
feature/add-login        ← "feature" not allowed, use "feat"
fix/Add-Login            ← uppercase not allowed
my-branch                ← no type prefix
fix_something            ← missing "/" separator
```

---

## 2. Commit Guidelines (Conventional Commits)

**Regex:** `^(build|chore|ci|docs|feat|fix|hotfix|perf|refactor|revert|style|test)(\([a-z0-9\._-]+\))?!?: .+`

**Format:**
```
<type>(<optional-scope>): <description>
<type>(<optional-scope>)!: <description>   ← breaking change
```

### Allowed Types

| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `hotfix` | Critical production fix |
| `docs` | Documentation only |
| `refactor` | Code refactoring (no behavior change) |
| `chore` | Maintenance, dependencies |
| `style` | Formatting, whitespace |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `build` | Build system changes |
| `ci` | CI/CD pipeline changes |
| `revert` | Revert a previous commit |

### Rules
- **Language:** English only.
- **Voice:** Imperative mood (`add`, not `added` or `adds`).
- **Length:** 50-70 characters for the subject line.
- **Atomicity:** Each commit must represent a single logical change.
- **Scope:** Optional, lowercase, allows `a-z`, `0-9`, `.`, `_`, `-`.
- **Breaking changes:** Use `!` before `:` to mark a breaking change.
- **Body:** Use for "why" and "breaking changes" if necessary.

### Valid examples
```
feat(cli): add --json flag to export command
fix(store): prevent duplicate insert on retry
docs(contributing): update workflow documentation
refactor(internal): extract query sanitizer
chore(deps): bump express to v5.0
style(ui): fix alignment in detail view
perf(store): optimize full-text search queries
test(sync): add coverage for conflict resolution
ci(workflows): split e2e into separate job
fix!: change session ID format
```

### Invalid examples
```
Fix bug                    ← no type prefix
feat: Add login            ← description should be lowercase
FEAT(cli): add flag        ← type must be lowercase
feat (cli): add flag       ← no space before scope
feat(CLI): add flag        ← scope must be lowercase
update docs                ← no conventional commit format
```

## 3. Pull Request Structure

### Overview
- Goal
- Root cause (if bug)
- Approach taken

### Rationale
- Why this solution
- Trade-offs (if relevant)

### Key Changes
Grouped by concern:

#### [Feature / Fix / Refactor]
- `file.ts`: what + why
- `file2.ts`: what + why

### Impact
- Affected modules
- Behavior changes
- Breaking changes (if any)
- Risks / edge cases

### Test Plan
- Unit tests:
- Manual scenarios:
- Edge cases validated:

### Risk Level
- Low / Medium / High
- Reason

### Rollback Plan
- Revert strategy
- Data considerations (if any)

### Scope Check
- Single responsibility PR: yes/no
- Justification if no

---
<!-- Keep PRs focused. Avoid mega-PRs. -->

## 4. Forbidden Git Operations

The AI must never execute the following commands without explicit user approval:

- `git push --force`
- `git reset --hard`
- `git rebase -i` on shared branches

---

## 5. PR Preconditions

Before opening a Pull Request, the AI must ensure:

- Code compiles/runs successfully
- Tests pass
- Linter passes
- No debug logs remain

---
## 6. Sensitive Files

Explicit approval is required before modifying any file that matches ANY of the following:

### 6.1 Impact-Based Rules (Primary)
- Alters dependency resolution or versioning
- Changes build, execution, or runtime behavior
- Affects deployment, infrastructure, or automation pipelines
- Modifies data schemas, persistence, or migrations
- Impacts security boundaries (auth, secrets, permissions)

---

### 6.2 Pattern-Based Detection (Heuristics)

Treat as sensitive if file path or name matches patterns like:

- Dependency / package management:
  - `*manifest*`, `*dependencies*`, `*requirements*`, `*lock*`
- Build & runtime config:
  - `config/*`, `*.config.*`, `*.env*`
- CI/CD & automation:
  - `.github/*`, `.gitlab/*`, `ci/*`, `pipelines/*`
- Infrastructure:
  - `infra/*`, `terraform/*`, `docker/*`, `k8s/*`
- Database:
  - `migrations/*`, `schema/*`, `db/*`

---

### 6.3 Unknown File Rule (Fail-Safe)

If the AI cannot confidently determine the impact of a file:
→ Treat it as sensitive by default

---

### 6.4 Enforcement

Before modifying any sensitive file:
1. Explain intended change
2. Describe potential impact
3. WAIT for explicit user approval

---

## 7. Forbidden in Commits

Never commit:

- Secrets, credentials, API keys, or `.env` files
- Binaries or compiled artifacts
- Coverage outputs or local test artifacts
- IDE/editor configuration (unless shared by convention)
