#!/bin/bash

rm -rf edx.config-learnmel
git clone https://github.com/70F/edx.config-learnmel.git
chown edxapp -R edx.config-learnmel
chgrp edxapp -R edx.config-learnmel
