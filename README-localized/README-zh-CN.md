# Microsoft Graph Office 365 VCF 导入/导出示例

[![生成状态](https://travis-ci.org/jasonjoh/o365-vcftool.svg?branch=master)](https://travis-ci.org/jasonjoh/o365-vcftool)

此 Ruby on Rails 示例演示如何使用[联系人 API](https://docs.microsoft.com/graph/outlook-contacts-concept-overview) 处理个人联系人。

## 所需软件

- [Ruby on Rails](http://rubyonrails.org/)
- [Yarn](https://classic.yarnpkg.com/en/)
- [omniauth-oauth2](https://github.com/omniauth/omniauth-oauth2)
- [httparty](https://github.com/jnunemaker/httparty)
- [vcard](https://rubygems.org/gems/vcard)

## 注册应用程序

1. 打开浏览器，并转到 [Azure Active Directory 管理中心](https://aad.portal.azure.com)。使用**个人帐户**（也称为：“Microsoft 帐户”）或**工作/学校帐户**登录。

1. 选择左侧导航栏中的“Azure Active Directory”****，再选择“管理”****下的“应用注册”****。

1. 选择“新注册”****。在“**注册应用**”页面上，按如下方式设置值。

   - 将“**名称**”设置为“`Outlook 联系人 VCF 工具`”。
   - 将“**受支持的帐户类型**”设置为“**任何组织目录中的帐户和个人 Microsoft 帐户**”。
   - 在“**重定向 URI**”下，将第一个下拉列表设置为“`Web`”，并将值设置为 `http://localhost:3000/auth/microsoft_graph_auth/callback`。

1. 选择“**注册**”。在“Ruby Graph 教程”****页上，复制并保存“应用(客户端) ID”****的值，将在下一步中用到它。

1. 在“**管理**”下选择“**API 权限**”。选择“**添加权限**”。选择“**Microsoft Graph**”，然后选择“**委派权限**”。添加 **Contacts.ReadWrite** 权限，然后选择“**添加权限**”。

1. 选择“**管理**”下的“**证书和密码**”。选择**新客户端密码**按钮。在“**说明**”中输入值，并选择一个“**过期**”选项，再选择“**添加**”。

1. 离开此页前，先复制客户端密码值。将在下一步中用到它。

   > **重要说明：**此客户端密码不会再次显示，所以请务必现在就复制它。

## 配置示例

该示例从“Rails 凭据 API”中读取应用 ID 和密码。你需要将这些值添加到 **credentials.yml.enc** 文件。

1. 在 **./vcftool** 目录中打开命令行界面 (CLI)。
1. 请运行以下命令来编辑凭据：

    ```shell
	rails credentials:edit
     ```

    > **注意：**如果收到错误“`没有 $EDITOR 打开文件`”，则需要在 `EDITOR` 环境变量中配置文本编辑器。有关详细信息，请运行 `rails credentials:help` 或访问[保护 Rails 应用的安全](https://guides.rubyonrails.org/security.html#custom-credentials)。

1. 将以下代码添加到此凭据文件中，然后保存文件。

    ```yml
    # Azure
    azure:
	app_id: c9fb1bd9-ecc1-4c8a-a945-8f587dc95826
	app_secret:Y7UjylVrdEBiPuIiRz@Ai@.tO:OX205@
	```

## 运行本示例

## 设置

1. 打开 CLI 并运行“`捆绑安装`”以安装依赖项。
1. 运行 `bundle exec rake db:setup` 以设置数据库。
1. 运行 `Rails 服务器`以运行示例。
1. 使用浏览器并转到 [http://localhost:3000](http://localhost:3000)。

## 版权信息

版权所有 (c) Microsoft。保留所有权利。

此项目已采用 [Microsoft 开放源代码行为准则](https://opensource.microsoft.com/codeofconduct/)。有关详细信息，请参阅[行为准则常见问题解答](https://opensource.microsoft.com/codeofconduct/faq/)。如有其他任何问题或意见，也可联系 [opencode@microsoft.com](mailto:opencode@microsoft.com)。

---------
在 Twitter 上通过 [@JasonJohMSFT](https://twitter.com/JasonJohMSFT) 与我联系
