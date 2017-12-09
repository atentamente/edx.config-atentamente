#!/bin/bash

rm -rf edx.config-learnmel
git clone https://github.com/lpm0073/edx.config-learnmel.git
chown edxapp -R edx.config-learnmel
chgrp edxapp -R edx.config-learnmel
cp /home/ubuntu/edx.config-learnmel/conf/lms.env.json /edx/app/edxapp/lms.env.json
cp /home/ubuntu/edx.config-learnmel/conf/lms.auth.json /edx/app/edxapp/lms.auth.json
cp /home/ubuntu/edx.config-learnmel/conf/cms.env.json /edx/app/edxapp/cms.env.json
cp /home/ubuntu/edx.config-learnmel/conf/cms.auth.json /edx/app/edxapp/cms.auth.json

chmod 644 /edx/app/edxapp/*.env.json
chmod 755 /edx/app/edxapp/*.auth.json
/edx/bin/supervisorctl restart edxapp:
/edx/bin/supervisorctl restart edxapp_worker:
