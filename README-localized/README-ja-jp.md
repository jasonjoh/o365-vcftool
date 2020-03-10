# Office 365 VCF インポート/エクスポート サンプル #

この Ruby on Rails サンプルでは、[ruby\_outlook](http://github.com/jasonjoh/ruby_outlook) gem を使用して [Contacts API](https://msdn.microsoft.com/office/office365/APi/contacts-rest-operations) を使用する方法を示します。

## 必要なソフトウェア ##

- [Ruby on Rails](http://rubyonrails.org/)
- [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook)
- [bootstrap-sass](https://rubygems.org/gems/bootstrap-sass)
- [oauth2](https://rubygems.org/gems/oauth2)
- [carrierwave](https://rubygems.org/gems/carrierwave)
- [vcard](https://rubygems.org/gems/vcard)

## クライアント ID とシークレットを生成する ###

続行する前に、アプリを登録してクライアント ID とシークレットを入手する必要があります。クライアント ID とシークレットを素早く取得するには、https://apps.dev.microsoft.com にアクセスします。サインインのボタンを使用し、Microsoft アカウント (Outlook.com) か職場または学校アカウント (Office 365) のいずれかを使用してサインインします。

サインインしたら、\[**アプリの追加**] をクリックします。名前として "`VCFToo`" と入力し、\[**アプリケーションの作成**] をクリックします。アプリを作成したら、\[**アプリケーション シークレット**] セクションを見つけ、\[**新しいパスワードを生成**] ボタンをクリックします。パスワードをコピーし、安全な場所に保存します。パスワードをコピーしたら、\[**OK**] をクリックします。

![新しいパスワードのダイアログ。](./readme-images/app-new-password.PNG)

\[**プラットフォーム**] セクションを見つけ、\[**プラットフォームの追加**] をクリックします。\[**リダイレクト URI**] で \[**Web**] を選択し、"`http://localhost:8000/authorize`" と入力します。\[**保存**] をクリックし、登録を完了します。\[**アプリケーション ID**] をコピーし、先ほどコピーしたパスワードとともに保存します。これらの値は、後で必要になります。

完了後のアプリケーション登録の詳細は、次のように表示されます。

![完了後の登録のプロパティ。](./readme-images/app-registration.PNG)

## サンプルの実行 ##

開始する前に、Ruby on Rails がインストールされているものとします。

1. サンプル プロジェクトをダウンロードまたはフォークします。
1. プロジェクトをダウンロードしたディレクトリでコマンド プロンプト/シェルを開き、`bundle` を実行して必要な gem をインストールします。
1. `bundle exec rake db:setup` を実行してデータベースをセットアップします。
1. `.\app\helpers\auth_helper.rb` ファイルを編集します。アプリの登録時に取得したアプリのクライアント ID をコピーし、`CLIENT_ID` 変数の値として貼り付けます。アプリの登録時に作成したキーをコピーし、`CLIENT_SECRET` 変数の値として貼り付けます。ファイルを保存します。
1. コマンド ラインから `rails server` を実行して、サーバーを実行します。
1. ブラウザーを使用して http://localhost:3000 に移動します。
1. アプリを使用するには、\[Office 365 または Outlook.com アカウントでサインインしてください] ボタンをクリックします。

## 著作権 ##

Copyright (c) Microsoft.All rights reserved.

----------
Twitter ([@JasonJohMSFT](https://twitter.com/JasonJohMSFT)) でぜひフォローしてください。

[Exchange 開発ブログ](http://blogs.msdn.com/b/exchangedev/)をフォローする