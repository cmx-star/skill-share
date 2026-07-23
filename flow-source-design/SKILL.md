---
name: flow-source-design
description: Design the technical approach before coding. Use when framework/API correctness matters, official documentation should be checked, a module seam or public interface must be chosen, or architecture/refactor direction is unclear.
---

# 技术方案设计

目标：选择符合代码库、也能验证的设计方案。

## 步骤

1. 从项目文件识别技术栈、版本、现有命令和项目类似模块实现模式。
2. 对框架、API 或库行为，优先使用官方文档或项目内示例，不依赖记忆。
3. 明确边界：调用方和测试应使用的公共接口。
4. 保持接口小、行为完整。只有抽离公共逻辑能减少局部复杂度、带来明显收益，或确实需要第二种适配场景时，才新增公共逻辑。
5. 在选择前指出官方文档与现有项目风格之间的冲突。
6. 输出设计说明：

```text
设计方案：
模块边界和对外接口：
涉及文件：
数据流：
已查阅的文档或本地示例：
风险：
不做什么：
```

## 关卡

设计依赖可能变化的外部 API 或框架行为时，实施前必须从权威来源验证。

## 工具选择

- 查阅文档：使用已配置的文档工具或官方来源。
- GitHub 调研：可用时使用已配置的 GitHub 工具。
- 项目图、架构概览、受影响流程和影响范围分析：只有已安装mcp `code-review-graph`，或存在 `.code-review-graph/` 时才使用。安装或修改 MCP 配置前先获得批准。
