#!/bin/bash

#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root user"
else
    echo "Not running as root user"
    exit 1
fi