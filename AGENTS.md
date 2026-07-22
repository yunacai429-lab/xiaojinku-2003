# 小金库项目开发规则

本文件适用于仓库根目录及全部子目录。开始任何新任务前，先完整阅读本文件和 `PROJECT_HANDOFF.md`，再检查当前 Git 状态与线上版本；不要只依据聊天记录判断项目状态。

## 项目原则

- 这是个人使用的响应式记账网页，目标设备是 Mac 桌面浏览器和 iPhone Safari。
- 保持 Windows XP / 老 QQ 风格，不要擅自改成现代 SaaS、营销页或大圆角卡片风格。
- 交互优先级高于装饰：记账、预算、账户、还款和同步流程必须可连续使用。
- 所有云端数据必须按 Supabase `auth.uid()` 隔离。不得削弱或绕过行级安全策略。
- 不得提交账号密码、访问令牌、私钥、数据库密码、`service_role` key、真实账本数据或浏览器会话。
- Supabase 前端只能使用 publishable/anon key。即使该 key 可以公开，也不要在交接文档、日志或回复中重复它的值。
- 保留用户现有修改。发现脏工作树时先理解差异，不得使用 `git reset --hard`、`git checkout --` 等方式覆盖用户改动。

## 技术栈与代码规范

- 前端：原生 HTML、CSS、JavaScript，无框架、无打包器、无 Node 运行依赖。
- 云端：Supabase Auth + Postgres JSONB，表结构与 RLS 在 `supabase-schema.sql`。
- 托管：Cloudflare Pages Direct Upload。
- 主逻辑集中在 `src/main.js`，样式集中在 `src/style.css`。优先做小范围修改，不要无必要引入依赖或构建链。
- 保持源码可由现代 Safari 和 Chromium 直接执行。新增浏览器 API 前检查 iPhone Safari 兼容性。
- 动态用户文本必须经过 `escapeHtml()` 后再进入 HTML 字符串。
- 金额计算统一转为 `Number`；余额、预算、存款和还款修改必须同时检查对应数据影响。
- 页面导航只能绑定具体导航控件，例如 `button[data-page]`。不能对通用 `[data-page]` 绑定事件，因为 `body` 也使用 `data-page` 作为样式状态。
- 不要添加会抢占输入的全局 capture 级 `pointerdown`、`mousedown` 或 `click` 处理。输入框、按钮和复选框优先使用原生事件。
- 任何触发 `render()` 的修改都要检查是否会清空尚未提交的表单状态。
- 代码目前是紧凑单文件风格；除非任务明确涉及重构，否则保持现有风格并运行语法检查。

## 重要文件与目录

- `index.html`：静态入口及 CSS/JS 缓存版本。发布新版本时必须更新资源查询参数。
- `src/main.js`：认证、状态、云同步、页面渲染和全部业务逻辑。不能替换 Supabase 项目或破坏用户数据兼容迁移。
- `src/style.css`：桌面、移动和两套复古皮肤。修改后必须检查桌面与 390px 宽移动视口。
- `supabase-schema.sql`：生产数据库表和 RLS。修改属于高风险数据变更，必须说明迁移和回滚方式。
- `VERSION`：当前语义版本号。
- `README.md`：公开项目说明、版本摘要和截图。
- `docs/screenshots/`：README 使用的效果图。更新 UI 后检查截图是否仍准确。
- `小金库_v1.4.0基准.md`：历史基准文档，只作参考，不代表当前版本。
- `PROJECT_HANDOFF.md`：当前真实交接状态。每次迭代结束必须更新。
- `outputs/`：本地部署包，已由 `.gitignore` 忽略，不提交 GitHub。

## 本地运行与验证

项目无安装和构建步骤。

```bash
# JavaScript 语法检查
/Applications/ChatGPT.app/Contents/Resources/cua_node/bin/node --check src/main.js

# Git 空白和冲突检查
git diff --check
rg -n '^(<<<<<<<|=======|>>>>>>>)' .

# 本地静态服务器
python3 -m http.server 4173

# 部署包
zip -r -FS outputs/xiaojinku-cloudflare.zip index.html src
```

如果系统 Node 可用，也可以运行 `node --check src/main.js`。端口被占用时使用其他端口并在交接文档中注明。

最低手工验收：

- 登录页和免登录演示可进入。
- 记账页金额、类别、余额支付/月付、具体平台和备注可操作，点击选项不会清空金额。
- 保存后停留在记账页并清空上次表单，仅生成一条记录。
- 预算可编辑、保存、新增类别；账户可编辑、增删支付方式。
- 待还款可以只勾选一条记录，且还款前需要选择扣款账户。
- 明细筛选、统计页面、设置和头像入口可打开。
- 桌面视口和约 390x844 移动视口都要验证，不得只测其中一种。
- 真实线上账号测试不得保存测试账单或修改用户数据；优先使用演示模式。

## GitHub 与版本规则

- 仓库：`https://github.com/yunacai429-lab/xiaojinku-2003`
- 默认分支：`main`
- 修复升级 patch 版本，新增兼容功能升级 minor 版本，不兼容改版才升级 major 版本。
- 发布提交至少同步修改 `VERSION`、`README.md`、`index.html` 缓存参数和 `PROJECT_HANDOFF.md`。
- 提交前运行 `git fetch origin`、`git status --short --branch`、`git diff --check`，确认本地与远端差异。
- 本地与远端历史分叉时先比较文件内容；使用正常 merge/rebase 处理，不得以破坏性 reset 掩盖问题。
- 推送后必须重新 `git fetch origin`，记录实际远端 SHA，并核对 GitHub 原始文件与本地内容。
- 命令行凭据不可用时，可以在已登录 GitHub 会话中上传，但必须记录由网页产生的实际 commit SHA；不得声称本地 commit 已被原样推送。

## Cloudflare 发布规则

- Pages 项目名：`xiaojinku-2003`
- 生产网址：`https://xiaojinku-2003.pages.dev/`
- 当前没有 `wrangler` 配置或 GitHub 自动部署，使用 Direct Upload。
- 发布前用上面的 `zip` 命令生成部署包，确认压缩包根目录包含 `index.html` 和 `src/`。
- 在 Cloudflare Pages 项目中选择 Production，上传压缩包并执行 Save and deploy。
- 上传成功不等于生产生效。必须确认部署详情状态为 `success`，再访问主域名并核对 `index.html` 的版本参数。
- 最后在生产域名的演示模式重复核心交互验收。不要只验证唯一部署子域名。

## 每次迭代结束

必须更新 `PROJECT_HANDOFF.md`，至少写入：最终版本、实际本地和 GitHub SHA、本次改动、测试结果、线上部署结果、已知问题和下一步。然后检查文档不含密码、Token、私钥或真实用户数据。
