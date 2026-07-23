---
name: local-evidence-flow
description: Route explicit `/flow` requests to one evidence-based stage. Do not infer Flow from ambiguity, task size, debugging, review, risk, or tool-call count.
---

# 本地证据 Flow

只在用户明确输入 `/flow` 时使用此入口。其他工作仍按直接模式处理，包括有歧义、多步骤、调试、验证、审查和高风险的任务；需要时用简短任务约定和 `update_plan` 处理。选择一个阶段，只加载对应的具体 Skill。

## Flow Gate

对较复杂的工作，在编辑或运行长工具链前先分类：

```text
要进入的 Flow 阶段：<明确任务 | 方案设计 | 任务拆分 | 实施 | 诊断 | 验证 | 审查>
原因：
需要先明确任务要求：<是 | 否>
```

行为、范围、验收条件或验证不清晰时，使用 `flow-frame-contract`；否则继续匹配阶段。

## 检查点展示

每个阶段结束时，使用 `workflow_gate.py checkpoint` 存储精确的 `workflow-result`，再展示简洁的 Flow Checkpoint 卡片，包含阶段、状态、下一动作、摘要、证据和打印出的 `Workflow-Checkpoint` ID。不要在聊天中渲染原始 JSON 或 `<details>`。卡片与存储的 JSON 必须具有相同状态。

## Workflow Gate 协议

只有阶段走到 `next_stage: "completed"`，或确实因 `blocked` 需要外部输入时，才结束 `/flow`。尚未结束的结果只是正常检查点，不代表任务完成。

使用完全一致的顶层结果形状：

```workflow-result
{"protocol":"workflow-gate/v1","kind":"flow_stage","stage":"<frame|design|slice|build|diagnose|verify|review>","status":"<in_progress|passed|blocked>","summary":"...","next_stage":"<stage|completed|null>","data":{},"evidence":[]}
```

人类可读检查点卡片前，存储精确 JSON：

```bash
python3 "$HOME/.codex/hooks/workflow_gate.py" checkpoint <<'JSON'
{ ...complete workflow-result JSON... }
JSON
```

在卡片中呈现打印出的 `WORKFLOW_CHECKPOINT` ID；`passed` 使用 `✅`，`in_progress` 使用 `🟡`，`blocked` 使用 `⛔`：

```md
### <✅|🟡|⛔> Flow Checkpoint

- **阶段：** `<stage>`
- **状态：** `<passed|in_progress|blocked>`
- **下一步：** `<next_stage|继续当前阶段|等待输入|完成>`
- **摘要：** <one concise sentence>
- **证据：** <short evidence summary>

Workflow-Checkpoint: `cp-...`
```

- 将原始 JSON 保留在 `~/.codex/workflow-gate/<cwd-hash>/checkpoints/`；不要在聊天中展示。卡片与存储 JSON 必须匹配，最终卡片恰好包含一个 `Workflow-Checkpoint` 标记。
- `passed` 阶段只能按 `frame->design->slice->build->verify->review->completed` 推进；`diagnose` 可推进到 `frame`、`build`、`verify` 或 `completed`。 `in_progress` 和 `blocked` 使用 `next_stage: null`。
- 包含阶段数据：`frame`=`goal,scope,acceptance,verification`；`design`=`approach,tradeoffs,affected_areas`；`slice`=`slice_id,tasks,allowed_write_scope,verification_commands`；`build`=`changed_files,commands_run,verification_commands`；`diagnose`=`symptom,evidence,root_cause,next_action`；`verify`=`result,receipt_ids,checks`；`review`=`verdict,findings,accepted_risks`。
- 对 `verify`，首个必需检查通过 `python3 "$HOME/.codex/hooks/workflow_gate.py" receipt --stage verify -- <verification-command>` 运行；不要先普通运行再为 receipt 重跑。复用仍有效的成功 receipt，并将每个使用的 `WORKFLOW_RECEIPT` ID 纳入 `data.receipt_ids`。
- 阶段 `passed` 但尚未结束时，在同一请求中继续进入声明的下一阶段。`in_progress` 必须继续；`blocked` 只能因外部输入或状态变化停止；其他情况只有在 `next_stage: "completed"` 时结束。

## 按任务选择 Skill

- 任务要求或边界不清：`flow-frame-contract`。
- 架构、官方文档或公共接口：`flow-source-design`。
- 多步骤切分或请求委派：`flow-slice-plan`。
- 范围明确的实施、测试或重构：`flow-build`。
- 失败、回归或性能异常：`flow-diagnose`。
- 完成证据或 UI/浏览器检查：`flow-verify`。
- 审查、发布或交接：`flow-review-ship`。

## 加载原则

- 每次只加载一个阶段；不要预加载后续阶段。
- 先完成并报告当前阶段，再开始下一阶段。阶段通过且 `next_stage` 不是结束状态时，在同一请求中自动继续。
- 只在 `blocked`、必须由用户作出的实质决定或 `next_stage: "completed"` 时停止；中间的 `workflow-result` 只是检查点，不代表任务结束。
- 仅在需要 5 次以上工具调用、存在上下文丢失风险、调研密集或用户明确要求持久规划时，结合 `flow-slice-plan` 使用 `planning-with-files`。
- 任务确实涉及某个领域时，才加载对应的领域 Skill；不相关的领域不要加载。
- 仅当同一请求包含 `/subagent` 或明确要求委派时，使用子代理。

## 工具选择

- OpenAI/Codex/API 文档：`openai-docs`。
- Skill：`skill-creator`；参考 `writing-great-skills`。
- 插件/安装：`plugin-creator` 或 `skill-installer`。
- Vue：`vue-best-practices`，加上仅涉及的 Vue 专项。
- 新 UI 或新的视觉方向：`frontend-design`。
- `baseline-ui` 与 `impeccable` 是显式调用工具包；不要自动加载。
- 浏览器验证属于 `flow-verify`。

## 长期笔记

规划处于活动状态时，初始化笔记：

```bash
"${CODEX_HOME:-$HOME/.codex}/skills/local-evidence-flow/scripts/init-workflow-notes.sh"
```

将 `task_plan.md`、`findings.md`、`progress.md` 与 `decision-notes.md` 放在以下目录中：

```text
~/.codex/workflow-notes/<project-name>/<conversation-id>/
```
