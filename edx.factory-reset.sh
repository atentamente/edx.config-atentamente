#!/bin/bash

cp /edx/app/edxapp/lms.env.json-ORIG /edx/app/edxapp/lms.env.json
cp /edx/app/edxapp/lms.auth.json-ORIG /edx/app/edxapp/lms.auth.json
cp /edx/app/edxapp/cms.env.json-ORIG /edx/app/edxapp/cms.env.json
cp /edx/app/edxapp/cms.auth.json-ORIG /edx/app/edxapp/cms.auth.json
chmod 644 /edx/app/edxapp/*.env.json
chmod 755 /edx/app/edxapp/*.auth.json
/edx/bin/supervisorctl restart edxapp:
