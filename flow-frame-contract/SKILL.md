---
name: flow-frame-contract
description: Clarify requirements and define expected boundaries before implementation. Use when a request lacks expected behavior, acceptance criteria, scope, constraints, verification path, product behavior, UI expectations, or when the user asks to brainstorm, scope, spec, define, build a feature from a vague ask, or implement something whose contract is not yet explicit.
---

# 明确任务要求

目标：在设计或实施前，把任务说明到可以直接执行。

## 步骤

1. 阅读相关项目上下文和规则。
2. 区分已知信息、缺失信息、可从代码或文档发现的信息，以及真正依赖用户意图的信息；先检查可发现事实。
3. 明确目标、用户场景、当前问题、预期行为、边界和验证路径。
4. 在实施前厘清会明显影响结果的歧义。只问真正会卡住工作的事，每次一个简洁问题；需要用户决定时，给出推荐方案和取舍。
5. 可以合理假设时就说明假设并继续，不必无谓等待。
6. 判断是否需要工作流笔记。只有需要跨上下文延续，或要记录长期决定时，才按 Flow 规则使用。
7. 产出任务要求：

```text
当前理解：
- 目标：
- 已知上下文：
- 缺少的信息：
- 可从代码或文档中确认的内容：
- 必须向用户确认的内容：

场景：
预期行为：
限制：
- 允许修改的文件或模块：
- 不要添加的依赖：
- 性能、兼容性或安全限制：
- 不要改变的现有行为：

验收（3-4 个明确结果）：
验证方式：
工作流笔记：无 | ~/.codex/workflow-notes/<project>/<conversation>/
待确认的问题：
```

## 决策笔记

需要笔记时，使用 `local-evidence-flow/scripts/init-workflow-notes.sh` 创建或定位共享笔记目录。将 `task_plan.md`、`findings.md`、`progress.md` 与 `decision-notes.md` 放在一起。在 `decision-notes.md` 中记录：

- 决策：需求或规格不清晰时作出的解释或选择。
- 偏离：有意不遵循需求或规格的事项及原因。
- 取舍：考虑过的替代方案及未选用原因。
- 问题：尚未解决、应集中向用户确认的事项，避免重复打断。

在需求解析和实施期间持续维护这些内容。不要把意图变化隐藏在代码中。若偏离会改变用户意图，除非为避免损坏或不安全行为所必需，否则记录后先询问再继续。

## 关卡

在预期行为、范围、3-4 个硬性验收结果和验证方式明确前，不要开始实施。任务过小时可少于四项；微小且明确的修改，一句验收条件即可。
