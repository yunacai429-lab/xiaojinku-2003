# 小金库 2003

一款 Windows XP / 老 QQ 风格的响应式记账网页，支持手机和电脑使用。

在线体验：[xiaojinku-2003.pages.dev](https://xiaojinku-2003.pages.dev/)

## 功能

- 记录收入和花销，自动填写日期与时间
- 按类别设置月度预算，实时计算已用与剩余
- 管理微信、支付宝和银行卡余额
- 单独管理美团月付、抖音月付消费与还款
- 批量选择消费记录并从指定账户一键还款
- 管理存款、月度结余、用户名和自定义头像
- 邮箱密码登录，使用 Supabase 跨设备同步
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
