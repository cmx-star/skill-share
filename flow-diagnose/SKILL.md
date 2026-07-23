---
name: flow-diagnose
description: Diagnose failures before fixing. Use for bugs, failing tests, build failures, runtime errors, regressions, flaky behavior, integration issues, or performance anomalies.
---

# 诊断

目标：先找到根因，再改变行为。

## 步骤

1. 阅读完整错误、失败断言、日志、堆栈跟踪和相关近期变更。
2. 建立能复现或检测精确症状的反馈循环。
3. 与已知正常路径或本地参考实现比较。
4. 提出两到四个可证伪假设。
5. 每次只测试一个变量。
6. 说明根因、支持证据、受影响范围，以及应保留的回归检查。
7. 用户要求修复时，把已经明确的任务要求交给 `flow-build`；否则在诊断后结束。

## 关卡

没有根因证据，就不要交给实施。无法建立可靠的反馈循环时，说明已尝试什么，还需要哪些文件、日志或访问权限。
