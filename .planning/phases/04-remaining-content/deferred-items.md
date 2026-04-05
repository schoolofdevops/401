# Deferred Items — Phase 04-remaining-content

## Build Errors in Parallel Agent Files

**Discovered during:** 04-01 execution (Docusaurus build verification)
**File:** `course-site/docs/module-07-agent-skills/reading/reference.mdx`
**Error:** MDX compilation failed — curly braces in `--query` parameter inside code blocks parsed as JSX expressions by MDX v3

**Details:**
```
Error: MDX compilation failed for file ".../module-07-agent-skills/reading/reference.mdx"
Cause: Could not parse expression with acorn
Line 68, column 49-50
```

The file contains AWS CLI `--query` parameters like `{State:State.Name,Type:InstanceType}` inside fenced code blocks. MDX v3 parses curly braces as JSX expressions even inside code blocks in some contexts.

**Impact:** Docusaurus build fails entirely, preventing production build verification.

**Not fixed here because:** This file was created by a parallel agent running plan 04-02 or 04-03. Fixing it would be outside the scope of plan 04-01 and could conflict with the parallel agent's work.

**Fix required:** In the affected file, escape or remove curly braces from `--query` parameter examples, OR use backtick-quoted code blocks with `{/* ... */}` comments, OR replace the problematic `{Key:Value}` syntax with prose descriptions.

**Recommended fix pattern:**
Replace `{State:State.Name,Type:InstanceType}` inside query strings with a note like: `"(query for State.Name, InstanceType, Placement.AvailabilityZone)"` or use a `\` escape if MDX supports it.
