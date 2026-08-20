# dsh-stack

**DeepSeek Harness 全家桶 · 一键复刻（下载即一模一样）**

一套可复现的 DeepSeek Harness（dsh）完整运行环境：核心 harness + 十多个自有/第三方 bundle 插件 + 内置 Flash/Pro 自动调度 + 四套 agent 模式，**全部开箱即用**。

## 这是什么

本仓库不是一套新代码，而是**当前正在运行的整套 dsh 系统的可复刻装配**。克隆后按文档配置环境变量和模型 Key，就能得到与你（维护者）几乎一致的系统：

- 全插件来源透传，第三方与二创代码有着落可追溯
- 内置 **Flash/Pro 自动调度插件**（`dsh-llm-auto-router`）：每轮用 fast 模型分类，轻活走 Flash、重活走 Pro，**与模式无关，任何模式可用**
- 内置 4 套 agent 模式（preset），介绍已中文化
- 配置模板已脱敏，无任何真实密钥外泄

## 版本基线（2026-08）

| 组件 | 版本 |
|---|---|
| DeepSeek Harness (dsh) | **`0.1.0-rc.8`**（含本地二开：launcher / auto-continue decline-term / ContextMeter / atomic-write 等） |
| 核心插件 | ssh / remote-web-ui `0.2.3`, ankh-guard `rc.8.3`, dshmarket `1.15.0`, skill-hub `0.2.2`, vision-router `1.7.1`, interconnect `0.9.0`, wechat `0.5.1`, auto-continue `0.7.1` 等全部最新 |
| crosstalk | `v0.2.0`（含 `trace_issue` 跨会话溯源 + `coord_peers` 同工作区冲突协商；`v0.1.0` 的跨会话消息/auto-collab 保留） |
| memory | `dsh-agent-memory` `0.8.4` 源码注入（`remember/recall/index/forget` 跨会话记忆，正交于通信） |
| llm-auto-router | `v0.1.0`（多 provider，默认 opencode-go） |
| api-key-pool | `v0.3.0`（多 key 轮换 + 失败切换 + 厂商自动列表，rc.8 兼容 fork） |

> 维护者可复刻路径：官方 `upgrade-rc8-main` 分支 = rc.8 核心 + 完整二开（`lileikeji/deepseek-harness`）。

## 快速开始（3 步）

### 1. 安装 DeepSeek Harness

```bash
git clone https://github.com/deepseek-ai/deepseek-harness
cd deepseek-harness
pnpm install && pnpm build
```

要求：Node `^22.19 || >=24`，`pnpm`。

### 2. 装配插件

每个 bundle 独立仓库，按 `docs/PLUGINS.zh.md` 的来源清单逐个：

```bash
# 以 auto-router 为例
git clone https://github.com/lileikeji/dsh-llm-auto-router
cd dsh-llm-auto-router && pnpm install && pnpm build
dsh plugin --profile web add /path/to/dsh-llm-auto-router
```

> 建议先装核心的几个（见 `docs/PLUGINS.zh.md` 标注 ★）：`llm-auto-router`、`crosstalk`、`vision-toolkit`、`image-gen`；其余按需。

也可用装配脚本一键完成（在 `deepseek-harness` 父目录或指定其路径运行）：

```bash
# Linux / macOS
bash scripts/bootstrap.sh ../deepseek-harness

# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -File scripts/bootstrap.ps1 -DshRoot E:\deepseek-harness
```

### 3. 配置模型与环境变量

1. 复制脱敏配置模板：
   ```bash
   cp config-templates/settings.example.yaml ~/.dsh/settings.yaml
   ```
2. 设置环境变量（真实 Key，不进仓库）：
   ```bash
   export OPENCODE_GO_API_KEY=...      # 主对话 provider
   export SILICONFLOW_API_KEY=...      # 生图 + 视觉验证
   export SILICONFLOW_MIMO_VISION_API_KEY=...
   export AIJWS_API_KEY=...            # 备用 DeepSeek 路由
   ```
3. 安装 agent 模式（preset）到 `~/.dsh/.agent-presets/`（见 `presets/` 目录）。

### 4. 启动

```bash
pnpm dsh --profile web
```

打开 Web GUI（默认 `http://127.0.0.1:3081`），新建会话即自动使用 `router-flash` 模式 + `deepseek-v4-auto` 自动调度。

## 目录结构

```
dsh-stack/
├── README.md                       # 本文件（中文）
├── README.en.md                    # English
├── docs/
│   ├── PLUGINS.zh.md               # 插件装配清单（来源/二创标注）
│   └── PLUGINS.en.md
├── preset/                         # agent 模式源（router-flash/router-standard/anchored-standard/liangshen）
├── config-templates/
│   └── settings.example.yaml       # 脱敏配置模板
└── scripts/                        # 装配辅助脚本
```

## 文档

- [插件装配清单（来源与二创标注）](docs/PLUGINS.zh.md)
- English: [README.en.md](README.en.md), [PLUGINS.en.md](docs/PLUGINS.en.md)

## 模型自动调度说明

默认 `agent-default-model` 为 `opencode-go / deepseek-v4-auto`。装配 `dsh-llm-auto-router` 后：

| 任务 | 路由 |
|---|---|
| 轻活（闲聊/翻译/格式化/快速查询） | `deepseek-v4-flash` |
| 重活（复杂编码/调试/多步推理/架构/数学） | `deepseek-v4-pro` |

每轮第一次请求先用 fast 模型做一次 ≤16 token 的小分类，后续步骤复用该轮决策；分类失败自动回退强档，绝不失败整轮。只改 model 不改 provider，凭据/端点/推理元数据不动。**与任何 agent 模式无关**——无论是 `router-flash` 还是别的 preset，都能调度。

## 安全说明

- 本仓库不含任何真实 API Key、令牌、SSH 主机或账户信息
- `remote-web-ui` 的公开 URL / 联机令牌未收录（见模板注释）
- 所有模型 Key 通过环境变量注入

## 许可证

各插件沿用各自上游许可证（多数 BSD-3 / MIT）。本装配（文档与模板）按 MIT 发布。
