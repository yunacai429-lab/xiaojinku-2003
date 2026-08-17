# 小金库项目交接

更新时间：2026-08-17（Asia/Shanghai）

## 接手入口

新任务开始时依次执行：

1. 阅读 `AGENTS.md` 和本文件。
2. 运行 `git fetch origin`、`git status --short --branch` 和 `git log --graph --oneline --decorate -12 --all`。
3. 比较 `VERSION`、`index.html`、本地 `HEAD`、`origin/main` 和生产网址，不要从旧聊天推断版本。
4. 启动本地静态服务器，在演示模式分别测试桌面和移动视口。

## 项目概况

小金库是一个供个人使用的复古风响应式记账网页，主要记录收入、日常花销、分类预算、余额账户、月付负债、还款和存款。当前阶段为可公开访问和跨设备同步的稳定迭代版，重点是保证 Mac 与 iPhone 上的核心操作可靠。

当前版本：`v1.8.3`

当前版本支持自定义记账周期、支付宝与微信账单导入、Excel 账单导出、对话记账，并优化手机端首次打开速度。

## 地址与版本事实

- GitHub：`https://github.com/yunacai429-lab/xiaojinku-2003`
- GitHub 默认分支：`main`
- 生产网站：`https://xiaojinku-2003.pages.dev/`
- Cloudflare：`https://dash.cloudflare.com/`，Pages 项目名 `xiaojinku-2003`
- Supabase：项目地址由 `src/main.js` 中的 `SUPABASE_URL` 指定；不要在本文写出值。
- 本地仓库：`/Users/yunacai/Documents/New project/xiaojinku-release`

本次文档建立前的已核实状态：

- 本地应用 commit：`075d5b94edbd09ea977a19384c579440c4bf9cd3`
- GitHub `main` 应用 commit：`34ca592c99c0b19a39d807d57a6e58fc46d3c5b1`
- 本地与 GitHub 历史分叉，但全部受控项目文件内容一致，`git diff origin/main` 为空。
- GitHub `VERSION` 与生产资源版本均为 `1.4.3`。
- 生产 HTML 加载 `style.css?v=1.4.3-20260722e` 和 `main.js?v=1.4.3-20260722e`。
- Cloudflare 对应部署在检查时状态为 `success`。

本次交接最终提交和部署结果见文末“本次迭代记录”。

## 技术栈

- HTML5 静态入口
- 原生 CSS，包含桌面/移动响应式规则和 `vintage1`、`vintage2` 两套皮肤
- 原生 JavaScript，字符串模板渲染，无前端框架
- Supabase Auth：邮箱和密码注册/登录
- Supabase Postgres：`ledger_data` 表，以用户 UUID 为主键，账本主体存储为 JSONB
- Supabase RLS：只允许认证用户读写自己的 `user_id`
- Cloudflare Pages：静态资源 Direct Upload
- GitHub：公开仓库，默认分支 `main`

项目没有 `package.json`、打包器、单元测试框架、`wrangler` 配置或 GitHub Actions 部署流程。

## 目录结构

```text
.
├── AGENTS.md                 长期开发规则
├── PROJECT_HANDOFF.md        当前交接状态，每次迭代必须更新
├── README.md                 GitHub 项目说明和版本摘要
├── VERSION                   当前语义版本
├── index.html                静态入口和资源缓存版本
├── src/
│   ├── main.js               状态、认证、同步、业务逻辑和页面渲染
│   └── style.css             两套皮肤及桌面/移动样式
├── vendor/
│   ├── xlsx.full.min.js      微信账单 Excel 本地解析组件
│   └── LICENSE.sheetjs.txt   SheetJS 第三方许可证
├── supabase-schema.sql       数据表、权限和 RLS 初始化脚本
├── docs/screenshots/         README 效果图
├── 小金库_v1.4.0基准.md      历史版本基准
└── outputs/                  本地部署包，不进入 Git
```

## 配置与数据位置

当前没有 `.env` 文件或运行时环境变量注入。

| 名称 | 位置 | 说明 |
| --- | --- | --- |
| `SUPABASE_URL` | `src/main.js` 顶部 | Supabase 项目 URL |
| `SUPABASE_KEY` | `src/main.js` 顶部 | 前端 publishable/anon key，只能使用公开级别 key |
| `SESSION_KEY` | `src/main.js` 顶部 | 浏览器 localStorage 会话键名 |
| `REMEMBER_LOGIN_KEY` | `src/main.js` 顶部 | 用户主动选择记住登录信息时使用的 localStorage 键名 |
| `ledgerKey()` | `src/main.js` | 按 Supabase 用户 UUID 隔离本地账本缓存 |

外部控制台配置：

- Supabase Authentication 的 Site URL / Redirect URLs 必须包含生产网站地址。
- Supabase SQL Editor 必须执行 `supabase-schema.sql`。
- Cloudflare Pages 项目没有仓库内配置文件，部署设置位于 Cloudflare 控制台。

