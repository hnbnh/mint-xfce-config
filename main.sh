#!/bin/bash

if [ ! -f .env ]; then
    echo "Please create .env"
    exit 1
fi

export $(cat .env | xargs)

bash ./scripts/config.sh
bash ./scripts/apps.sh
bash ./scripts/tweak.sh
bash ./scripts/font.sh
bash ./scripts/post-install.sh
