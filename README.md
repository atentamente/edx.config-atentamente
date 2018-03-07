# Custom Open edX theme for Atentamente.mx


### Notes on modifying translated text
1. URL: https://github.com/edx/edx-platform/wiki/Internationalization-and-localization
2. Source: /edx/app/edxapp/edx-platform/conf/locale/es_419/LC_MESSAGES/django.po
3. To recompile changes:
```
sudo ~/edx.compile-language.sh
```


## To Install theme
1. copy installation scripts to your EC2 Ubuntu instance
```
cd ~
wget https://raw.githubusercontent.com/lpm0073/edx.config-atentamente/master/edx.install-theme.sh
wget https://raw.githubusercontent.com/lpm0073/edx.config-atentamente/master/edx.compile-assets.sh
chown ubuntu *.sh
chgrp ubuntu *.sh
chmod 755 *.sh
```
2. execute the installation script
```
sudo ./edx.install-theme.sh
top
```
3. wait for edX system reboot to complete (takes around 5 minutes on an r3.large EC2 instance)
4. Manually recompile update_assets
```
sudo nohup ./edx.compile-assets.sh &
top
```
5. wait for around 15 minutes or so on an r3.large EC2 instance


## To update server-vars.yml
1. Run edX update script
```
sudo nohup /edx/bin/update edx-platform $(cd /edx/app/edxapp/edx-platform; git rev-parse HEAD) &
```
2. Fix port problem in nginx for LMS
```
sudo vim /edx/app/nginx/sites-available/lms
```
  - on aproximately row 19, change "listen 18000 default_server;" to "listen 80 default_server;"
3. restart nginx
```
sudo service nginx restart
```
4. re-install this custom Open edX theme
```
cd ~
sudo ./edx.install-theme.sh
top
```

## In-Video Quiz XBlock installation
* clone into the home folder: /home/ubuntu/
```
cd ~
git clone https://github.com/Stanford-Online/xblock-in-video-quiz.git
sudo chown edxapp xblock-in-video-quiz
sudo chgrp edxapp xblock-in-video-quiz
sudo -u edxapp /edx/bin/pip.edxapp install /home/ubuntu/xblock-in-video-quiz
sudo ./edx.compile-assets.sh
```

## Setup Annotation Tools
### Overview
http://annotation.chs.harvard.edu/setup.php
https://osc.hul.harvard.edu/liblab/projects/catch-common-annotation-tagging-and-citation-harvard

### Installation instructions
http://catcha.readthedocs.io/en/latest/admin-guide/installation/

## SMTP Setup
https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/64913413/How+to+make+SMTP+work+in+your+Open+EdX+fullstack+instance

### /edx/app/edxapp/lms.env.json
```
    "EMAIL_BACKEND": "django.core.mail.backends.smtp.EmailBackend",
    "EMAIL_HOST": "smtp.gmail.com",
    "EMAIL_PORT": 587,
    "EMAIL_USE_TLS": true,

    "EMAIL_HOST_PASSWORD": "*********",
    "EMAIL_HOST_USER": "edx.atentamente@gmail.com",
```

### /edx/app/edxapp/cms.env.json
```
    "EMAIL_BACKEND": "django.core.mail.backends.smtp.EmailBackend",
    "EMAIL_HOST": "smtp.gmail.com",
    "EMAIL_PORT": 587,
    "EMAIL_USE_TLS": true,

    "EMAIL_HOST_PASSWORD": "*********",
    "EMAIL_HOST_USER": "edx.atentamente@gmail.com",
```

### /edx/app/edxapp/lms.auth.json
```
"EMAIL_HOST_PASSWORD": "*********",
"EMAIL_HOST_USER": "edx.atentamente@gmail.com",
```
### /edx/app/edxapp/cms.auth.json
```
"EMAIL_HOST_PASSWORD": "*********",
"EMAIL_HOST_USER": "edx.atentamente@gmail.com",
```



### edx-platform/lms/envs/common.py

```
EMAIL_BACKEND =django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = ''      #potentially fewer complications w gmail when these are left blank.
EMAIL_HOST_PASSWORD = ''  #potentially fewer complications w gmail when these are left blank.
```


### edx-platform/lms/envs/content.py

```
EMAIL_BACKEND =django.core.mail.backends.smtp.EmailBackend'
```


### edx-platform/lms/envs/devstack.py

```
EMAIL_BACKEND =django.core.mail.backends.smtp.EmailBackend'
```




https://stackoverflow.com/questions/36325662/how-to-backup-and-restore-open-edx-from-one-server-to-other

## Backing up:
```
mysqldump edxapp -u root --single-transaction > backup/backup.sql
mongodump --db edxapp
mongodump --db cs_comments_service_development
```

## Restoring:
```
mysql -u root edxapp < backup.sql
mongo edxapp --eval "db.dropDatabase()"
mongorestore dump/
```


### More detail (backup / restrore)
https://github.com/alikhil/open-edx-configuring/blob/master/README.md#backuping-server-and-restoring-it-on-another-machine


Backuping server and restoring it on another machine

Idea is the same as in BluePlanetLife/openedx-server-prep.

On first machine, where server is running now:

mkdir backup

### backing up mysql db
```
mysqldump edxapp -u root --single-transaction > backup/backup.sql
cd backup
```

### backing up mongo db
```
mongodump --db edxapp
mongodump --db cs_comments_service_development
cd ..
```

### Packing it to single file for easy copying to second sever
```
tar -zcvf backup.tar.gz backup/
```

Now, copy backup.tar.gz to second server. For example using scp:

```
scp backup.tar.gz root@second-server-ip:~/backup.tar.gz
```

And then restore backup on second machine:

### unpacking
```
tar -zxvf backup.tar.gz
cd backup
```

### restoring mysql
```
mysql -u root edxapp < backup.sql
```

### cleaning up mongo db and restoring
```
mongo edxapp --eval "db.dropDatabase()"
mongorestore dump/
```


Example to re-run Ansible playbook after the build:
```
cd /var/tmp/configuration/playbooks
    sudo ansible-playbook -c local ./edx_sandbox.yml -i "localhost," \
        -e NGINX_ENABLE_SSL=True \
        -e NGINX_SSL_CERTIFICATE=<path> \
        -e NGINX_SSL_KEY=<path>
```

CMS Custom Theming: to update static assets, like the logo in the page header for example
```
  sudo -H -u edxapp bash
  source /edx/app/edxapp/edxapp_env
  cd /edx/app/edxapp/edx-platform
  paver update_assets cms --settings=aws
  paver update_assets lms --settings=aws
```

## Lets Encrypt
  https://certbot.eff.org/#ubuntuxenial-nginx
  https://github.com/CDOT-EDX/ProductionStackDocs/wiki/Configuring-SSL-for-NGINX

### Certificate:
/etc/letsencrypt/live/educacion.atentamente.mx/fullchain.pem


### Key file has been saved at:
/etc/letsencrypt/live/educacion.atentamente.mx/privkey.pem

Your cert will expire on 2018-03-11. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot again
   with the "certonly" option. To non-interactively renew *all* of
   your certificates, run "certbot renew"



Install certbot and get a certificate for your Open EdX instance. Note that you
will probably have to include several CN's or get several certificates, for
example for the subdomains you have for studio, preview, etc. Find out where
Certbot places your certificates, and remember that location.
Next, we will add the certificate path to server-vars.yml so the update
script can place them in the correct location:

```
NGINX_ENABLE_SSL: True
NGINX_REDIRECT_TO_HTTPS: True
NGINX_SSL_CERTIFICATE: '/etc/letsencrypt/live/educacion.atentamente.mx/fullchain.pem'
NGINX_SSL_KEY: '/etc/letsencrypt/live/educacion.atentamente.mx/privkey.pem'
```


### Automating renewal
The Certbot packages on your system come with a cron job that will renew your certificates automatically before they expire. Since Let's Encrypt certificates last for 90 days, it's highly advisable to take advantage of this feature. You can test automatic renewal for your certificates by running this command:

```
sudo certbot renew --dry-run
```
If that appears to be working correctly, you can arrange for automatic renewal by adding a cron or systemd job which runs the following:
```
certbot renew
```
More detailed information and options about renewal can be found in the full documentation.