## 本地运行、测试和构建

无需安装依赖，也没有构建产物。

```bash
cd "/Users/yunacai/Documents/New project/xiaojinku-release"

# 语法检查
/Applications/ChatGPT.app/Contents/Resources/cua_node/bin/node --check src/main.js

# Git 差异检查
git diff --check
rg -n '^(<<<<<<<|=======|>>>>>>>)' .

# 本地运行
python3 -m http.server 4173
# 浏览器访问 http://localhost:4173/

# 生成 Cloudflare Direct Upload 包
zip -r -FS outputs/xiaojinku-cloudflare.zip index.html manifest.webmanifest assets src vendor
```

“构建”在本项目中仅指确认静态入口和资源可读取、再生成 zip；没有 `npm run build`。

## GitHub 同步流程

1. `git fetch origin`
2. `git status --short --branch`
3. 检查并保留用户修改，比较 `git diff origin/main`。
4. 更新业务代码、`VERSION`、`README.md`、`index.html` 缓存参数和本文件。
5. 运行语法、冲突标记和桌面/移动验收。
6. `git add` 仅加入本次文件，提交清晰的版本信息。
7. `git push origin main`。
8. 再次 `git fetch origin`，用 `git rev-parse origin/main` 记录实际远端 SHA。
9. 核对 GitHub raw 文件与本地哈希。若使用 GitHub 网页上传，网页会生成不同 SHA，必须记录实际 GitHub SHA，不能把本地 SHA当作已推送 SHA。

## Cloudflare 生产发布流程

1. 确认 `index.html` 缓存参数已升级。
2. 执行 `zip -r -FS outputs/xiaojinku-cloudflare.zip index.html manifest.webmanifest assets src vendor`。
3. 检查 zip 根目录是 `index.html`、`manifest.webmanifest`、`assets/`、`src/` 和 `vendor/`。
4. 打开 Cloudflare Pages 项目 `xiaojinku-2003`。
5. 选择 `Create deployment`，环境选择 `Production`。
6. 上传 `outputs/xiaojinku-cloudflare.zip`，确认文件列表包含 `index.html`、`src/main.js`、`src/style.css`。
7. 点击 `Save and deploy`。
8. 部署详情必须显示 `Status: success`。
9. 访问生产主域名而不是只访问哈希子域，确认 HTML 的版本参数和 JS 内容。
10. 在生产演示模式重复核心操作；不要用真实账号保存测试数据。

## 已完成功能

- 邮箱密码注册、登录、邮箱验证和跨设备云同步
- 每个用户独立的本地缓存和 Supabase RLS 数据隔离
- 收入和花销新增、编辑、删除
- 日期和时间自动填充，提交后留在记账页并清空表单
- 自定义消费类别名称、emoji、增删和拖动排序
- 每个类别独立月度预算，自动统计已用和剩余
- 自定义余额账户和月付方式，支持增删、重命名、类型切换和排序
- 余额支付/月付二级选择；月付消费进入待还款，不立即扣余额
- 待还款逐条选择、分类全选、选择扣款账户后一键还款
- 明细按月份、类型、类别筛选
- 月、年和自定义日期统计，包含柱状图和饼图
- 账户总余额、待还负债、本月结余和存款管理
- 月度结余确认转存、存款提取和手动余额校准
- 用户名、相册头像、还款日和两套复古皮肤
- 桌面侧栏/工具栏和移动底部导航
- 页面顶部刷新；移动端刷新会同步后完整 reload 并恢复页面
- 免登录演示模式，不读写云端
- 桌面端导入微信支付官方 `.xlsx` 账单，原始文件只在浏览器本地解析；导入记录不自动修改微信账户余额

## 已知问题与风险

- `src/main.js` 和 `src/style.css` 是高度集中的单文件实现，缺少自动化回归测试，修改共享事件和 `render()` 风险较高。
- 前端配置直接写在 `src/main.js`，没有开发/生产环境分层。
- 用户勾选“记住用户名和密码”后，凭据会保存在当前浏览器 localStorage；只适合用户自己的私人设备，安全性低于系统密码管理器。
- 云同步是整份 JSONB 的最后写入覆盖，没有字段级合并；两台设备同时编辑可能产生最后写入者覆盖。
- 头像以压缩后的 data URL 存入账本 JSON，较大头像会增加同步负载。
- 没有自动部署和回滚脚本，Cloudflare 发布依赖人工 Direct Upload。
- `shell()` 中桌面顶部日期文本目前含固定日期 `2026年7月21日`，时间是动态的；后续应改为真实当前日期。
- 没有专门的可访问性、旧版 Safari 或弱网自动化测试。
- 历史本地分支与 GitHub 曾分叉；内容一致不代表 commit 相同，每次接手必须先 fetch 并核对提交图。

