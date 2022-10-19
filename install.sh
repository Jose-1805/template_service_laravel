app_name="service_name"

echo '### find /var/www/html/ -type f -exec chmod 0777 {} \;'
find /var/www/html/ -type f -exec chmod 0777 {} \;

echo '### find /var/www/html/ -type d -exec chmod 0777 {} \;'
find /var/www/html/ -type d -exec chmod 0777 {} \;

echo '### composer create-project laravel/laravel /tmp/$app_name'
composer create-project laravel/laravel /tmp/$app_name

echo '### mv /tmp/$app_name/.* /var/www/html/'
mv /tmp/$app_name/.* /var/www/html/

echo '### mv /tmp/$app_name/* /var/www/html/'
mv /tmp/$app_name/* /var/www/html/

echo '### rm -r /tmp/$app_name/'
rm -r /tmp/$app_name/

echo '### rm -r /var/www/html/.git'
rm -r /var/www/html/.git

echo '### mkdir /var/www/html/app/Traits'
mkdir /var/www/html/app/Traits

echo '### mv ApiResponser.php /var/www/html/app/Traits/ApiResponser.php'
mv ApiResponser.php /var/www/html/app/Traits/ApiResponser.php

echo '### mv /var/www/html/es/ /var/www/html/lang/'
mv /var/www/html/es/ /var/www/html/lang/

echo '### mv /var/www/html/app.php /var/www/html/config/app.php'
mv /var/www/html/app.php /var/www/html/config/app.php

echo '### composer require laravel/octane'
composer require laravel/octane

echo '### printf '0\nyes' | php artisan octane:install'
printf '0\nyes' | php artisan octane:install

echo '### chmod +x /var/www/html/rr'
chmod +x /var/www/html/rr

echo '### find /var/www/html/ -type f -exec chmod 0777 {} \;'
find /var/www/html/ -type f -exec chmod 0777 {} \;

echo '### find /var/www/html/ -type d -exec chmod 0777 {} \;'
find /var/www/html/ -type d -exec chmod 0777 {} \;
