# 子代理返回格式

每个子代理只返回一份结构化结果。所有字段都要填写；没有改动、交付物或风险时，对应字段填空数组。

```subagent-result
{"protocol":"workflow-gate/v1","kind":"subagent_result","task_id":"...","role":"planner|developer|reviewer_tester","status":"passed|blocked","summary":"...","deliverables":["..."],"changed_files":["..."],"verification":{"result":"pass|fail|not_run","receipt_ids":["..."]},"risks":["..."]}
```

`status` 说明任务是否完成；`verification.result` 只说明验证结果。不要把两者混在一起。