## 尚未完成的工作

- 建立可重复运行的浏览器回归测试，至少覆盖记账、预算、账户和待还款。
- 将桌面顶部固定日期改为动态日期。
- 评估移除“本地明文记住密码”，改用浏览器原生密码管理体验。
- 评估将单文件业务逻辑拆分为状态、同步、页面和事件模块；在有回归测试前不要贸然重构。
- 建立 Cloudflare 自动部署或仓库内可审计的部署配置。

## 产品、设计和兼容性约束

- 保持 Windows XP / 老 QQ 的复古桌面感，不能无需求改成现代营销风。
- 手机是核心使用场景，目标最小宽度 320px，重点验收 390px iPhone 视口。
- 记账要支持连续多次录入，保存成功不能跳回首页。
- 日期和时间在手机记账页保持同一行；账户和操作按钮在可用宽度内尽量保持单行。
- 账户余额和存款只能在明确确认后调整；月付消费不能提前扣账户余额。
- 还款必须允许逐条选择历史月付消费，并明确选择扣款账户。
- 新账号账户、预算和存款初始值为 0。
- 不同账号之间的数据不能串；任何数据结构变更都要验证 `ledgerKey()` 与 RLS。
- 不引入收费认证或数据库服务；继续使用现有 Supabase 免费方案和 Cloudflare Pages。

## 每次迭代验收清单

- [ ] 已阅读 `AGENTS.md` 和本文件，已 fetch 远端。
- [ ] 未覆盖任务外用户修改，工作树和冲突标记已检查。
- [ ] `VERSION`、README、缓存参数和本文件已更新。
- [ ] `src/main.js` 语法检查通过，静态服务器可加载所有资源。
- [ ] 桌面和 390x844 移动视口均完成核心交互测试。
- [ ] 记账输入在切换类别/付款方式后不会被清空。
- [ ] 预算编辑、保存和新增类别正常。
- [ ] 待还款可以只选择一条记录。
- [ ] 未在真实账号保存测试数据。
- [ ] GitHub `main` 的实际 SHA 和文件哈希已核对。
- [ ] Cloudflare 部署详情为 success，生产主域资源版本正确。
- [ ] 线上演示模式核心功能正常。
- [ ] 文档和提交中不含密码、Token、私钥或真实账本数据。

## 本次迭代记录

### v1.8.3：手机端启动性能优化（2026-08-17）

- 首页不再同步加载 `vendor/xlsx.full.min.js`；Excel 账单组件改为微信/支付宝导入和 Excel 导出时按需加载。
- 登录用户启动时先使用本地账本缓存渲染界面，并将云同步放到后台完成，弱网下不再等待云端返回后才显示首屏。
- 用户已确认 README 与 GitHub Release 文案；版本号升级为 `v1.8.3`，资源缓存参数升级为 `1.8.3-20260817a`。
- 本地检查通过：JavaScript 语法、Git 空白和冲突标记均无错误；本地 HTTP 首页已核对不再包含 `xlsx.full.min.js` 脚本标签。
- 首页首包减少约 336KB gzip / 952KB 未压缩的 Excel 解析库，同时减少移动端首次打开时的脚本解析成本。
- 发布状态：本轮 GitHub 推送、Release 和 Cloudflare Production 部署完成后继续补充实际 SHA、部署 ID 和线上核验结果。

### v1.8.2：微信式语音按压反馈（2026-07-31）

- 对话页按住语音按钮时新增微信式录音浮层，显示录音状态和动态波形。
- 按压位置上移约 70px 进入“松开取消”状态；正常松开仍发送识别文字到确认流程。
- 用户已确认 README 与 GitHub Release 文案；版本号升级为 `v1.8.2`，资源缓存参数升级为 `1.8.2-20260731a`。
- 本地检查通过：JavaScript 语法、Git 空白和冲突标记均无错误；部署包包含 15 个文件及新增 `src/chat-voice.css`。
- 应用发布提交为 `7f5281f2e443a7178a01c637a1e468869f4281a4`，已推送至 GitHub `main`；GitHub Release `v1.8.2` 已创建并设为 Latest，地址为 `https://github.com/yunacai429-lab/xiaojinku-2003/releases/tag/v1.8.2`。
- Cloudflare Pages Production 部署 ID：`7498e93e-0aca-435d-b506-9b013f683e58`，详情状态为 `success`；生产主域已核对加载 `style.css?v=1.8.2-20260731a`、`chat-voice.css?v=1.8.2-20260731a` 和 `main.js?v=1.8.2-20260731a`。

### v1.8.1：语音按住说话（2026-07-30）

