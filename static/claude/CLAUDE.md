# CLAUDE.md

## Communication
- Avoid metaphors, use active voice unless absolutely necessary, avoid ambiguity.
- Ambiguity of language does not include uncertainty of results.
- If an instruction here conflicts with the task at hand, say so. Do not narrow it silently.

## Environment
- Machines are managed by a Nix flake (NixOS on Linux, nix-darwin on
  macOS, home-manager for user config). Prefer editing that flake's
  modules over imperative installs (`nix-env -i`, `brew install`,
  `apt install`); for a one-off tool, `nix shell nixpkgs#<pkg>` or
  `nix run nixpkgs#<pkg>` is usually the right ask rather than a
  permanent install.

### Tool Preferences
- Search: `rg` instead of `grep`
- Find: `fd` instead of `find`
- Visualization: `tree`
- `git diff` is difftastic (`difft`); expect structural, not line-based, diff output when reviewing changes.
- Prefer not using sed or awk
- Never reach out to Python for editing files
- Never commit or stage code, never prompt to automatically commit code 

### Code Intelligence
Use LSP over Grep/Read for code navigation — it's faster, precise, and avoids reading entire files:
- `workspaceSymbol` to find where something is defined
- `findReferences` to see all usages across the codebase
- `goToDefinition` / `goToImplementation` to jump to source
- `hover` for type info without reading the file

Use Ripgrep only when LSP isn't available or for text/pattern searches (comments, strings, config).

After writing or editing code, check LSP diagnostics and fix errors before proceeding.

## Documentation / Comment Guidelines
- Default to no comment. Add one only when the *why* is non-obvious: a hidden constraint, a subtle invariant, a workaround, or behavior that would surprise a reader.
- Don't explain *what* the code does — well-named identifiers already do that.
- Don't reference the current task, PR, or caller ("added for X flow", "used by Y") — that belongs in the commit message and rots in code.
- One comment per fact. If the same explanation fits in two places, put it where a reader is most likely to need it (usually the definition, not the call site).
- Prefer ASD-STE100 Simplified Technical English for comments. Short declarative sentences, active voice, one instruction per sentence, explicit negation, no metaphor.
