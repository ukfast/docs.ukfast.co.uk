# Multiple PHP Installations

### Install Additional PHP Version

#### PHP 7.1
```bash
yum install --disablerepo='*' --enablerepo=base,remi,epel,updates php71-php php71-php-mcrypt php71-php-pdo php71-php-mysqlnd php71-php-opcache php71-php-xml php71-php-gd php71-php-devel php71-php-mysql php71-php-intl php71-php-mbstring php71-php-bcmath php71-php-json php71-php-iconv php71-php-pecl-redis php71-php-fpm php71-php-zip php71-php-soap
```

#### PHP 7.2
```bash
yum install --disablerepo='*' --enablerepo=base,remi,epel,updates php72-php php72-php-pecl-mcrypt php72-php-pdo php72-php-mysqlnd php72-php-opcache php72-php-xml php72-php-gd php72-php-devel php72-php-mysql php72-php-intl php72-php-mbstring php72-php-bcmath php72-php-json php72-php-iconv php72-php-pecl-redis php72-php-fpm php72-php-zip php72-php-soap
```

### Apply Magento 2 PHP optimizations
Simply colpy and paste the below:
```bash
sed -i 's/opcache.memory_consumption=128/opcache.memory_consumption=512/g' /etc/opt/remi/php7?/php.d/*opcache.ini
sed -i 's/opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=12/g' /etc/opt/remi/php7?/php.d/*opcache.ini
sed -i 's/opcache.max_accelerated_files=4000/opcache.max_accelerated_files=60000/g' /etc/opt/remi/php7?/php.d/*opcache.ini
sed -i 's/;opcache.save_comments=0/opcache.save_comments=1/g' /etc/opt/remi/php7?/php.d/*opcache.ini
sed -i 's/;opcache.save_comments=1/opcache.save_comments=1/g' /etc/opt/remi/php7?/php.d/*opcache.ini
sed -i 's/opcache.save_comments=0/opcache.save_comments=1/g' /etc/opt/remi/php7?/php.d/*opcache.ini
sed -i 's/;opcache.load_comments=1/opcache.load_comments=1/g' /etc/opt/remi/php7?/php.d/*opcache.ini
sed -i 's/;opcache.enable_file_override=0/opcache.enable_file_override=1/g' /etc/opt/remi/php7?/php.d/*opcache.ini
sed -ie "s_;date.timezone =_date.timezone = "Europe/London"_g" /etc/opt/remi/php7?/php.ini
sed -ie "s/; max_input_vars = 1000/max_input_vars = 20000/g" /etc/opt/remi/php7?/php.ini
sed -ie "s/memory_limit = 128M/memory_limit = 756M/" /etc/opt/remi/php7?/php.ini
sed -ie "s/max_execution_time = 30/max_execution_time = 18000/" /etc/opt/remi/php7?/php.ini
sed -ie "s/max_input_time = 60/max_input_time = 90/" /etc/opt/remi/php7?/php.ini
sed -ie "s/short_open_tag = Off/short_open_tag = On/" /etc/opt/remi/php7?/php.ini
sed -ie "s/;always_populate_raw_post_data = On/always_populate_raw_post_data = -1/" /etc/opt/remi/php7?/php.ini
sed -ie "s/expose_php = On/expose_php = Off/" /etc/opt/remi/php7?/php.ini
sed -ie "s/upload_max_filesize = 2M/upload_max_filesize = 8M/" /etc/opt/remi/php7?/php.ini
sed -ie "s/zlib.output_compression = Off/zlib.output_compression = On/" /etc/opt/remi/php7?/php.ini
echo "suhosin.session.cryptua = off" >> /etc/opt/remi/php7?/php.ini
echo ";Default" > /etc/opt/remi/php7?/php-fpm.d/www.conf
```

### Configure PHP-FPM

#### Copy Original PHP-FPM Configuration File(s)
We recommend you only copy the domain(s) configureation file you want to use the additional PHP version.
```bash
cp /etc/php-fpm.d/examplecom.conf /etc/opt/remi/php7?/php-fpm.d/examplecom.conf
```
#### Edit The Copied File(S) 
Ensure you change the following in the copied PHP-FPM configuration file depending on the version of the addtional install (Using version 7.2 as an example to added 72):

```bash
[examplecom72]
listen = '/var/run/php-fpm-examplecom72.sock'
slowlog = /var/www/vhosts/example.com/example.com-phpfpm-slow72.log
php_admin_value[error_log] = /var/www/vhosts/example.com/example.com-phpfpm-error72.log
```


```eval_rst
  .. meta::
     :title: Magento 2 Multiple PHP Installations | UKFast Documentation
     :description: A guide to installing and running multiple versions of PHP
     :keywords: ukfast, linux, nginx, install, centos, cloud, server, virtual, Magento2, security, php-fpm, php

