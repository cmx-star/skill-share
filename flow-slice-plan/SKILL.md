---
name: flow-slice-plan
description: Split scoped work into executable slices after the contract is clear. Use for multi-step or multi-file work, implementation planning, task breakdown, explicitly requested agent delegation, persistent planning with planning-with-files, or when the task is too large to safely implement in one pass. If acceptance or verification is unclear, route to flow-frame-contract first.
---

# 拆分任务

目标：把工作拆成可以独立实施、审查和验证的小块。

## 步骤

1. 列出可能变更的文件或模块及各自职责。
2. 拆成多个切片，每个切片都要能产出有意义、可测试的结果。
3. 将风险优先或依赖优先的切片排在前面。
4. 每项任务只做一个逻辑改动，并限定明确且较小的写入范围。
5. 运行环境有计划/进度工具时，创建可见进度。始终只保留一个 `in_progress` 项；完成时标记完成，并在开始下一切片前更新列表。没有可见工具时，在聊天中展示简短清单。
6. 工作耗时长、调研密集、可能超出上下文、需要 5 次以上工具调用或用户要求持久计划时，使用 `planning-with-files`。在共享笔记目录中保持 `task_plan.md`、`findings.md`、`progress.md` 和 `decision-notes.md` 最新。
7. 子代理保持可选：
   - 用户要求由代理规划时，调用 `planner`。
   - 用户要求委派实施时，调用 `developer`。
   - 用户要求委派测试、验证或审查时，调用 `reviewer_tester`；否则直接通过 `flow-verify` 验证。
   - 审查者发现已实施工作失败时，将结果交回 `developer`。
8. 优先做第一个能从可运行输入走到已验证输出的最小切片。延后抽象和能力扩展，直到证据证明确有必要。
9. 输出任务说明：

```text
目标：
涉及文件：
不要改什么：
验收：
验证命令：
子代理：除非用户明确要求，否则不委派
补充说明：
 - 决定：
 - 偏离：
 - 取舍：
 - 待确认的问题：
```

## 关卡

验收条件和验证不清晰的切片，不要派发或实施。

实施开始前，用户应能看到切片顺序和当前进度。每个切片都必须有明确且较小的写入范围，以及可独立执行的验证。
