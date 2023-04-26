app_name="service_name"

default_path="/var/www/html"
tmp_path="/tmp/$app_name"
#default_path="/home/jose/Descargas/new/template"
#tmp_path="/home/jose/Descargas/new/tmp_$app_name"

echo '# Creando directorio temporal ...'
mkdir $tmp_path

echo '# Moviendo archivos y directorios ...'
mv $default_path/docker $tmp_path/
mv $default_path/lang/es $tmp_path/
mv $default_path/app/Helpers $tmp_path/
mv $default_path/stubs $tmp_path/
mv $default_path/app/Rules/OkApiGatewayResponse.php $tmp_path/OkApiGatewayResponse.php
mv $default_path/app/Traits/ApiGatewayConsumer.php $tmp_path/ApiGatewayConsumer.php
mv $default_path/app/Traits/ApiResponser.php $tmp_path/ApiResponser.php
mv $default_path/app/Http/Middleware/AuthenticateAccessMiddleware.php $tmp_path/AuthenticateAccessMiddleware.php
mv $default_path/app/Exceptions/Handler.php $tmp_path/Handler.php
mv $default_path/app/Console/Commands/MakeResourceCommand.php $tmp_path/MakeResourceCommand.php
mv $default_path/app/Console/Commands/MakeAccessTokenCommand.php $tmp_path/MakeAccessTokenCommand.php
mv $default_path/dev_commands.txt $tmp_path/dev_commands.sh
mv $default_path/instrucciones.txt $tmp_path/instrucciones.txt
mv $default_path/install.sh $tmp_path/install.sh
mv $default_path/uninstall.sh $tmp_path/uninstall.sh

echo '# Limpiando directorio por defecto ...'
rm -r $default_path/*
rm -r $default_path/.*

echo '# Moviendo archivos al directorio final ...'
mv $tmp_path/* $default_path/

echo 'Desinstalación terminada con éxito.'