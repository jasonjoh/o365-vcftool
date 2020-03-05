# Microsoft Graph Office 365 VCF Import/Export Sample

This Ruby on Rails sample shows how to use the [Contacts API](https://docs.microsoft.com/graph/outlook-contacts-concept-overview).

## Required software

- [Ruby on Rails](http://rubyonrails.org/)
- [Yarn](https://classic.yarnpkg.com/en/)
- [omniauth-oauth2](https://github.com/omniauth/omniauth-oauth2)
- [httparty](https://github.com/jnunemaker/httparty)
- [vcard](https://rubygems.org/gems/vcard)

## Register an application

1. Open a browser and navigate to the [Azure Active Directory admin center](https://aad.portal.azure.com). Login using a **personal account** (aka: Microsoft Account) or **Work or School Account**.

1. Select **Azure Active Directory** in the left-hand navigation, then select **App registrations** under **Manage**.

1. Select **New registration**. On the **Register an application** page, set the values as follows.

   - Set **Name** to `Outlook Contacts VCF Tool`.
   - Set **Supported account types** to **Accounts in any organizational directory and personal Microsoft accounts**.
   - Under **Redirect URI**, set the first drop-down to `Web` and set the value to `http://localhost:3000/auth/microsoft_graph_auth/callback`.

1. Select **Register**. On the **Ruby Graph Tutorial** page, copy the value of the **Application (client) ID** and save it, you will need it in the next step.

1. Select **API permissions** under **Manage**. Select **Add a permission**. Select **Microsoft Graph**, then **Delegated permissions**. Add the **Contacts.ReadWrite** permission, then select **Add permissions**.

1. Select **Certificates & secrets** under **Manage**. Select the **New client secret** button. Enter a value in **Description** and select one of the options for **Expires** and select **Add**.

1. Copy the client secret value before you leave this page. You will need it in the next step.

   > **Important:** This client secret is never shown again, so make sure you copy it now.

## Configure the sample

The sample reads the app ID and secret from the Rails credentials API. You need to add these values to the **credentials.yml.enc** file.

1. Open your command-line interface (CLI) in the **./vcftool** directory.
1. Run the following command to edit credentials:

    ```shell
    rails credentials:edit
    ```

    > **Note:** If you receive an error `No $EDITOR to open file in`, you need to configure a text editor in the `EDITOR` environment variable. For more information, run `rails credentials:help` or visit [Securing Rails Applications](https://guides.rubyonrails.org/security.html#custom-credentials).

1. Add the following to the credentials file and save it.

    ```yml
    # Azure
    azure:
      app_id: c9fb1bd9-ecc1-4c8a-a945-8f587dc95826
      app_secret: Y7UjylVrdEBiPuIiRz@Ai@.tO:OX205@
    ```

## Running the sample

## Setup

1. Open your CLI and run `bundle install` to install dependencies.
1. Run `bundle exec rake db:setup` to setup the database.
1. Run `rails server` to run the sample.
1. Open your browser and go to [http://localhost:3000](http://localhost:3000).

## Copyright

Copyright (c) Microsoft. All rights reserved.

---------
Connect with me on Twitter [@JasonJohMSFT](https://twitter.com/JasonJohMSFT)
