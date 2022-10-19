echo '#### app_name="seller_service"'
app_name="seller_service"

echo '#### mkdir /tmp/$app_name'
mkdir /tmp/$app_name

echo '#### mv /var/www/html/docker /tmp/$app_name/'
mv /var/www/html/docker /tmp/$app_name/

echo '#### mv /var/www/html/lang/es /tmp/$app_name/'
mv /var/www/html/lang/es /tmp/$app_name/

echo '#### mv /var/www/html/app/Traits/ApiResponser.php /tmp/$app_name/ApiResponser.php'
mv /var/www/html/app/Traits/ApiResponser.php /tmp/$app_name/ApiResponser.php

echo '#### mv /var/www/html/config/app.php /tmp/$app_name/app.php'
mv /var/www/html/config/app.php /tmp/$app_name/app.php

echo '#### mv /var/www/html/dev_commands.txt /tmp/$app_name/dev_commands.txt'
mv /var/www/html/dev_commands.txt /tmp/$app_name/dev_commands.txt

echo '#### mv /var/www/html/install.sh /tmp/$app_name/install.sh'
mv /var/www/html/install.sh /tmp/$app_name/install.sh

echo '#### cp /var/www/html/uninstall.sh /tmp/$app_name/uninstall.sh'
cp /var/www/html/uninstall.sh /tmp/$app_name/uninstall.sh

echo '#### chmod +x /tmp/seller_service/uninstall.sh'
chmod +x /tmp/seller_service/uninstall.sh

echo '#### rm -r /var/www/html/*'
rm -r /var/www/html/*

echo '#### rm -r /var/www/html/.*'
rm -r /var/www/html/.*

echo '#### mv /tmp/$app_name/* /var/www/html/'
mv /tmp/$app_name/* /var/www/html/

