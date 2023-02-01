# Jupyter Hub installation on Linux. Requires Python >3.5
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

import subprocess
import sys

# Check if pip is installed
result = subprocess.run(["which", "pip"], stdout=subprocess.PIPE)
if result.returncode != 0:
    print("Error: pip is not installed on the system.")
    sys.exit(1)

# Upgrade pip
result = subprocess.run(["pip", "install", "--upgrade", "pip"])
if result.returncode != 0:
    print("Error: Failed to upgrade pip.")
    sys.exit(1)

# Install Jupyter Hub
result = subprocess.run(["pip", "install", "jupyterhub"])
if result.returncode != 0:
    print("Error: Failed to install Jupyter Hub.")
    sys.exit(1)

# Install required dependencies
result = subprocess.run(["pip", "install", "notebook"])
if result.returncode != 0:
    print("Error: Failed to install the 'notebook' dependency.")
    sys.exit(1)

result = subprocess.run(["pip", "install", "jupyterlab"])
if result.returncode != 0:
    print("Error: Failed to install the 'jupyterlab' dependency.")
    sys.exit(1)

# Start Jupyter Hub
result = subprocess.run(["jupyterhub"])
if result.returncode != 0:
    print("Error: Failed to start Jupyter Hub.")
    sys.exit(1)