- 对话页语音输入改为按住开始识别、松开停止，并将识别到的文字自动发送到现有确认流程；确认后才会写入账本。
- 支持鼠标、触屏以及空格/回车键按住操作；触屏取消、权限失败、识别失败或没有识别到内容时不会发送。
- 本地检查通过：JavaScript 语法、Git 空白和冲突标记均无错误；390x844 演示模式下输入框、语音和发送三列无横向溢出，原“记一笔”表单仍可进入，控制台无错误或警告；未触发真实麦克风权限申请。
- 用户已确认 README 与 GitHub Release 文案；版本号升级为 `v1.8.1`，资源缓存参数升级为 `1.8.1-20260730a`。
- 应用发布提交为 `8abcfaa268ffb97a3e67fd4b2b4afbbf151190fa`，已推送至 GitHub `main`；GitHub Release `v1.8.1` 已创建并设为 Latest，地址为 `https://github.com/yunacai429-lab/xiaojinku-2003/releases/tag/v1.8.1`。
- Cloudflare Pages Production 部署 ID：`7dac1b14-0ead-4898-b936-1584ada848d6`，详情状态为 `success`，共上传 11 个文件；唯一部署网址为 `https://7dac1b14.xiaojinku-2003.pages.dev`。
- 生产主域已核对加载 `style.css?v=1.8.1-20260730a` 和 `main.js?v=1.8.1-20260730a`；线上演示模式显示“按住语音输入”和“按住说话，松开发送”，页面无横向溢出，控制台无错误或警告，未触发麦克风权限或修改真实账本数据。

### v1.8.0：对话记账页面（2026-07-30）

- 新增名为“对话”的“小金库助手”专属页面，桌面侧栏、快捷工具栏和手机底部导航均可进入；原“记一笔”页面、名称和导航入口完整保留。
- 支持从常见中文描述中识别收入/花销、金额、类别、支付方式、今天/昨天/前天及具体月日；无外部 AI 或新增后端依赖。
- 金额无需附带“元”，支持从“午饭32微信”等紧凑表达中提取；会先排除日期和时间数字，并直接按现有支付方式名称识别“微信”等账户。
- 对话输入区新增浏览器原生中文语音输入按钮，识别结果只填入文本框，不自动发送或入账；不支持语音识别的浏览器会禁用按钮，文字输入不受影响。
- 390x844 本地演示模式已验证语音、发送和文本框三列布局完整，页面无横向溢出，控制台无错误；未在自动测试中触发麦克风权限申请。
- 小金库助手头像复用现有品牌 Logo，与登录页和应用品牌标识保持一致。
- 识别结果先显示可编辑确认卡片，用户确认后才写入现有账本并沿用余额扣减、月付待还款和云同步逻辑。
- 本地检查通过：JavaScript 语法和 Git 空白检查无错误；1280px 桌面演示模式成功解析并保存“昨天打车 28 元，支付宝支付”；390x844 手机底部保留原“记账”并新增“对话”，共 7 个入口且无横向溢出；确认卡片可滚动、输入栏可见，“7月20日午饭 32 元，微信支付”可正确区分日期与金额；原记账表单的金额、类别和支付方式均正常，浏览器控制台无错误。
- 用户已确认 README 与 GitHub Release 文案；版本号升级为 `v1.8.0`，资源缓存参数升级为 `1.8.0-20260730a`。
- 应用发布提交为 `fdfc46b4aeb992529372fb1377f5062a8203f34a`，已推送至 GitHub `main`；GitHub Release `v1.8.0` 已创建并设为 Latest，地址为 `https://github.com/yunacai429-lab/xiaojinku-2003/releases/tag/v1.8.0`。
- Cloudflare Pages Production 部署 ID：`c9add2ee-a2f3-4a90-86b1-13477517de91`，详情状态为 `success`，共上传 11 个文件；唯一部署网址为 `https://c9add2ee.xiaojinku-2003.pages.dev`。
- 生产主域已核对加载 `style.css?v=1.8.0-20260730a` 和 `main.js?v=1.8.0-20260730a`；线上演示模式成功将“午饭32微信”识别为 ¥32、吃饭、微信，语音按钮与助手 Logo 正常，页面无横向溢出，浏览器控制台无错误或警告，未登录或修改真实账号数据。

### v1.7.1：设置页分组列表与二级页面（2026-07-29）

