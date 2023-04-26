app_name="service_name"

default_path="/var/www/html"
tmp_path="/tmp/$app_name"
#default_path="/home/jose/Descargas/new/template_service"
#tmp_path="/home/jose/Descargas/new/tmp_$app_name"

echo "shopt -s dotglob"
shopt -s dotglob

echo '# Creando proyecto en ruta temporal ...'
composer create-project laravel/laravel $tmp_path

echo '# Moviendo archivos ocultos a ruta final $default_path ...'
mv $tmp_path/.* $default_path/

echo '# Moviendo archivos y directorios a ruta final $default_path ...'
mv $tmp_path/* $default_path/

echo '# Eliminando ruta temporal ...'
rm -r $tmp_path/

echo '# Eliminando modelo de usuario User.php ...'
rm $default_path/app/Models/User.php

echo '# Creando directorio para almacenamiento de reglas de validación ...'
mkdir $default_path/app/Rules

echo '# Creando regla para validar respuesta obtenida de un método del ApiGateway ...'
mv OkApiGatewayResponse.php $default_path/app/Rules/OkApiGatewayResponse.php

echo '# Creando directorio para almacenamiento de Traits'
mkdir $default_path/app/Traits

echo '# Creando Trait de estandarización de respuestas ...'
mv ApiResponser.php $default_path/app/Traits/ApiResponser.php

echo '# Creando trait para consumir métodos del Api Gateway desde un servicio...'
mv ApiGatewayConsumer.php $default_path/app/Traits/ApiGatewayConsumer.php

echo '# Creando directorio para almacenamiento de comandos ...'
mkdir $default_path/app/Console/Commands

echo '#  Creando comando para la generación de recursos y configuraciones de módulos del sistena'
mv MakeResourceCommand.php $default_path/app/Console/Commands/MakeResourceCommand.php

echo '# Creando middleware de autenticación de solicitudes al servicio ...'
mv AuthenticateAccessMiddleware.php $default_path/app/Http/Middleware/AuthenticateAccessMiddleware.php

echo '# Creando manejador de excepciones del sistema ...'
mv Handler.php $default_path/app/Exceptions/Handler.php

echo '# Publicando archivos de internacionalización ...'
php artisan lang:publish

echo '# Creando archivos de internacionalización para español ...'
mv $default_path/es $default_path/lang/

echo '# Desinstalando laravel sanctum'
composer remove laravel/sanctum

echo '# Instalando laravel octane para mejorar el rendimiento de la aplicación ...'
composer require laravel/octane --with-all-dependencies
# Realiza la instalación de laravel octane con las respuestas de consola necesarias
printf '0\nyes' | php artisan octane:install
# Permisos de ejecución para el archivo rr
chmod +x $default_path/rr

echo '# Eliminación de migraciones'
rm -r $default_path/database/migrations

echo '# Creando StubFormatter.php para crear clases de objetos laravel dinámicamente ...'
mv $default_path/Helpers $default_path/app/

echo '# Asignando permisos de edición al proyecto'
sh ./docker/commands/dev_files_permissions.sh
sh ./docker/commands/dev_dir_permissions.sh

echo '# Servicio instalado con éxito. Realice las siguientes configuraciones para terminar.'
echo ''
echo '1. Agregue el valor \App\Http\Middleware\AuthenticateAccessMiddleware::class en app\Http\Kernel.php en la variable $middleware'
echo '2. Ejecute el comando php artisan make:access_token en el contenedor para generar un token de acceso al servicio'
echo '3. Agregue la clave access_tokens con el valor env("ACCESS_TOKENS") en config\services.php'
echo "4. Agregue la clave api_gateway con el valor array ['base_uri' => env('API_GATEWAY_BASE_URI'), 'access_token' => env('API_GATEWAY_ACCESS_TOKEN')] en config\services.php. Configure estos valores en el archivo .env"
echo '5. Configure su archivo .env'