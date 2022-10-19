app_name="your service name"
find /var/www/html/ -type f -exec chmod 0777 {} \;
find /var/www/html/ -type d -exec chmod 0777 {} \;
composer create-project laravel/laravel /tmp/$app_name
mv /tmp/$app_name/.* /var/www/html/
mv /tmp/$app_name/* /var/www/html/
rm -r /tmp/$app_name/
rm -r /var/www/html/.git
mkdir /var/www/html/app/Traits
mv ApiResponser.php /var/www/html/app/Traits/ApiResponser.php
mv /var/www/html/es/ /var/www/html/lang/
composer require laravel/octane
printf '0\nyes' | php artisan octane:install
chmod +x /var/www/html/rr
find /var/www/html/ -type f -exec chmod 0777 {} \;
find /var/www/html/ -type d -exec chmod 0777 {} \;