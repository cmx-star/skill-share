---
name: flow-build
description: Implement an already-scoped coding task. Use only when requirements, scope, acceptance criteria, and verification path are clear and Codex should edit code, add tests, refactor, update scripts, or complete an implementation slice. If the contract is missing or vague, route to flow-frame-contract first.
---

# 实施

目标：用最小且正确的改动满足当前任务约定。

## 入口关卡

编辑前，确认当前任务约定已经写清：

- 目标
- 预期行为
- 范围内与范围外边界
- 验收条件
- 验证路径

复杂的改动，且缺少上述五个其中任何一项，先不要实施，改用 `flow-frame-contract`补充信息，之后再继续处理。

## 步骤

1. 编辑前检查项目规则和 Git 工作区状态。
2. 遵循项目已存在代码的风格和现有函数/工具等。
3. 行为可测试且风险合理时，先编写或定位失败检查。
4. 每次只实施一个切片，并保持最小范围。
5. 持续更新共享笔记，尤其是 `decision-notes.md` 和 `progress.md`。及时记录决定、偏离、取舍、待集中确认的问题和实施进度。
6. 重构必须保持行为不变，并与当前切片直接相关。
7. 修改后运行范围最小且有意义的验证。
8. 报告变更文件、执行命令、笔记路径（如有）和剩余风险。

## 规则

- 未经批准，不添加、移除或升级依赖。
- 不重写无关代码，也不顺手清理跟需求无关的问题。
- 不虚构项目 API、命令、路径或配置。
- 在抽离公共函数/组件确实有场景收益前，优先选择直接实现。
