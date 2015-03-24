# Office 365 VCF Import/Export Sample #

This Ruby on Rails sample shows how to use the [Contacts API](https://msdn.microsoft.com/office/office365/APi/contacts-rest-operations) via the [ruby_outlook](http://github.com/jasonjoh/ruby_outlook) gem.

## Required software ##

- [Ruby on Rails](http://rubyonrails.org/)
- [ruby_outlook](http://github.com/jasonjoh/ruby_outlook)
- [bootstrap-sass](https://rubygems.org/gems/bootstrap-sass)
- [oauth2](https://rubygems.org/gems/oauth2)
- [carrierwave](https://rubygems.org/gems/carrierwave)
- [vcard](https://rubygems.org/gems/vcard)

## Running the sample ##

It's assumed that you have Ruby on Rails installed before starting.

1. Download or fork the sample project.
2. Open a command prompt/shell to the directory where you downloaded the project and run `bundle` to install the required gems.
3. Run `bundle exec rake db:setup` to setup the database.
4. [Register the app in Azure Active Directory](https://github.com/jasonjoh/office365-azure-guides/blob/master/RegisterAnAppInAzure.md). The app should be registered as a web app with a Sign-on URL of "http://localhost:3000", and should be given permission to "Have full access to users' contacts".
4. Edit the `.\app\helpers\auth_helper.rb` file. Copy the client ID for your app obtained during app registration and paste it as the value of the `CLIENT_ID` variable. Copy the key you created during app registration and paste it as the value of the `CLIENT_SECRET` variable. Save the file.
5. Run the server by running `rails server` from the command line.
6. User your browser and go to http://localhost:3000.
7. Click the 'Sign in with your Office 365 Account' button to use the app.

## Copyright ##

Copyright (c) Microsoft. All rights reserved.

----------
Connect with me on Twitter [@JasonJohMSFT](https://twitter.com/JasonJohMSFT)

Follow the [Exchange Dev Blog](http://blogs.msdn.com/b/exchangedev/)