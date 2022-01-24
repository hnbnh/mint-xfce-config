#!/bin/bash

export $(cat .env | xargs)

cd scripts

bash ./config.sh
bash ./apps.sh
bash ./tweak.sh
bash ./font.sh
bash ./post-install.sh
