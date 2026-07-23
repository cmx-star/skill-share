# Skill Share

AI 编程助手（Codex/Claude Code）的 Skill 集合，提供结构化的开发工作流能力。每个 Skill 是一个独立的模块，包含工作流指令、参考文档和可选的辅助脚本或代理配置。

## 目录结构

```
skill-share/
├── local-evidence-flow/     # Flow 模式入口，按阶段路由任务
├── flow-frame-contract/     # 明确任务要求：需求澄清与边界定义
├── flow-source-design/      # 技术方案设计：架构与接口选型
├── flow-slice-plan/         # 任务拆分：将工作切为可独立实施的切片
├── flow-build/              # 实施：在范围明确后编码实现
├── flow-diagnose/           # 诊断：先定位根因再修复
├── flow-verify/             # 验证：用证据支撑"完成"结论
├── flow-review-ship/        # 审查与交付：代码审查、发布、交接
├── direct-workflow/         # 直接工作流：非 Flow 模式的日常开发
├── subagent-workflow/       # 子代理协作：委派规划/开发/审查任务
├── planning-with-files/     # 文件化规划：持久化任务计划与进度追踪
├── github-community/        # GitHub 社区调研：外部设计取证
├── update-context/          # 更新上下文：维护项目 AI 上下文与可复用资产
├── humanize-zh-cn/          # 中文自然表达：润色面向用户的简体中文
└── .gitignore
```

## 各模块说明

### 核心 Flow 阶段（7 阶段流水线）

| 阶段 | 模块 | 职责 |
|------|------|------|
| 明确任务 | `flow-frame-contract` | 澄清目标、场景、预期行为、边界和验收条件 |
| 方案设计 | `flow-source-design` | 选择技术方案、定义公共接口、查阅官方文档 |
| 任务拆分 | `flow-slice-plan` | 将工作拆为可独立实施、审查和验证的切片 |
| 实施 | `flow-build` | 最小改动满足任务约定，保持代码风格一致 |
| 诊断 | `flow-diagnose` | 建立反馈循环，提出可证伪假设，定位根因 |
| 验证 | `flow-verify` | 运行最小验证，用证据支撑每个"成功"结论 |
| 审查交付 | `flow-review-ship` | 审查代码质量、安全性，判断发布就绪状态 |

### 辅助模块

| 模块 | 用途 |
|------|------|
| `local-evidence-flow` | Flow 模式入口，仅在用户输入 `/flow` 时激活，路由到对应阶段 |
| `direct-workflow` | 直接模式下的开发工作流，处理调查、实施、验证和恢复 |
| `subagent-workflow` | 用户要求时委派子代理执行规划、开发或审查任务 |
| `planning-with-files` | 将任务计划、发现、进度和决策持久化到本地文件 |
| `github-community` | 在方案设计时搜索 GitHub 仓库作为外部参考 |
| `humanize-zh-cn` | 审阅和改写面向用户的简体中文，让表达更自然 |
| `update-context` | 完成开发后更新项目 AI 上下文，识别可复用工作流资产 |
