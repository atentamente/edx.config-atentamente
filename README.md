# Custom Open edX theme for Atentamente.mx

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



## SMTP Setup
https://openedx.atlassian.net/wiki/spaces/OpenOPS/pages/64913413/How+to+make+SMTP+work+in+your+Open+EdX+fullstack+instance

Host entrada: mail.enlinea.in
Port: 110

Host salida: mail.enlinea.in
Port: 26
puerto 587 (mediante TLS) (también se puede usar)

/edx/app/edxapp/edx-platform/lms/envs/aws.pyc
/edx/app/edxapp/edx-platform/cms/envs/common.py


cs_comments_service_development

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


## SSL Notes:
  https://github.com/CDOT-EDX/ProductionStackDocs/wiki/Configuring-SSL-for-NGINX

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
