# 插件装配清单（来源与二创标注）

本页记录 `lileikeji` 当前 DSH 系统的**完整插件装配**，供任何想"下载即一模一样"复刻的人使用。

## 一、核心平台

| 组件 | 来源 | 说明 |
|---|---|---|
| DeepSeek Harness (dsh) | https://github.com/deepseek-ai/deepseek-harness | 插件化 agent harness（vendored Cordis），本系统运行于其 **`0.1.0-rc.7`** 之上（含本地二开，见 README「版本基线」） |

## 二、第三方 / 自有 bundle 插件

> 「本源」= git origin（feth）。「二创」= fork 自某上游（有 upstream remote）。凡标注「轨道: lileikeji」为本账号自有/维护。

| 插件 | bundle 名 | 本源（origin） | 二创（fork 自） | 用途 |
|---|---|---|---|---|
| agent-team-room | `dsh-agent-team-room` | ishuowang/dsh-agent-team-room | - | 持久化多 agent 房间（成员/消息/任务/共享时间线）。本装配已合并上游 room-mention/邀请等增强，且保留本地「禁用 footer 入口」二开 |
| anchored-standard | `dsh-anchored-standard` | xiaobright/dsh-anchored-standard | - | agent preset：Minimal 引导后开放完整工具 |
| ankh-guard | `@khorsheed/dsh-ankh-guard` | Khorsheed/dsh-ankh-guard | - | 自修改重启的绿色构建门禁 |
| auto-compact | `dsh-auto-compact` | lileikeji/dsh-auto-compact | - | 自动上下文压缩（token 压力阈值触发） |
| api-key-pool | `dsh-api-key-pool` | lileikeji/dsh-api-key-pool | **xiaozhe7772222/dsh-api-key-pool**（二创） | API Key 轮换池（多 key 自动轮换 + 失败切换 + 冷却恢复）。fork 增强：rc.8 keyed 卡片兼容、自动列出所有已连接厂商（settings.describe）、去除内置示例池 |
| auto-continue | `dsh-auto-continue` | lileikeji/dsh-auto-continue | - | 中断任务自动续跑 |
| think-defaults | `dsh-think-defaults` | lileikeji/dsh-think-defaults | - | 自动补全模型思考等级（reasoningEfforts + compat + maxTokens），新模型接入即用，无需手动配置 |
| crosstalk | `@dsh-crosstalk/bundle` | lileikeji/dsh-crosstalk | **Jesse-njx/dsh-crosstalk**（二创） | 跨会话横向消息 + 事件驱动 auto-collab |
| image-gen | `dsh-image-gen` | lileikeji/dsh-image-gen | - | 生图链（SiliconFlow/CogView/万相/OpenAI 兼容）+ 验证 |
| launcher | `dsh-launcher` | lileikeji/dsh-launcher | - | Windows 启动器（boot web + relay 隧道 + 开浏览器） |
| llm-auto-router | `@dsh-external/dsh-llm-auto-router` | lileikeji/dsh-llm-auto-router | - | **Flash/Pro 自动调度**，任意模式可用 |
| mcp-agent-example | `dsh-mcp-agent-example` | lileikeji/dsh-mcp-agent-example | - | 桥接官方 MCP server 工具为 `mcp__<server>__<tool>` |
| memory | `dsh-agent-memory` | Culeot/dsh-agent-memory | - | 跨会话长期记忆（remember/recall/index/forget，基于 ctx.storage，schema 校验）。与 crosstalk/interconnect 正交：记忆=纵向积累，通信=横向协作 |
| relay-broker | `dsh-relay-broker` | lileikeji/dsh-relay-broker | - | 多主机中继（远程 WebUI 端口转发，HMAC 令牌） |
| routing-suite | `dsh-routing-suite` | yjh051108/dsh-routing-suite | - | 路由研究工具集（上游） |
| session-doctor | `dsh-session-doctor` | mayf3/dsh-session-doctor | - | 会话诊断 |
| super-injector | `@dsh-external/dsh-super-injector` | lileikeji/dsh-super-injector | - | 运行时插件注入器（热重载） |
| token-usage | `dsh-token-usage` | jiamuAi/dsh-token-usage | - | token 用量统计 UI |
| ui-image-render | `dsh-ui-image-render` | lileikeji/dsh-ui-image-render | - | UI 图片渲染 |
| upgrader | `dsh-upgrader` | lileikeji/dsh-upgrader | - | 插件一键升级（绕 dsh CLI 拦截） |
| vision-assist | `dsh-vision-assist` | lileikeji/dsh-vision-assist | - | 文本主路由会话的持久图像理解辅助 |
| vision-toolkit | `dsh-vision-toolkit` | lileikeji/dsh-vision-toolkit | - | 结构化视觉工具（定位/裁剪/取色/像素diff） |
| vision-verify | `dsh-vision-verify` | lileikeji/dsh-vision-verify | - | 视觉验证 |
| web-search-anysearch | `dsh-web-search-anysearch` | lileikeji/dsh-web-search-anysearch | - | AnySearch 搜索引擎提供商（ctx.web） |
| web-ui | `dsh-web-ui` | zhu1090093659/dsh-web-ui | - | 三方 Web UI |

## 三、内置 agent 模式（preset）

| preset | 状态 | 说明 |
|---|---|---|
| `router-flash` | 默认启用 | Flash 专属路由——按任务类型（build/fix）内部路由，neutral persona + 分类/回顾/反跑题锚（作者 w7 方案，适配 opencode-go） |
| `router-standard` | 可用 | 按任务感知路由（修复走 spec、构建走 react） |
| `anchored-standard` | 可用（实验） | Minimal 引导后开放完整工具 |
| `liangshen` | 可用 | V4 Pro 专属「梁神」模式 |

## 四、模型 / 提供商（脱敏）

| provider | 用途 | 模型 |
|---|---|---|
| `opencode-go` | 主对话 | `deepseek-v4-auto`（自动调度 Flash/Pro）、`deepseek-v4-flash`、`deepseek-v4-pro` |
| `siliconflow-mimo-vision` | 视觉辅助 | `moonshotai/Kimi-K2.7-Code` |
| `aijws-openai` | 备用 DeepSeek 路由 | `deepseek-v4-pro` |

> API Key 一律通过环境变量注入（详见 `config-templates/settings.example.yaml`），**不在本仓库保存任何真实凭据**。
