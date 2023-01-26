#!/bin/bash
# LAMP installation on Centos 9 Stream
#
# Copyright 2023 Robert Crowe
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the Apache License as published by
# the Apache Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# Apache License for more details.
#
# You should have received a copy of the Apache License
# along with this program.  If not, see <https://apache.org/licenses/>.

#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Update system
dnf -y update || { echo "Error updating system"; exit 1; }

# Check if Apache is already installed
if dnf list installed httpd > /dev/null 2>&1; then
    echo "Apache is already installed"
else
    # Install Apache
    dnf -y install httpd || { echo "Error installing Apache"; exit 1; }
    # Start Apache and enable it on boot
    systemctl start httpd
    systemctl enable httpd
fi

# Check if MySQL is already installed
if dnf list installed mysql-server > /dev/null 2>&1; then
    echo "MySQL is already installed"
else
    # Install MySQL
    dnf -y install mysql-server || { echo "Error installing MySQL"; exit 1; }
    # Start MySQL and enable it on boot
    systemctl start mysqld
    systemctl enable mysqld
    # Secure MySQL
    echo "Please enter a username for the MySQL root user:"
    read mysql_username
    echo "Please enter a password for the MySQL root user:"
    read -s mysql_password
    mysql_secure_installation <<EOF

Y
$mysql_username
$mysql_password
Y
Y
Y
EOF
fi

# Check if PHP is already installed
if dnf list installed php > /dev/null 2>&1; then
    echo "PHP is already installed"
else
    # Install PHP
    dnf -y install php php-mysqlnd php-common php-gd php-mbstring php-xml || { echo "Error installing PHP"; exit 1; }
    # Restart Apache
    systemctl restart httpd
fi

echo "LAMP installation completed successfully!"
