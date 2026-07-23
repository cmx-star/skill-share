---
name: flow-review-ship
description: Review, release, or hand off completed work. Use for code review, quality audit, merge readiness, launch checks, rollback planning, final delivery notes, or handoff to another agent or human.
---

# 审查与交付

目标：判断工作能否安全交接、合并或发布。

## 审查

按以下顺序检查：

1. 是否符合任务要求。
2. 测试和验证质量。
3. 是否改了范围外的内容，或混入无关改动。
4. 简洁性和可维护性。
5. 架构和边界适配度。
6. 安全、隐私与机密处理。
7. 性能和浏览器/用户影响。

只有用户明确要求委派测试、验证或独立审查时，才使用 `reviewer_tester`；否则直接审查。

若 `reviewer_tester` 返回 `needs_changes`，且实施曾被委派，则将发现交回 `developer`。主代理不应静默修补委派工作中的失败。

## 发布

面向发布或生产的工作，检查：

- 回滚路径。
- 配置和环境变量。
- 数据迁移。
- 监控、日志和错误可见性。
- 文档或变更日志。
- 用户可见时的浏览器/用户流程验证。

## 交接

交接时说明：

```text
已完成：
验证：
风险：
未完成：
下一步：
```
