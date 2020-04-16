# Microsoft Graph Office 365 VCF インポート/エクスポート サンプル

[![ビルドの状態](https://travis-ci.org/jasonjoh/o365-vcftool.svg?branch=master)](https://travis-ci.org/jasonjoh/o365-vcftool)

この Ruby on Rails サンプルは、[Contacts API](https://docs.microsoft.com/graph/outlook-contacts-concept-overview) を使用して個人用連絡先を操作する方法を示しています。

## 必要なソフトウェア

- [Ruby on Rails](http://rubyonrails.org/)
- [Yarn](https://classic.yarnpkg.com/en/)
- [omniauth-oauth2](https://github.com/omniauth/omniauth-oauth2)
- [httparty](https://github.com/jnunemaker/httparty)
- [vcard](https://rubygems.org/gems/vcard)

## アプリケーションを登録する

1. ブラウザーを開き、[Azure Active Directory 管理センター](https://aad.portal.azure.com)へ移動します。**個人用アカウント** (別名:Microsoft アカウント) か**職場または学校のアカウント**を使用してログインします。

1. 左側のナビゲーションで [**Azure Active Directory**] を選択し、次に [**管理**] で [**アプリの登録**] を選択します。

1. **[新規登録]** を選択します。**[アプリケーションの登録]** ページで、次のように値を設定します。

   - [**名前**] を [`Outlook 連絡先 VCF ツール`] に設定します。
   - [**サポートされているアカウントの種類**] を [**任意の組織のディレクトリ内のアカウントと個人用の Microsoft アカウント**] に設定します。
   - [**リダイレクト URI**] で、最初のドロップダウン リストを [`Web`] に設定し、それから `http://localhost:3000/auth/microsoft_graph_auth/callback` に値を設定します。

1. [**登録**] を選択します。[**Ruby Graph チュートリアル**] ページで、[**アプリケーション (クライアント) ID**] の値をコピーして保存し、次の手順に移ります。

1. [**管理**] で [**API のアクセス許可**] を選択します。[**アクセス許可を追加する**] を選択します。[**Microsoft Graph**] を選択し、[**委任されたアクセス許可**] を選択します。[**Contacts.ReadWrite**] のアクセス許可を追加してから、[**アクセス許可を追加する**] を選択します。

1. [**管理**] で [**証明書とシークレット**] を選択します。[**新しいクライアント シークレット**] ボタンを選択します。[**説明**] に値を入力し、[**有効期限**] のオプションのいずれかを選択し、[**追加**] を選択します。

1. このページを離れる前に、クライアント シークレットの値をコピーします。この値は次の手順で必要になります。

   > **重要:**このクライアント シークレットは今後表示されないため、今必ずコピーするようにしてください。

## サンプルを構成する

サンプルは、Rails 資格情報 API からアプリ ID とシークレットを読み取ります。これらの値を **credentials.yml.enc** ファイルに追加する必要があります。

1. **./vcftool** ディレクトリでコマンド ライン インターフェイス (CLI) を開きます。
1. 次のコマンドを実行して、資格情報を編集します。

    ```シェル
	rails の資格情報: 編集
     ```

    > **メモ:**エラー「`ファイルを開く $EDITOR がありません`」が表示される場合、`EDITOR` 環境変数でテキスト エディターを構成する必要があります。詳細については、`rails credentials:help` を実行するか、[Rails アプリケーションのセキュリティによる保護](https://guides.rubyonrails.org/security.html#custom-credentials)にアクセスしてください。

1. 次を資格情報ファイルに追加して保存します。

    ```yml
    # Azure
    azure:
	app_id: c9fb1bd9-ecc1-4c8a-a945-8f587dc95826
	app_secret:Y7UjylVrdEBiPuIiRz@Ai@.tO:OX205@
     ```

## サンプルの実行

## セットアップ

1. CLI を開き、`bundle install` を実行して依存関係をインストールします。
1. `bundle exec rake db:setup` を実行してデータベースをセットアップします。
1. `rails server` を実行してサンプルを実行します。
1. ブラウザーを開いて [http://localhost:3000](http://localhost:3000) に移動します。

## 著作権

Copyright (c) Microsoft.All rights reserved.

このプロジェクトでは、[Microsoft オープン ソース倫理規定](https://opensource.microsoft.com/codeofconduct/) が採用されています。詳細については、「[倫理規定の FAQ](https://opensource.microsoft.com/codeofconduct/faq/)」を参照してください。また、その他の質問やコメントがあれば、[opencode@microsoft.com](mailto:opencode@microsoft.com) までお問い合わせください。

---------
Twitter ([@JasonJohMSFT](https://twitter.com/JasonJohMSFT)) でぜひフォローしてください。
