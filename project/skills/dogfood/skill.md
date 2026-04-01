---
name: dogfood
description: Workflow interview — reflect on the current session to identify improvements to agents, hooks, skills, and workflow. Run periodically.
disable-model-invocation: true
context: fork
agent: planner
---

## Workflow Dogfooding Interview

Reflect on the current session and answer these questions:

1. **What worked well?** Which agents, skills, or hooks saved time or caught issues?
2. **What was friction?** What took too long, required too many steps, or felt clunky?
3. **Did you work sequentially on something that could have been parallel?**
4. **Any new patterns worth capturing?**
5. **Hook feedback:** Were any hooks too noisy? Missing hooks that would have helped?
6. **Agent feedback:** Did any agent feel over- or under-powered?
7. **Context management:** Did compaction happen at good times?

## Output

Append findings to `planning/dogfooding-log.md` with today's date.
