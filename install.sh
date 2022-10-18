app_name="your service name"
cd /temp
laravel new $app_name
mv /temp/$app_name/ /var/www/html
rm /temp/$app_name/
cd /var/www/html
mkdir /var/www/html/app/Traits
mv ApiResponser.php /var/www/html/app/Traits/ApiResponser.php
composer require laravel/octane
RUN printf '0\nyes' | php artisan octane:install
chmod +x ./r
./ -type f -exec chmod 0777 {} \;
./ -type d -exec chmod 0777 {} \;