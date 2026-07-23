# 委派与验收

## 派发任务前

把下面这些信息写进每个子代理的任务说明：

- 固定的 `task_id`
- 角色：`planner`、`developer` 或 `reviewer_tester`
- 要解决什么问题，以及负责到哪里
- 可以修改哪些文件
- 哪些内容不能改，或哪些范围不能碰
- 如何验收，以及需要运行什么验证命令

开发类子代理完成后，必须成功执行：

```sh
workflow_gate.py receipt --stage subagent
```

并在结果里附上生成的 receipt。规划和审查类子代理可以不运行验证，但必须把 `verification.result` 填为 `not_run`。

## 收到结果后

主代理先检查摘要、改动文件、验证结果和风险。把这些信息处理完，才能继续委派或结束任务。
