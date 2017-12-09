# theme-atentamente.mx



SSL Note:
  https://github.com/CDOT-EDX/ProductionStackDocs/wiki/Configuring-SSL-for-NGINX


Example to re-run Ansible playbook after the build:
cd /var/tmp/configuration/playbooks
    sudo ansible-playbook -c local ./edx_sandbox.yml -i "localhost," \
        -e NGINX_ENABLE_SSL=True \
        -e NGINX_SSL_CERTIFICATE=<path> \
        -e NGINX_SSL_KEY=<path>


CMS Custom Theming: to update static assets, like the logo in the page header for example

  sudo -H -u edxapp bash
  source /edx/app/edxapp/edxapp_env
  cd /edx/app/edxapp/edx-platform
  paver update_assets cms --settings=aws
  paver update_assets lms --settings=aws
