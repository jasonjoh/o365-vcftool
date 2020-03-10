# Office 365 VCF 导入/导出示例 #

此 Ruby on Rails 示例演示如何通过 [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook) gem 使用[联系人 API](https://msdn.microsoft.com/office/office365/APi/contacts-rest-operations)。

## 所需软件 ##

- [Ruby on Rails](http://rubyonrails.org/)
- [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook)
- [bootstrap-sass](https://rubygems.org/gems/bootstrap-sass)
- [oauth2](https://rubygems.org/gems/oauth2)
- [carrierwave](https://rubygems.org/gems/carrierwave)
- [vcard](https://rubygems.org/gems/vcard)

## 生成客户端 ID 和密码 ###

继续之前，我们需要注册应用，以获取客户端 ID 和密码。转到 https://apps.dev.microsoft.com 快速获取客户端 ID 和密码。单击“登录”按钮，使用 Microsoft 帐户 (Outlook.com) /工作或学校帐户 (Office 365) 进行登录。

登录后，单击“**添加应用程序**”按钮。输入 `VCFTool` 作为名称并单击“创建应用程序”****。创建应用后，找到“应用程序密码”****部分，单击“生成新密码”****按钮。现在复制密码并将其保存到安全位置。复制密码后，单击“确定”****。

![“新密码”对话。](./readme-images/app-new-password.PNG)

找到“**平台**”部分，再单击“**添加平台**”。选择**Web**，随后在“**重定向 URI**”下输入 `http://localhost:8000/authorize`。单击“**保存**”，完成注册。复制“应用程序 Id”****并将其与先前复制的密码一同保存。我们很快就会需要这些值。

完成上述步骤后，应用程序的注册详细信息应如下所示。

![已完成注册的属性。](./readme-images/app-registration.PNG)

## 运行示例 ##

在开始之前，假定你已安装了 Ruby on Rails。

1. 下载示例项目或为其创建分支。
1. 在下载项目的目录中打开命令提示符/shell，然后运行 `bundle` 以安装所需的 gem。
1. 运行 `bundle exec rake db:setup` 以设置数据库。
1. 编辑 `.\app\helpers\auth_helper.rb` 文件。复制在应用注册期间获取的应用的客户端 ID，并将其粘贴为 `CLIENT_ID` 变量的值。复制在应用注册期间创建的密钥，并将其粘贴为 `CLIENT_SECRET` 变量的值。保存文件。
1. 通过从命令行运行 `Rails 服务器`运行服务器。
1. 使用浏览器并转到 http://localhost:3000。
1. 单击“使用 Office 365 或 Outlook.com 帐户登录”按钮，使用该应用。

## 版权所有 ##

版权所有 (c) Microsoft。保留所有权利。

----------
在 Twitter 上通过 [@JasonJohMSFT](https://twitter.com/JasonJohMSFT) 与我联系

关注 [Exchange 开发人员博客](http://blogs.msdn.com/b/exchangedev/)