# 小金库 2003

一款 Windows XP / 老 QQ 风格的响应式个人记账网页。支持收入支出、分类预算、月付还款、统计图表和跨设备云同步，可在 iPhone 与电脑上使用。

在线体验：[xiaojinku-2003.pages.dev](https://xiaojinku-2003.pages.dev/)

## 版本更新

### v1.6.0（2026-07-24）

- 支持自定义记账周期，首页、预算、明细和统计统一按工资周期汇总
- 新增支付宝 CSV 账单导入，并保留微信 Excel 导入、分类识别、去重和余额保护
- 新增 Excel 账单导出，支持全部记录、当前周期和自定义日期范围
- 为导入、预算、账户和个人资料等二级页面增加返回上一级功能

### v1.5.0（2026-07-23）

- 新增微信支付账单导入，可预览、修改分类并自动跳过重复记录
- 统计页新增收入、支出与消费分类金额趋势图
- 升级手机端导航、设置、预算和明细筛选界面
- 修复手机端输入、保存、预算编辑和单条还款等操作问题

版本号采用 `主版本.次版本.修订版本`：新增功能升级次版本，例如 `v1.2.0`；问题修复升级修订版本，例如 `v1.1.1`；不兼容的大改版才升级主版本。

## 效果图

### 电脑端首页

![电脑端首页](docs/screenshots/desktop-home.png)

### 手机端预算

<img src="docs/screenshots/mobile-budget.png" alt="手机端预算页面" width="390">

### 收支统计

![桌面端收支统计](docs/screenshots/desktop-stats.png)

### 支付方式管理

![桌面端支付方式管理](docs/screenshots/desktop-accounts.png)

### 手机端记账

<img src="docs/screenshots/mobile-add.png" alt="手机端紧凑记账页面" width="390">

### 手机端明细

<img src="docs/screenshots/mobile-records.png" alt="手机端收支明细页面" width="390">

## 功能

- 记录、编辑和删除收入与花销，自动校正相关账户余额
- 按月份、类型和类别组合筛选收支明细
- 导入微信支付官方 `.xlsx` 账单，预览并调整分类后再写入账本
- 自定义消费类别名称与 emoji，并通过拖动调整显示顺序
- 按类别设置月度预算，实时计算已用与剩余
- 自定义余额账户和月付方式，并通过拖动调整顺序
- 使用“余额支付 / 月付”二级菜单选择具体支付平台
- 单独管理美团月付、抖音月付等月付消费与还款
- 批量选择消费记录并从指定账户一键还款
- 按月、按年或自定义日期统计收入与支出
- 使用双轴折线图、柱状图和饼图展示收支趋势、分类趋势及类别占比
- 管理存款、月度结余、用户名、自定义头像、每月还款日和界面皮肤
- 邮箱密码登录，使用 Supabase 跨设备同步
- 不同账号的云端数据和本地缓存相互隔离
- 免登录演示模式，不会读写云端账本

## 本地运行

项目没有构建依赖，启动任意静态文件服务器即可：

```bash
python3 -m http.server 4173
```

然后访问 `http://localhost:4173`。

## 配置 Supabase

1. 创建一个 Supabase 项目。
2. 在 SQL Editor 中执行 `supabase-schema.sql`。
3. 将 `src/main.js` 顶部的 `SUPABASE_URL` 和 `SUPABASE_KEY` 换成自己的项目值。
4. 在 Authentication → URL Configuration 中设置正式网站地址。
5. 将网页部署到 Cloudflare Pages 等静态托管平台。

`supabase-schema.sql` 会启用行级安全策略，每个账号只能访问自己的账本。

## 安全说明

前端只应使用 Supabase 的 publishable/anon key。不要提交 `service_role` key、数据库密码、账号密码或真实账本数据。

## License

[MIT](LICENSE)
