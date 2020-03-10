# Ejemplo de importación o exportación VCF de Office 365 #

En este ejemplo de Ruby on Rails, se muestra cómo usar la [API de contactos](https://msdn.microsoft.com/office/office365/APi/contacts-rest-operations) con la gema [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook).

## Software necesario ##

- [Ruby on Rails](http://rubyonrails.org/)
- [ruby\_outlook](http://github.com/jasonjoh/ruby_outlook)
- [bootstrap-sass](https://rubygems.org/gems/bootstrap-sass)
- [OAauth2](https://rubygems.org/gems/oauth2)
- [Carrierwave](https://rubygems.org/gems/carrierwave)
- [vCard](https://rubygems.org/gems/vcard)

## Genere un Id. de cliente y un secreto ###

Antes de continuar, debemos registrar nuestra aplicación para obtener un Id. de cliente y un secreto. Diríjase a https://apps.dev.microsoft.com para obtener un Id. de cliente y un secreto rápidamente. Inicie sesión con su cuenta Microsoft (Outlook.com) o con su cuenta profesional o educativa (Office 365) usando el botón para Iniciar sesión correspondiente.

Una vez que haya iniciado sesión, haga clic en el botón **Agregar una aplicación**. Escriba `VCFTool` como nombre y haga clic en **Crear aplicación**. Luego de crear la aplicación, busque la sección **Secretos de la aplicación** y haga clic en el botón **Generar nueva contraseña**. Copie la contraseña ahora y guárdela en un lugar seguro. Después de copiar la contraseña, haga clic en **Aceptar**.

![Cuadro de diálogo de la nueva contraseña.](./readme-images/app-new-password.PNG)

En la sección **Plataformas**, haga clic en **Agregar plataforma**. Elija **Web**, luego escriba `http://localhost:8000/authorize` en **URI de redirección**. Haga clic en **Guardar** para completar el registro. Copie el **Id. de la aplicación** y guárdelo junto con la contraseña que copió previamente. En breve necesitaremos estos valores.

Cuando termine, este es el aspecto que deberían tener los detalles del registro de su aplicación.

![Las propiedades del registro completado.](./readme-images/app-registration.PNG)

## Ejecución del ejemplo ##

Se asume que tiene Ruby on Rails instalado antes de comenzar.

1. Descargue o bifurque el proyecto de ejemplo.
1. Abra un símbolo del sistema o un shell de comandos en el directorio en el que haya descargado el proyecto y ejecute `bundle` para instalar las gemas necesarias.
1. Ejecute `bundle exec rake db:setup` para configurar la base de datos.
1. Edite el archivo `.\app\helpers\auth_helper.rb`. Copie el Id. de cliente de aplicación que obtuvo durante el registro de la aplicación y péguelo como el valor de la variable `CLIENT_ID`. Copie la clave que creó durante el registro de la aplicación y péguela como el valor de la variable `CLIENT_SECRET`. Guarde el archivo.
1. Ejecute el servidor ejecutando `rails server` desde la línea de comandos.
1. Abra el explorador y vaya a http://localhost:3000.
1. Haga clic en el botón "Iniciar sesión con su cuenta de Office 365 o Outlook.com" para usar la aplicación.

## Copyright ##

Copyright (c) Microsoft. Todos los derechos reservados.

----------
Conectar conmigo en Twitter [@JasonJohMSFT](https://twitter.com/JasonJohMSFT)

Seguir el [blog de desarrollo de Exchange](http://blogs.msdn.com/b/exchangedev/)