- 设置首页改为“账号 / 账本 / 通用”三组单行功能入口，保持现有 Windows XP / 老 QQ 两套复古皮肤风格。
- 个人资料、类别预算、账户、导入继续进入已有二级页；记账周期、还款提醒、界面与显示新增独立二级页，统一提供返回设置页的返回键；导出继续使用原有导出对话框。
- 本地检查通过：JavaScript 语法、Git 空白与冲突标记均无错误；390x844 手机设置页共 8 个入口、无横向溢出，保存记账周期后列表摘要正确更新；记账周期、还款提醒、界面与显示的返回导航正常；复古2切换正常；1280x900 桌面无横向溢出；浏览器控制台无错误或警告。
- 版本号升级为 `v1.7.1`，资源缓存参数升级为 `1.7.1-20260729a`；README 与 GitHub Release 文案已经用户确认。
- 应用发布提交为 `271fe79cb66abb2c1c093681b56c006b4c99abdc`，已推送至 GitHub `main`；GitHub Release `v1.7.1` 已创建并设为 Latest，地址为 `https://github.com/yunacai429-lab/xiaojinku-2003/releases/tag/v1.7.1`。
- Cloudflare Pages Production 部署 ID：`a0d444ff-29aa-46ad-ae3a-a11f3e3952c1`，详情状态为 `success`，共上传 11 个文件；唯一部署网址为 `https://a0d444ff.xiaojinku-2003.pages.dev`。
- 生产主域已核对加载 `style.css?v=1.7.1-20260729a` 和 `main.js?v=1.7.1-20260729a`；390x844 演示设置页显示 3 个分组和 8 个入口，记账周期二级页及返回键正常，无横向溢出，浏览器控制台无错误或警告，未登录或修改真实账号数据。

### v1.7.0：小金库品牌 Logo与手机主屏幕支持（2026-07-28）

- 新增独立 `assets/logo.svg`：以系统蓝、金币黄和粉色小猪头像组成复古应用图标；第二稿重画为更简洁的正面造型并移除“03”字样，第三稿增加头顶投币槽和正在投入的金币，并移除图标外圈白边。
- Logo 已用于登录页、应用顶栏、浏览器图标及 iPhone/Android 主屏幕图标；新增 Web App 清单和独立运行模式，页面标题更新为“小金库 2003 · 复古记账”。
- 本地检查通过：JavaScript 语法和 Git 空白检查无错误；1280x900 登录页与账本页面正常；390x844 页面无横向溢出，底部 6 个导航入口完整；浏览器控制台无错误。
- 版本号升级为 `v1.7.0`，资源缓存参数升级为 `1.7.0-20260728a`；README 与 GitHub Release 文案已由用户确认。
- 应用发布提交为 `866327e427c0c732ea1e201be8a5792921af889f`，已推送至 GitHub `main`；GitHub Release `v1.7.0` 已创建并设为 Latest，地址为 `https://github.com/yunacai429-lab/xiaojinku-2003/releases/tag/v1.7.0`。
- Cloudflare Pages Production 部署 ID：`adebca69-58c7-4160-99d9-fd649ffb54b6`，控制台显示部署成功。
- 生产主域验收通过：HTML 加载 `1.7.0-20260728a` 资源，Manifest 为 `standalone` 并包含 192px/512px 图标；线上 180px `apple-touch-icon` 与本地文件 SHA-256 一致。

### v1.6.1：手机记账页类别按钮自适应（2026-07-28）

- 修复手机记账页类别名称较长时文字溢出按钮的问题：类别列表由固定五列改为按内容自适应宽度并自动换行，按钮在极窄屏下也不会超出容器。
- 本地验收通过：390x844 视口中不同长度的类别按钮宽度随内容变化，按钮文字、类别区和页面均无横向溢出；320x700 视口自动分为三行且无横向溢出；1280x900 桌面布局未受影响。
- 版本号升级为 `v1.6.1`，资源缓存参数升级为 `1.6.1-20260728a`；README 与 GitHub Release 文案已由用户确认。
- 应用发布提交为 `ee3f17412e69221bc349fae8007891a8ce555d32`，已推送至 GitHub `main`；GitHub Release `v1.6.1` 已创建并设为 Latest，地址为 `https://github.com/yunacai429-lab/xiaojinku-2003/releases/tag/v1.6.1`。
- Cloudflare Pages Production 部署 ID：`19774bef-62d6-4a80-84b8-bf05b5b4f22d`，详情状态为 `success`，唯一部署网址为 `https://19774bef.xiaojinku-2003.pages.dev`。
- 生产主域已核对加载 `style.css?v=1.6.1-20260728a` 和 `main.js?v=1.6.1-20260728a`；390x844 演示记账页类别按钮自适应、自动换行且无横向溢出，浏览器控制台无错误或警告，未登录或修改真实账本数据。

### v1.6.0（2026-07-24）

