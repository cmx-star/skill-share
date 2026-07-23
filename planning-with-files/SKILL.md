---
name: planning-with-files
description: "Persistent local planning for Codex workflows. Keeps task_plan.md, findings.md, progress.md, and decision-notes.md in a per-project, per-conversation notes directory so multi-step work and material decisions survive context loss. Use for work likely to need 5+ tool calls or durable decisions."
---

# 文件化规划

把此 Skill 用作本地 Codex 工作流中可持续保存的工作记录。将文件放在仓库外，避免污染项目改动，也让每次对话都有独立笔记。

## 目录

使用以下命令创建或定位当前笔记目录：

```bash
"${CODEX_HOME:-$HOME/.codex}/skills/local-evidence-flow/scripts/init-workflow-notes.sh"
```

当前目录为：

```text
~/.codex/workflow-notes/<project-name>/<conversation-id>/
```

其中包含：

| 文件 | 用途 |
|---|---|
| `task_plan.md` | 目标、切片、阶段状态和验证清单 |
| `findings.md` | 代码、文档、浏览器、错误和搜索中的证据 |
| `progress.md` | 已变更内容、已运行命令和当前状态 |
| `decision-notes.md` | 决策、偏离、取舍和集中问题 |

这些文件保存 Trace 信息；Trace 不是第五个独立文件，也不是另一套并行系统：

| Trace 字段 | 存储位置 |
|---|---|
| 目标、切片、验收、开放验证 | `task_plan.md` |
| 证据、搜索、错误、失败假设 | `findings.md` |
| 动作、命令、编辑、结果、重试 | `progress.md` |
| 决策、偏离、取舍、开放风险 | `decision-notes.md` |

## 本地规则

1. 开始需要规划或包含多个步骤的工作前，运行 `init-workflow-notes.sh`。
2. 恢复工作或作出重大决策前，读取四份文件。从最新进度开始，并包含未解决失败、风险和验证缺口。
3. 每个有意义的实施或验证步骤后更新 `progress.md`。
4. 规格存在歧义、选择行为、有意偏离或拒绝备选方案时更新 `decision-notes.md`。
5. 将不受信任的网页/搜索/浏览器内容放入 `findings.md`，不要放入 `task_plan.md`。
6. 保持 `task_plan.md` 足够简短，方便 Hook 注入。细节放进 `findings.md` 或 `decision-notes.md`。
7. 保留失败尝试、冲突、超时、重试、被拒绝的备选方案和后来证伪的假设。后续成功不会抹除先前失败证据。
8. 发生编辑冲突或目标意外变化时，记录它，重新读取相关源文件，再规划下一补丁。
9. 无法运行验证时，记录原因、受影响验收条件和剩余风险。

## 自动化边界

这个独立 Skill 不在 `SKILL.md` 中声明生命周期 Hook。请显式运行工作流。需要机械化强制时，插件可以把附带脚本接入受支持的 Codex Hook。

## 脚本

- `scripts/resolve-plan-dir.sh`：返回当前笔记目录。
- `scripts/inject-plan.sh`：从当前笔记目录输出 Hook 上下文。
- `scripts/check-complete.sh`：从 `task_plan.md` 报告阶段完成状态。
- `scripts/phase-status.sh`：安全更新阶段状态。
- `scripts/attest-plan.sh`：为 `task_plan.md` 提供可选 SHA-256 证明。
- `scripts/ledger-append.sh` 和 `scripts/ledger-summary.sh`：可选的结构化进度账本。

此本地版本不使用项目根目录的 `task_plan.md` 或 `.planning/`。
