# Exemple d’importation/exportation de Microsoft Graph Office 365 VCF

[![État de création](https://travis-ci.org/jasonjoh/o365-vcftool.svg?branch=master)](https://travis-ci.org/jasonjoh/o365-vcftool)

Cet exemple Ruby on Rails montre comment utiliser l’[API Contacts](https://docs.microsoft.com/graph/outlook-contacts-concept-overview) pour travailler avec des contacts personnels.

## Logiciels requis

- [Ruby on rails](http://rubyonrails.org/)
- [Yarn](https://classic.yarnpkg.com/en/)
- [omniauth-oauth2](https://github.com/omniauth/omniauth-oauth2)
- [httparty](https://github.com/jnunemaker/httparty)
- [vcard](https://rubygems.org/gems/vcard)

## Inscrire une application

1. Ouvrez un navigateur et accédez au [Centre d’administration Azure Active Directory](https://aad.portal.azure.com). Connectez-vous à l’aide d’un **compte personnel** (alias : compte Microsoft) ou d’un **compte professionnel ou scolaire**.

1. Sélectionnez **Azure Active Directory** dans le volet de navigation gauche, puis sélectionnez **Inscriptions d’applications** sous **Gérer**.

1. Sélectionnez **Nouvelle inscription**. Sur la page **Inscrire une application**, définissez les valeurs comme suit.

   - Définissez le **Nom** dans `l’outil VCF Contacts Outlook`.
   - Définissez les **Types de comptes pris en charge** sur les **Comptes figurant dans un annuaire organisationnel et les comptes Microsoft personnels**.
   - Sous **URI de redirection**, définissez la première liste déroulante sur `Web` et la valeur sur `http://localhost:3000/auth/microsoft_graph_auth/callback`.

1. Sélectionnez **Inscription**. Sur la page **Didacticiel Graph Ruby**, copiez la valeur de **l’ID d’application (client)** et enregistrez-la, car vous en aurez besoin à l’étape suivante.

1. Sélectionnez **Autorisations de l’API** dans **Gérer**. Sélectionnez **Ajouter une autorisation**. Sélectionnez **Microsoft Graph**, puis **Autorisations déléguées**. Ajoutez l’autorisation **Contacts.ReadWrite**, puis sélectionnez **ajouter des autorisations**.

1. Sélectionnez **Certificats et secrets** sous **Gérer**. Sélectionnez le bouton **Nouvelle clé secrète client**. Entrez une valeur dans la **Description**, puis sélectionnez l'une des options pour **Expire le**, et sélectionnez **Ajouter**.

1. Copiez la valeur de la clé secrète client avant de quitter cette page. Vous en aurez besoin à l’étape suivante.

   > **Important :** Ce secret client n’apparaîtra plus jamais, aussi veillez à le copier maintenant.

## Configurer l’exemple

L’exemple lit l’ID d’application et le code secret à partir de l’API des identifiants de Rails. Vous devez ajouter ces valeurs au fichier **credentials.yml.enc**.

1. Ouvrez votre interface de ligne de commande (CLI) dans le répertoire **./vcftool**.
1. Exécutez la commande suivante pour modifier les identifiants :

    ```identifiants
	shell rails : modifier
    ```

    > **Remarque :** Si vous recevez un message d’erreur `Aucun éditeur dans lequel ouvrir le fichier`, vous devez configurer un éditeur de texte dans la variable environnement de `l’éditeur`. Pour plus d’informations, consultez `identification des rails : aide` ou [Applications de sécurité des rails](https://guides.rubyonrails.org/security.html#custom-credentials).

1. Ajoutez le code suivant au fichier d’identification et enregistrez-le.

    ```yml
    # Azure
    azure:
	app_id: c9fb1bd9-ecc1-4c8a-a945-8f587dc95826
	app_secret: Y7UjylVrdEBiPuIiRz@Ai@.tO:OX205@
	```

## Exécution de l’exemple

## Configuration

1. Ouvrez votre CLI et exécutez `installation de groupe` pour installer des dépendances.
1. Exécutez `bundle exec rake db:setup` pour configurer la base de données.
1. Exécutez le `serveur rails` pour exécuter l’exemple.
1. Ouvrez votre navigateur et accédez à [http://localhost:3000](http://localhost:3000).

## Copyright

Copyright (c) Microsoft. Tous droits réservés.

Ce projet a adopté le [code de conduite Open Source de Microsoft](https://opensource.microsoft.com/codeofconduct/). Pour en savoir plus, reportez-vous à la [FAQ relative au code de conduite](https://opensource.microsoft.com/codeofconduct/faq/) ou contactez [opencode@microsoft.com](mailto:opencode@microsoft.com) pour toute question ou tout commentaire.

---------
Suivez-moi sur Twitter [@JasonJohMSFT](https://twitter.com/JasonJohMSFT)