- 设置页新增每月 1 至 31 日的记账周期开始日，旧账本默认每月 1 日开始；不存在的日期自动按当月最后一天计算。
- 首页收入、支出与预算，明细默认筛选及统计页“按周期”统一使用自定义周期；演示账本默认展示每月 15 日至次月 14 日的工资周期。
- 导入页扩展为微信和支付宝双入口；手机设置页只显示一个“导入账单”按钮，进入后再选择微信 `.xlsx` 或支付宝 GB18030 `.csv`。
- 支付宝导入复用微信的预览勾选、分类调整/新增、分类记忆、订单号去重和余额保护；自动跳过不计收支、月付还款、关闭及无效记录。
- 使用用户提供的 2026-06-23 至 2026-07-23 支付宝官方账单只读验收：293 条中识别 63 条可导入（收入 1、支出 62）、213 条不计收支/信用还款、17 条关闭或无效记录；未执行确认导入。桌面双列、390x844 手机单列均无横向溢出。
- 新增小金库 Excel 账单导出：桌面工具栏和手机设置页均可进入，支持全部记录、当前记账周期和自定义日期范围；文件包含账单汇总与收支明细，不导出账户余额、头像或登录信息。
- 导入账单、类别预算、账户管理和个人资料等二级页面左上角新增返回键，并使用页面历史返回实际进入前的页面。
- 用户已确认 README 与 GitHub Release 文案；版本号升级为 `v1.6.0`，资源缓存参数升级为 `1.6.0-20260724a`。
- 本地与 GitHub `main` 应用发布提交为 `1d3b8655e3e27c5fcad6644b1b4023caa620cae9`；GitHub Release `v1.6.0` 已创建并设为 Latest，地址为 `https://github.com/yunacai429-lab/xiaojinku-2003/releases/tag/v1.6.0`。
- Cloudflare Pages Production 部署 ID：`066aed68-7737-4a66-b825-8d39d864b7f8`，详情状态为 `success`，唯一部署网址为 `https://066aed68.xiaojinku-2003.pages.dev`。
- 生产主域 `https://xiaojinku-2003.pages.dev/` 已核对加载 `style.css?v=1.6.0-20260724a`、`main.js?v=1.6.0-20260724a` 和本地 SheetJS 资源。
- 生产演示模式复核通过：自定义周期开始日为 15 日，微信/支付宝双导入入口、三种导出范围和二级页面返回均正常；浏览器控制台无错误或警告，未登录或修改真实账号数据。

### v1.5.0 发布说明整理（2026-07-24）

- 经用户确认，将 README 版本说明精简为 v1.5.0 与 v1.4.0 两版摘要，最新版本置顶。
- 新建 GitHub `v1.5.0` Release，标题为“小金库 v1.5.0”，并设为 Latest；标签指向 GitHub `main` 提交 `0e6c9059c18838cd411e86cbfe194bdcf34a4ed6`。
- 在 `AGENTS.md` 固化发布规则：只写主要功能、重要修复和明显升级；README 保留最近两个版本；发布前必须先把 README 和 Release 文案交用户确认。
- 本轮只修改公开说明与发布元数据，不修改应用代码、版本号或 Cloudflare 生产部署。

### v1.5.0（2026-07-23）

发布前基线：

- 本地发布前 `HEAD`：`a95684dddbcc2d0a5d401fe6c1b667750d0cca85`。
- 发布前 GitHub `origin/main`：`80f9ab4af57a56cee1684250650e36ff693a3638`。
- 发布前生产版本：`v1.4.3`，资源参数为 `1.4.3-20260722e`。
- 本地保留了既有 12 个提交的领先历史；发布过程中检测到并保留了工作区并发新增的微信账单导入修改和 `vendor/xlsx.full.min.js`，没有回退或覆盖。

本次完成：

- 统计页新增双纵轴 SVG 金额折线图；收入、支出固定使用左轴，最多三个消费分类使用右轴。
- 趋势图支持月、年和自定义日期范围；按月显示日期、按年显示月份，较长自定义范围自动按月汇总。
- 手机底栏调整为首页、明细、记账、统计、还款、设置六个等宽入口；记账使用 `✏️`，设置使用同风格 `⚙️`。
- 手机端预算和账户入口移入设置；设置按设置中心、账本管理、还款日期、界面皮肤分成四个独立模块。
- 还款日期输入改为“每月 10 日”的显示方式，删除重复文案。
- 预算概览改为总预算、已用、剩余三色大字号金额、百分比和进度线；月份继续由系统当前日期自动计算。
- 修复手机明细筛选控件重叠；390px 和 440px 视口均无横向溢出。
- 皮肤 2 首页剩余预算图标改为 `📊`。
- 新增微信支付 `.xlsx` 账单导入：支持本地解析、预览勾选、分类建议、用户分类记忆及重复/无效记录跳过；导入记录新增、编辑和删除均不修改微信账户余额。
- 导入预览的每笔支出可直接新增全局分类、图标和月预算，保存后当前交易自动选中且不丢失预览状态。
- 导入预览的单条勾选和全选改为局部更新，不再因整页重绘导致长列表跳回顶部。
- 桌面工具栏和手机设置页均提供导入入口；SheetJS 0.20.3 与 Apache 2.0 许可证固定打包在 `vendor/`。
- 版本保持 `v1.5.0`，本轮重新发布缓存参数升级为 `1.5.0-20260723c`。
- 修复桌面设置页还款日期和界面皮肤模块被压缩的问题；设置内容统一为最大 `980px`、占满可用宽度并居中。

