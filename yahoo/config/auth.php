<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Authentication Defaults
    |--------------------------------------------------------------------------
    |
    | Esta opción controla la "guardia" de autenticación predeterminada y las
    | opciones de restablecimiento de contraseña para tu aplicación. Puedes
    | cambiar estos valores según sea necesario, pero son un buen punto de
    | partida para la mayoría de las aplicaciones.
    |
    */

    'defaults' => [
        'guard' => 'web', // La guardia de autenticación predeterminada para la autenticación web.
        'passwords' => 'users', // El proveedor de contraseñas predeterminado.
    ],

    /*
    |--------------------------------------------------------------------------
    | Authentication Guards
    |--------------------------------------------------------------------------
    |
    | A continuación, puedes definir cada guardia de autenticación para tu
    | aplicación. Por supuesto, se ha definido una gran configuración
    | predeterminada para ti aquí, que utiliza el almacenamiento de sesión
    | y el proveedor de usuarios Eloquent.
    |
    | Todos los controladores de autenticación tienen un proveedor de usuarios.
    | Esto define cómo se recuperan realmente los usuarios de tu base de datos
    | u otros mecanismos de almacenamiento utilizados por esta aplicación para
    | persistir los datos de tus usuarios.
    |
    | Soportado: "session"
    |
    */

    'guards' => [
        'web' => [
            'driver' => 'session', // Utiliza el almacenamiento de sesión para la autenticación web.
            'provider' => 'users', // Utiliza el proveedor de usuarios 'users'.
        ],

        'api' => [
            'driver' => 'passport', // Utiliza Laravel Passport para la autenticación API (OAuth2).
            'provider' => 'users', // Utiliza el proveedor de usuarios 'users'.
            'hash' => false, // Desactiva el hashing automático de contraseñas (se asume que ya están encriptadas).
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | User Providers
    |--------------------------------------------------------------------------
    |
    | Todos los controladores de autenticación tienen un proveedor de usuarios.
    | Esto define cómo se recuperan realmente los usuarios de tu base de datos
    | u otros mecanismos de almacenamiento utilizados por esta aplicación para
    | persistir los datos de tus usuarios.
    |
    | Si tienes múltiples tablas o modelos de usuario, puedes configurar
    | múltiples fuentes que representen cada modelo / tabla. Estas fuentes
    | pueden luego asignarse a cualquier guardia de autenticación adicional
    | que hayas definido.
    |
    | Soportado: "database", "eloquent"
    |
    */

    'providers' => [
        'users' => [
            'driver' => 'eloquent', // Utiliza el proveedor de usuarios Eloquent.
            'model' => App\Models\User::class, // Especifica el modelo de usuario a utilizar.
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Resetting Passwords
    |--------------------------------------------------------------------------
    |
    | Puedes especificar múltiples configuraciones de restablecimiento de
    | contraseña si tienes más de una tabla o modelo de usuario en la
    | aplicación y deseas tener configuraciones de restablecimiento de
    | contraseña separadas según los tipos de usuario específicos.
    |
    | El tiempo de expiración es la cantidad de minutos que cada token de
    | restablecimiento se considerará válido. Esta característica de seguridad
    | mantiene los tokens de corta duración para que tengan menos tiempo de ser
    | adivinados. Puedes cambiar esto según sea necesario.
    |
    */

    'passwords' => [
        'users' => [
            'provider' => 'users', // El proveedor de usuarios para restablecimiento de contraseñas.
            'table' => 'password_resets', // La tabla que almacena los tokens de restablecimiento de contraseña.
            'expire' => 60, // El tiempo de expiración de los tokens de restablecimiento de contraseña en minutos.
            'throttle' => 60, // El tiempo de espera en segundos antes de poder volver a solicitar un restablecimiento de contraseña.
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Password Confirmation Timeout
    |--------------------------------------------------------------------------
    |
    | Aquí puedes definir la cantidad de segundos antes de que expire la
    | confirmación de contraseña y se solicite al usuario que vuelva a
    | ingresar su contraseña a través de la pantalla de confirmación.
    | Por defecto, el tiempo de espera es de tres horas.
    |
    */

    'password_timeout' => 10800, // Tiempo de espera para confirmación de contraseña en segundos (3 horas por defecto).

];
