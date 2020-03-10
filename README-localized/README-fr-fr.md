# Exemple d’importation/exportation d’Office 365 VCF #

Cet exemple Ruby on Rails montre comment utiliser l’[API Contacts](https://msdn.microsoft.com/office/office365/APi/contacts-rest-operations) via la gemme [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook).

## Logiciels requis ##

- [Ruby sur rails](http://rubyonrails.org/)
- [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook)
- [bootstrap-sass](https://rubygems.org/gems/bootstrap-sass)
- [oauth2](https://rubygems.org/gems/oauth2)
- [carrierwave](https://rubygems.org/gems/carrierwave)
- [vcard](https://rubygems.org/gems/vcard)

## Générer un ID client et clé secrète ###

Avant de poursuivre, nous devons enregistrer notre application afin d’obtenir un ID client et un code secret. Rendez-vous sur https://apps.dev.microsoft.com pour obtenir rapidement un ID client et un code secret. À l’aide du bouton connexion, connectez-vous avec votre compte Microsoft (Outlook.com), ou votre compte scolaire ou professionnel (Office 365).

Une fois connecté, cliquez sur le bouton **Ajouter une application**. Entrez `VCFTOOL` pour le nom et cliquez sur **Créer une application**. Une fois l’application créée, recherchez la section **Secrets de l'application**, puis cliquez sur le bouton **Générer un nouveau mot de passe**. Copiez le mot de passe maintenant et enregistrez-le dans un endroit sûr. Une fois que vous avez copié le mot de passe, cliquez sur **OK**.

![Boîte de dialogue Nouveau mot de passe.](./readme-images/app-new-password.PNG)

Accédez à la section **Plateformes**, puis cliquez sur **Ajouter une plateforme**. Sélectionnez **Web**, puis entrez `http://localhost:8000/authorize` sous **URI Redirect**. Cliquez sur **Enregistrer** pour terminer l’inscription. Copiez l’**ID de l’application** et enregistrez-le avec le mot de passe que vous avez copié précédemment. Nous aurons besoin de ces valeurs ultérieurement.

Voici comment les détails de votre inscription d’application doivent se présenter lorsque vous avez terminé.

![Propriétés d’enregistrement terminées.](./readme-images/app-registration.PNG)

## Exécution de l’exemple ##

Il est supposé que Ruby on rails est installé avant de commencer.

1. Téléchargez ou dupliquez l’exemple de projet.
1. Ouvrez une invite de commandes/shell dans le répertoire dans lequel vous avez téléchargé le projet, puis exécutez `offre groupée` pour installer la gemme requise.
1. Exécutez `bundle exec rake db:setup` pour configurer la base de données.
1. Modifiez le fichier `.\app\helpers\auth_helper.rb`. Copiez l’ID client de votre application obtenue durant l’inscription de l’application et collez-le à l’emplacement de la valeur correspondant à la variable `CLIENT_ID`. Copiez la clé créée durant l’inscription de l’application et collez-la à l’emplacement de la valeur correspondant à la variable `CLIENT_SECRET`. Enregistrez le fichier.
1. Exécutez le serveur en exécutant `rails server` à partir de la ligne de commande.
1. Utilisez votre navigateur et accédez à http://localhost:3000.
1. Cliquez sur le bouton « Se connecter avec votre compte Office 365 ou Outlook.com » pour utiliser l’application.

## Copyright ##

Copyright (c) Microsoft. Tous droits réservés.

----------
Suivez-moi sur Twitter [@JasonJohMSFT](https://twitter.com/JasonJohMSFT)

Suivez le [blog de développement Exchange](http://blogs.msdn.com/b/exchangedev/)