本地测试结果：

- `cua_node --check src/main.js`、`git diff --check` 和冲突标记检查通过。
- Cloudflare 压缩包已生成并核对，根目录包含 `index.html`、`src/main.js`、`src/style.css`、`vendor/xlsx.full.min.js` 和第三方许可证。
- 桌面 1280x900 演示模式：记账输入保持、单次保存并清空、明细筛选、统计折线图及三分类上限、预算编辑/新增分类、账户编辑/新增/删除、单条还款及账户选择、个人资料入口和两套皮肤均通过。
- 手机 390x844 演示模式：六项导航、记账日期与时间同排、明细筛选无重叠、统计图及三分类、设置预算/账户入口、预算编辑、单条还款均通过；所有检查页面 `scrollWidth === clientWidth`。
- 补充检查过 440x956 视口，明细筛选、设置和预算布局正常。
- 使用用户提供的真实微信账单验收：157 笔中识别 156 笔收支、跳过 1 笔中性交易；收入 20、支出 136，与微信汇总一致。
- 确认导入后演示微信余额保持 `¥1,268.50`；再次导入同一文件时 156 笔全部识别为重复，0 笔可导入。
- 390x844 手机端可从设置进入导入，156 行预览无横向溢出；分类规则已针对英文 coffee、共享单车和公益关键词误判进行修正。
- 412px 手机端新增分类弹窗通过：新增“日用品”后当前交易自动选中，全部支出下拉同步出现该分类，156 行预览保持不变且无横向溢出。
- 本轮使用仅含 1 笔虚拟支出的合成 `.xlsx` 再次回归：桌面导入预览、逐笔新增全局分类、emoji、月预算、保存后自动选中均通过，测试记录未执行确认导入。
- 桌面 1280x900 设置页复核：设置中心、还款日期和界面皮肤内容宽度均为 `980px`，两套皮肤切换正常，无横向溢出。
- 手机 440x956（iPhone 17 Pro Max CSS 视口）复核：六项底栏等宽；设置中心、账本管理、还款日期、界面皮肤顺序正确；微信导入预览及新增分类弹窗、明细筛选、统计三分类双轴图、预算和单笔还款均无横向溢出，筛选控件无重叠。
- 浏览器控制台无警告或错误；全部交互测试均使用演示模式，没有登录或修改真实账本。

发布状态：

- 本轮本地应用发布提交：`c63c27c64dd55c8af2506e701c91374b08d38c50`；最终交接文档提交见本节后续记录。
- 本轮 GitHub `main` 应用提交：`e21992e6ca020070e2640d66f908b1841775a8d2`；最终交接文档网页提交会产生后续 SHA，应以接手时 `git rev-parse origin/main` 为准。
- 命令行 HTTPS 凭据不可用，GitHub 通过已登录网页分批上传；因此本地和远端提交历史不同，但受控发布文件内容已逐项核对一致。
- Cloudflare Pages Production 部署 ID：`4921cdd8-a4bb-4c4b-9b1b-3592f93d72b2`，详情状态为 `success`，唯一部署网址为 `https://4921cdd8.xiaojinku-2003.pages.dev`。
- 生产主域 `https://xiaojinku-2003.pages.dev/` 已加载 `style.css?v=1.5.0-20260723c`、`main.js?v=1.5.0-20260723c` 和本地 SheetJS 资源。
- 生产桌面 1280x900 演示：统计双轴折线及三分类、设置页 `980px` 模块宽度均通过；生产手机 440x956 演示：六项等宽导航、明细筛选无重叠、统计双轴折线及三分类均通过，全部检查页面无横向溢出，控制台无警告或错误。
- 所有生产验收均使用免登录演示模式，没有登录或修改真实云端账本。

### v1.5.0 滚动修复上线（2026-07-24）

- 修复微信账单导入预览中取消勾选或全选时调用整页 `render()` 导致长列表跳回顶部的问题；改为局部更新行状态、已选统计、确认按钮和全选状态。
- 资源缓存参数升级为 `1.5.0-20260723d`。
- 本地修复提交：`f2eca97845c845a025bb13f5a1c9907a8eabb0c1`；使用正常 merge 统一既有本地与 GitHub 历史后，GitHub `main` 与本地 `main` 实际 SHA 均为 `0e6c9059c18838cd411e86cbfe194bdcf34a4ed6`。
- Cloudflare Pages Production 部署 ID：`f3d0af0b-9cd6-4dcd-8a88-9dfa9c10f2f6`，控制台部署完成提示为 `Success!`，唯一部署网址为 `https://f3d0af0b.xiaojinku-2003.pages.dev`。
- 生产主域已核对加载 `style.css?v=1.5.0-20260723d`、`main.js?v=1.5.0-20260723d` 和本地 SheetJS 资源；免登录演示可正常进入，浏览器控制台无错误或警告。未登录真实账号，也未修改真实账本数据。

