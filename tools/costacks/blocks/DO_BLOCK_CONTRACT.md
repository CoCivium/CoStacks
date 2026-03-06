# CoStacks DO Block Contract (Header-Only)

## Rule
All operator guidance must appear at the **top** of the block.
Nothing meaningful should appear **after** the executable block finishes, except optional blank lines.

## Why
- avoids waiting for browser/DOM/render lag to reveal footer instructions
- keeps copy/paste affordances on screen near the only instructions that matter
- reduces operator fatigue
- makes blocks more deterministic for zombie-mode execution

## Required pattern
1. One short **header comment** before the block
2. Executable block
3. End with a trailing newline only
4. No footer instructions
5. No sentinel phrases required for humans unless absolutely necessary
6. If a block needs a human decision, put it in the header comment, not the bottom

## Preferred header fields
- session / source
- intent
- expected success condition
- whether violet / CoPong is expected
- whether operator should wait or do nothing after paste

## Anti-patterns
- footer guidance
- “scroll down for next step”
- meaningful text after execution
- sentinel-only UX as substitute for clear header
- prose leaks inside executable code

## Preferred ending
A successful block should simply return to prompt.
## Addendum: terminal-end visual cue
- Prefer ENDS_AT_PROMPT=YES in the header.
- Prefer the closing line as } # END when a visual delimiter helps.
- Do not put meaningful footer text after the block.

## Addendum: verified git rule
- Never report push success from local HEAD alone.
- Success requires git fetch origin and origin/main == HEAD after push.
- If pull or push fails, the block must fail closed.
