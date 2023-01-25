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

import os
import subprocess

# Check for dependencies
dependencies = ["httpd", "mariadb-server", "php"]
for dependency in dependencies:
    if not os.system(f"rpm -q {dependency} > /dev/null 2>&1"):
        print(f"{dependency} is already installed.")
    else:
        os.system(f"dnf install -y {dependency}")

# Start and enable Apache and MariaDB services
os.system("systemctl start httpd")
os.system("systemctl enable httpd")
os.system("systemctl start mariadb")
os.system("systemctl enable mariadb")

# Run mysql_secure_installation prompt for username and password
username = input("Enter a MySQL username: ")
password = input("Enter a MySQL password: ")
mysql_secure = subprocess.run(["mysql_secure_installation"], input=f"\n{password}\n{password}\nY\nY\nY\nY\n", encoding="utf-8", capture_output=True)

# Check for errors
if mysql_secure.returncode != 0:
    print("Error:", mysql_secure.stderr)
else:
    print("MySQL secure installation completed successfully.")