已知问题：

- 项目仍没有自动化回归测试和自动部署，浏览器验收与 Cloudflare Direct Upload 仍需人工执行。
- `src/main.js` 与 `src/style.css` 仍为集中式单文件，后续修改共享渲染和事件时需要继续双端回归。
- GitHub 与 Cloudflare 仍依赖命令行推送或已登录网页人工上传；本轮完成后必须以重新 fetch 得到的 `origin/main` SHA 和 Cloudflare 部署详情为准，不能把本地提交 SHA 当作远端 SHA。

### v1.4.3（2026-07-22）

完成日期：2026-07-22

版本：`v1.4.3`（本次只建立交接机制和核验现状，没有修改应用版本或业务代码）

提交与同步基线：

- 本次交接文档首个本地提交：`c630a9d`（完整 SHA 可用 `git show c630a9d --no-patch` 查看）
- 本次交接验收结果本地提交：`ecd50f5aeb604c55c10289842a198133cdcfaf44`
- GitHub 网页上传交接文档提交：`44f863abdc7e7d0470d66539544100fc72fc14fd`
- 文档建立前本地应用提交：`075d5b94edbd09ea977a19384c579440c4bf9cd3`
- 文档建立前 GitHub 应用提交：`34ca592c99c0b19a39d807d57a6e58fc46d3c5b1`
- 已用非破坏性 merge 合并本地与 GitHub 分叉历史；合并前 `git diff origin/main` 为空，没有覆盖用户文件。
- 本节所在的最终元数据提交无法在自身内容中可靠自引用；接手时以 `git rev-parse HEAD` 和 `git rev-parse origin/main` 为准。

本次完成：

- 新建 `AGENTS.md`，写入长期开发、测试、安全、GitHub 和 Cloudflare 发布规则。
- 新建并填充 `PROJECT_HANDOFF.md`，记录真实架构、目录、配置、功能、限制、流程和接手说明。
- 检查工作区、Git 状态、提交图、GitHub `main`、Supabase schema、静态部署方式和生产资源。
- 确认没有 `package.json`、构建器、自动化测试、`wrangler` 或仓库内 Cloudflare 配置。
- 敏感信息扫描通过：交接文档未包含 Supabase key 值、密码、Token、私钥或真实账本数据。

测试与构建结果：

- JavaScript：`cua_node --check src/main.js` 通过。
- Git：`git diff --check` 通过，无冲突标记。
- 静态服务：`http://localhost:4173/` 成功返回 `v1.4.3` HTML。
- 构建：项目无构建步骤；`outputs/xiaojinku-cloudflare.zip` 已校验，包含 `index.html`、`src/main.js`、`src/style.css`。
- 本地桌面演示：记账金额/类别/月付/备注、保存后留在记账页、预算编辑/保存/新增、单条还款、明细、统计、账户和设置均通过。
- 本地移动 390x844：记账、预算和单条还款通过；页面 `scrollWidth` 等于 `clientWidth` 390，无横向溢出；日期和时间处于同一行。
- 生产演示：资源加载 `v1.4.3-20260722e`；桌面记账输入、类别/月付切换、预算输入和单条还款选择通过。
- 所有浏览器功能测试都使用演示模式，没有登录或修改真实账号数据。

线上核验结果：

- 生产网址：`https://xiaojinku-2003.pages.dev/`
- 生产 HTML 资源参数：`v1.4.3-20260722e`
- 已核实 Cloudflare 生产部署详情状态为 `success`，部署 ID 为 `d6b36f1b-187f-4522-908d-8fee7d8e9ad1`。
- 本次应用代码与已发布生产代码一致；交接 Markdown 不包含在 Cloudflare 部署包中，因此文档更新不要求改变网站资源版本。

仍存在的问题与建议：

- 当前没有自动化测试，下一步最优先建立可重复的浏览器回归测试。
- 修复 `shell()` 中固定的桌面顶部日期。
- 评估取消 localStorage 明文记住密码。
- 在测试覆盖到位后再考虑拆分 `src/main.js`。
- 建议建立 GitHub 到 Cloudflare 的自动部署，减少网页上传造成的本地/远端 commit 分叉。

## 给下一个任务

先执行以下最短指令，再开始改代码：

> 阅读 `AGENTS.md` 和 `PROJECT_HANDOFF.md`，fetch GitHub 并核对本地、`origin/main`、`VERSION` 与生产网站；保留现有修改，按交接清单完成开发、双端测试、GitHub/Cloudflare 同步，并在结束前更新 `PROJECT_HANDOFF.md`。
