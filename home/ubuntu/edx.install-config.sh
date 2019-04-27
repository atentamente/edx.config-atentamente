# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       feb-2018
#
# usage:      1. install open edx lms + cms config files
#             2. nginx custom configurations
#             3. ansible customizations
#             4. install custom theme.
#             5. django LMS/CMS configuration overrides
#             6. admin scripts
#---------------------------------------------------------

sudo rm -rf /home/ubuntu/edx.config-atentamente
git clone https://github.com/atentamente/edx.config-atentamente.git

echo 1. open edx LMS + CMS configuration
sudo cp /home/ubuntu/edx.config-atentamente/edx/app/edxapp/*.json /edx/app/edxapp/
sudo chown -R edxapp /edx/app/edxapp/*.json
sudo chgrp -R www-data /edx/app/edxapp/*.json

echo 2. Nginx custom configurations
# these contain lets encrypt ssl certificate and https redirection
sudo cp /home/ubuntu/edx.config-atentamente/edx/app/nginx/sites-available/* /edx/app/nginx/sites-available/

echo 3. Ansible customizations
# copy server-vars and any other mods to ansible-related work flows
sudo cp /home/ubuntu/edx.config-atentamente/edx/app/edx_ansible/*.* /edx/app/edx_ansible/edx_ansible/

echo 4. install custom theme
sudo cp -R /home/ubuntu/edx.config-atentamente/themes/atentamente /edx/app/edxapp/edx-platform/themes/
sudo chown -R edxapp /edx/app/edxapp/edx-platform/themes/
sudo chgrp -R www-data /edx/app/edxapp/edx-platform/themes/

#echo 5. django configuration files
# nothing to do

#echo 6. admin scripts
#sudo cp -R /home/ubuntu/edx.config-atentamente/home/ubuntu/* /home/ubuntu/
