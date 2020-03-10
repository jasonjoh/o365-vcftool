# Exemplo de importação/exportação VCF do Office 365 #

Este exemplo de Ruby on Rails mostra como usar a [API de Contatos](https://msdn.microsoft.com/office/office365/APi/contacts-rest-operations) por meio do gem [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook).

## Software necessário ##

- [Rubi no Rails](http://rubyonrails.org/)
- [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook)
- [bootstrap-sass](https://rubygems.org/gems/bootstrap-sass)
- [oauth2](https://rubygems.org/gems/oauth2)
- [carrierwave](https://rubygems.org/gems/carrierwave)
- [vcard](https://rubygems.org/gems/vcard)

## Gerar uma ID de cliente e um segredo ###

Antes de prosseguir, precisamos registrar nosso aplicativo para obter uma ID de cliente e um segredo. Vá para https://apps.dev.microsoft.com para obter rapidamente uma ID de cliente e um segredo. Usando os botões de entrada, entre com sua conta da Microsoft (Outlook.com) ou sua conta corporativa ou de estudante (Office 365).

Depois de entrar, clique no botão **Adicionar um aplicativo**. Insira `VCFTool` para o nome e clique em **Criar aplicativo**. Depois de criar o aplicativo, localize a seção **segredos do aplicativo** e clique no botão **gerar nova senha**. Copie a senha agora e salve-a em um local seguro. Depois que você copiou a senha, clique em **Ok**.

![Caixa de diálogo nova senha.](./readme-images/app-new-password.PNG)

Localize a seção **Plataformas** e clique em **Adicionar plataforma**. Escolha **Web**e, em seguida, digite `http://localhost:8000/authorize` em **URIs de redirecionamento**. Clique em **Salvar** para concluir o registro. Copie a **ID do aplicativo** e salve-a junto com a senha que você copiou anteriormente. Precisaremos desses valores em breve.

Esta será a aparência dos detalhes do registro do seu aplicativo quando você terminar.

![As propriedades de registro concluídas.](./readme-images/app-registration.PNG)

## Execução do exemplo ##

Presume-se que você tenha o rubi no Rails instalado antes de começar.

1. Baixe ou bifurque o projeto de exemplo.
1. Abra um aviso/Shell de comando para o diretório onde você baixou o projeto e execute `pacote` para instalar os Gems necessários.
1. Execute o `pacote exec o banco de dados do Rake: Configure`para configurar o banco de dados.
1. Edite o arquivo `.\app\helpers\ auth_helper. rb`. Copie a ID do cliente para seu aplicativo obtida durante o registro do aplicativo e cole-a como o valor da variável `CLIENT_ID`. Copie a chave criada durante o registro do aplicativo e cole-a como o valor da variável `CLIENT_SECRET`. Salve o arquivo.
1. Execute o servidor executando o `servidor rails` a partir da linha de comando.
1. Use o navegador e acesse http://localhost:3000.
1. Clique no botão "entrar com a sua conta do Office 365 ou Outlook.com" para usar o aplicativo.

## Direitos autorais ##

Copyright (c) Microsoft. Todos os direitos reservados.

----------
Conecte-se comigo no Twitter [@JasonJohMSFT](https://twitter.com/JasonJohMSFT)

Siga o [Blog de desenvolvedores do Exchange](http://blogs.msdn.com/b/exchangedev/)