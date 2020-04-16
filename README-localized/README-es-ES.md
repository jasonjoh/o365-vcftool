# Ejemplo de importación o exportación VCF de Microsoft Graph Office 365

[![Estado de la compilación](https://travis-ci.org/jasonjoh/o365-vcftool.svg?branch=master)](https://travis-ci.org/jasonjoh/o365-vcftool)

En esta muestra de Ruby on Rails se indica cómo usar la [API de contactos](https://docs.microsoft.com/graph/outlook-contacts-concept-overview) para trabajar con contactos personales.

## Software necesario

- [Ruby on Rails](http://rubyonrails.org/)
- [Yarn](https://classic.yarnpkg.com/en/)
- [omniauth-OAuth2](https://github.com/omniauth/omniauth-oauth2)
- [httparty](https://github.com/jnunemaker/httparty)
- [vCard](https://rubygems.org/gems/vcard)

## Registrar una aplicación

1. Abra el explorador y vaya al [Centro de administración de Azure Active Directory](https://aad.portal.azure.com). Inicie sesión con una **cuenta personal** (por ejemplo: una cuenta de Microsoft) o una **cuenta profesional o educativa**.

1. Seleccione **Azure Active Directory** en el panel de navegación izquierdo y, después, **Registros de aplicaciones** en **Administrar**.

1. Seleccione **Nuevo registro**. En la página **Registrar una aplicación**, establezca los valores siguientes.

   - Establezca el **nombre** de la `herramienta de contactos VCF de Outlook`.
   - Establezca los **Tipos de cuenta admitidos** en las **Cuentas en cualquier directorio de organización y las cuentas personales de Microsoft**.
   - En el **URI de redirección**, establezca la primera lista desplegable en `Web` y el valor de `http://localhost:3000/auth/microsoft_graph_auth/callback`.

1. Seleccione **Registrarse**. En la página **Tutorial de Ruby Graph**, copie el valor del **ID de aplicación (cliente)** y guárdelo, lo necesitará en el paso siguiente.

1. Seleccione **Permisos de API** en **Administrar**. Seleccione **Añadir un permiso**. Seleccione **Microsoft Graph** y, después, **Permisos delegados**. Añada el permiso **Contacts.ReadWrite** y, a continuación, seleccione **Añadir permisos**.

1. Seleccione **Certificados y secretos** en **Administrar**. Seleccione el botón **Nuevo secreto de cliente**. Escriba un valor en **Descripción**, seleccione una de las opciones de **Caduca** y marque **Añadir**.

1. Copie el valor del secreto de cliente antes de salir de esta página. Lo necesitará en el siguiente paso.

   > **Importante:** el secreto de cliente no se vuelve a mostrar, así que asegúrese de copiarlo en este momento.

## Configuración del ejemplo

El ejemplo lee el ID de la aplicación y el secreto de la API de credenciales de Rails. Añada estos valores al archivo **credentials.yml.enc**.

1. Abra la interfaz de línea de comandos (CLI) en el directorio **./vcftool**.
1. Ejecute el comando siguiente para editar las credenciales:

    ```shell
	rails credentials:edit
    ```

    > **Nota:** si recibe el error `No $EDITOR to open file in`, tiene que configurar un editor de texto en la variable de entorno de `EDITOR`. Para obtener más información, ejecute `rails credentials:help` o visite [protección en las aplicaciones de Rails](https://guides.rubyonrails.org/security.html#custom-credentials).

1. Añada lo siguiente al archivo de credenciales y guárdelo.

    ```yml
    # Azure
    azure:
	app_id: c9fb1bd9-ecc1-4c8a-a945-8f587dc95826 app_secret:
	Y7UjylVrdEBiPuIiRz@Ai@.tO:OX205@
    ```

## Ejecutando el ejemplo

## Configuración

1. Abra la CLI y ejecute `bundle install` para instalar las dependencias.
1. Ejecute `bundle exec rake db:setup` para configurar la base de datos.
1. Ejecute el `servidor de Rails` para iniciar el ejemplo.
1. Abra el explorador y vaya a [http://localhost:3000](http://localhost:3000).

## Derechos de autor

Copyright (c) Microsoft. Todos los derechos reservados.

Este proyecto ha adoptado el [Código de conducta de código abierto de Microsoft](https://opensource.microsoft.com/codeofconduct/). Para obtener más información, consulte las [Preguntas frecuentes sobre el código de conducta](https://opensource.microsoft.com/codeofconduct/faq/) o póngase en contacto con [opencode@microsoft.com](mailto:opencode@microsoft.com) si tiene otras preguntas o comentarios.

---------
Conecte conmigo en Twitter [@JasonJohMSFT](https://twitter.com/JasonJohMSFT)
