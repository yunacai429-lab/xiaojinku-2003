# 小金库 2003

一款 Windows XP / 老 QQ 风格的响应式记账网页原型。

支持在“个人资料”中修改用户名，并从 Mac 或 iPhone 相册选择自定义头像。

## 本地运行

```bash
python3 -m http.server 4173
```

然后访问 `http://localhost:4173`。

## 启用 Supabase 云同步

1. 登录 Supabase，打开项目 `cojdriqqlijjsotljmjx`。
2. 打开左侧 **SQL Editor**，新建查询。
3. 复制并执行项目中的 `supabase-schema.sql` 全部内容。
4. 将网页部署到任意免费静态托管平台。
5. 在 Mac 和 iPhone 使用同一邮箱和密码登录。

页面会立即本地保存，并在网络可用时同步到 Supabase。数据库已启用行级安全策略，每个账号只能读取和修改自己的账本。
