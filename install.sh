app_name="service_name"

default_path="/var/www/html"
tmp_path="/tmp/$app_name"
#default_path="/home/jose/Descargas/new/template_service"
#tmp_path="/home/jose/Descargas/new/tmp_$app_name"

REDIS=0
# Definir los argumentos
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -r|--redis)
    REDIS=1
    shift
    shift
    ;;
    #-o|--output)
    #OUTPUT="$2"
    #shift
    #shift
    #;;
    *)
    shift
    ;;
esac
done

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

echo '# Creando trait para crear un Validator a partir de un FormRequest...'
mv FormRequestToValidator.php $default_path/app/Traits/FormRequestToValidator.php

echo '#  Creando comandos'
mv $default_path/Commands $default_path/app/Console/

echo '# Creando middleware de autenticación de solicitudes al servicio ...'
mv AuthenticateAccessMiddleware.php $default_path/app/Http/Middleware/AuthenticateAccessMiddleware.php

echo '# Creando middleware para asignar usuario de la solicitud ...'
mv SetUserRequest.php $default_path/app/Http/Middleware/SetUserRequest.php

echo '# Creando modelo de usuario ...'
mv User.php $default_path/app/Models/User.php

echo '# Creando manejador de excepciones del sistema ...'
mv Handler.php $default_path/app/Exceptions/Handler.php

echo '# Publicando archivos de internacionalización ...'
php artisan lang:publish

echo '# Creando archivos de internacionalización para español ...'
mv $default_path/es $default_path/lang/

echo '# Creando archivos de ejecución en segundo plano ...'
mv $default_path/Background $default_path/app/
mv $default_path/background.php $default_path/config/background.php

echo '# Desinstalando laravel sanctum'
composer remove laravel/sanctum
rm $default_path/config/sanctum.php

echo '# Instalando laravel octane para mejorar el rendimiento de la aplicación ...'
composer require laravel/octane --with-all-dependencies
# Realiza la instalación de laravel octane con las respuestas de consola necesarias
printf '0\nyes' | php artisan octane:install
# Permisos de ejecución para el archivo rr
chmod +x $default_path/rr

echo '# Instalando paquete de conexión a rabbitmq (bschmitt/laravel-amqp)'
composer require bschmitt/laravel-amqp.'
mv amqp.php $default_path/config/amqp.php

if [ "$REDIS" -eq 1 ]
then
    echo '# Insalando redis'
    composer require predis/predis
fi

echo '# Eliminación de migraciones'
rm -r $default_path/database/migrations

echo '# Creando StubFormatter.php para crear clases de objetos laravel dinámicamente ...'
mv $default_path/Helpers $default_path/app/

echo '# Asignando permisos de edición al proyecto'
sh ./docker/commands/dev_files_permissions.sh
sh ./docker/commands/dev_dir_permissions.sh

echo '# Servicio instalado con éxito. Realice las siguientes configuraciones para terminar.'
echo ''
echo '* Agregue el valor \App\Http\Middleware\AuthenticateAccessMiddleware::class en app\Http\Kernel.php en la variable $middleware'
echo '* Agregue el valor "set_user_request" => \App\Http\Middleware\SetUserRequest::class, en app\Http\Kernel.php en la variable $middlewareAliases'
echo '* Ejecute el comando php artisan make:access_token en el contenedor para generar un token de acceso al servicio'
echo '* Agregue la clave access_tokens con el valor env("ACCESS_TOKENS") en config\services.php'
echo '* Agregue la clave api_gateway con el valor array ['base_uri' => env('API_GATEWAY_BASE_URI'), 'access_token' => env('API_GATEWAY_ACCESS_TOKEN')] en config\services.php. Configure estos valores en el archivo .env'
echo '* Agregue Bschmitt\Amqp\AmqpServiceProvider::class a la lista de providers en el archivo config/app.php'
echo '* Agregue "Amqp" => Bschmitt\Amqp\Facades\Amqp::class a la lista de aliases en el archivo config/app.php'
echo '* Agregue las siguientes variables a su archivo .env para configurar la conexión a rabbitmq'
echo '          RABBITMQ_HOST'
echo '          RABBITMQ_PORT'
echo '          RABBITMQ_USER'
echo '          RABBITMQ_PASSWORD'
echo '          RABBITMQ_VHOST'
echo '* Configure su archivo .env para el acceso a la base de datos'
if [ "$REDIS" -eq 1 ]
then
    echo '* Configure su archivo .env para la conexión con redis (datos de acceso, host, puerto, cliente. Si va a manejar sesión, cache, etc)'
fi