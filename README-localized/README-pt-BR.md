# Exemplo de importação/exportação do Microsoft Graph Office 365

[![Status da compilação](https://travis-ci.org/jasonjoh/o365-vcftool.svg?branch=master)](https://travis-ci.org/jasonjoh/o365-vcftool)

Este exemplo de rubi no Rails mostra como usar a [API de contatos](https://docs.microsoft.com/graph/outlook-contacts-concept-overview) para trabalhar com contatos pessoais.

## Software necessário

- [Rubi no Rails](http://rubyonrails.org/)
- [yarn](https://classic.yarnpkg.com/en/)
- [omniauth-oauth2](https://github.com/omniauth/omniauth-oauth2)
- [httparty](https://github.com/jnunemaker/httparty)
- [vcard](https://rubygems.org/gems/vcard)

## Registrar um aplicativo

1. Abra um navegador e navegue até o [centro de administração do Azure Active Directory](https://aad.portal.azure.com). Faça logon usando uma **conta pessoal** (também conhecida como: Conta Microsoft) ou**conta corporativa ou de estudante**.

1. Selecione **Azure Active Directory** na navegação à esquerda e, em seguida, selecione **Registros de aplicativos** em **Gerenciar**.

1. Selecione **Novo registro**. Na página **registrar um aplicativo**, defina os valores da seguinte forma.

   - Defina o **nome**para`ferramenta VCF de contatos do Outlook`.
   - Defina **tipos de contas com suporte** para **contas em qualquer diretório organizacional e contas pessoais da Microsoft**.
   - Em **URI de redirecionamento**, defina o primeiro menu suspenso como `Web` e defina o valor como `http://localhost:3000/auth/microsoft_graph_auth/callback`.

1. Selecionar **registrar**. Na página **do tutorial rubi para o Graph**, copie o valor do **ID do aplicativo (cliente)** e salve-o, você precisará dele na próxima etapa.

1. Selecione **Permissões de API**em **gerenciar**. Selecione **Adicionar uma permissão**. Selecione **Microsoft Graph**, em seguida **permissões delegadas**. Adicione a permissão **contatos. ReadWrite**, em seguida, selecione **adicionar permissões**.

1. Selecione **certificados e segredos** em **gerenciar**. Selecione o botão **novo segredo do cliente**. Insira um valor em **descrição** e selecione uma das opções para **expira** e selecione **adicionar**.

1. Copie o valor de segredo do cliente antes de sair desta página. Você precisará dele na próxima etapa.

   > **Importante:** Este segredo do cliente nunca é mostrado novamente, portanto, copie-o agora.

## Configurar o exemplo

O exemplo lê a ID do aplicativo e o segredo da API de credenciais do Rails. É necessário adicionar esses valores para o arquivo **credenciais. yml.enc**.

1. Abra a sua interface de linha de comando (CLI) no diretório **./vcftool**.
1. Execute o seguinte comando para editar as credenciais:

    ```credenciais
	do rails Shell: editar
    ```

    > **Observação:** Se você receber uma mensagem de erro `$EDITOR não é possível abrir o arquivo no`, você precisará configurar um editor de texto na variável de ambiente `EDITOR`. Para saber mais, execute `as credenciais do Rails: ajuda` ou visite [proteger aplicativos Rails](https://guides.rubyonrails.org/security.html#custom-credentials).

1. Adicione o seguinte ao arquivo de credenciais e salve-o.

    ```yml
    # Azure
    azure:
	app_id: c9fb1bd9-ecc1-4c8a-a945-8f587dc95826
	app_secret: Y7UjylVrdEBiPuIiRz@Ai@.tO:OX205@
    ```

## Execução do exemplo

## Configuração

1. Abra a CLI e execute `grupo instalar` para instalar as dependências.
1. Execute o `pacote exec o banco de dados do Rake: configure`para configurar o banco de dados.
1. Execute o `servidor Rails` para executar o exemplo.
1. Abra o navegador e vá para [http://localhost:3000](http://localhost:3000).

## Direitos autorais

Copyright (c) Microsoft. Todos os direitos reservados.

Este projeto adotou o [Código de Conduta de Código Aberto da Microsoft](https://opensource.microsoft.com/codeofconduct/).  Para saber mais, confira as [perguntas frequentes sobre o código de conduta](https://opensource.microsoft.com/codeofconduct/faq/) ou entre em contato pelo [opencode@microsoft.com](mailto:opencode@microsoft.com) se tiver outras dúvidas ou comentários.

---------
Conecte-se comigo no Twitter [@JasonJohMSFT](https://twitter.com/JasonJohMSFT)
