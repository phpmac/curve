FROM php:8.2-apache

# 安装 curl 依赖
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 PHP curl 扩展
RUN docker-php-ext-install curl

# 配置 Apache
RUN a2enmod rewrite
RUN a2enmod php

WORKDIR /var/www/html
COPY . /var/www/html/

# Apache 配置
RUN echo '<Directory /var/www/html/>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/docker-php.conf \
    && a2enconf docker-php

# 确保 PHP 文件被正确处理
RUN echo "AddType application/x-httpd-php .php" >> /etc/apache2/apache2.conf
RUN echo "DirectoryIndex index.php" >> /etc/apache2/apache2.conf

# 设置权限
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

CMD ["apache2-foreground"] 