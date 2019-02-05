# vagrant-symfony

SYMFONY stack (Debian, Apache, PHP, PostgreSQL, Adminer, MailDev)

Operatin system:
- **Debian**

Web server:
- **Apache**

Programming language:
- **PHP**

Database:
- SQLite
- MariaDB
- **PostgreSQL**
- MongoDB

Database management:
- **Adminer**
- PhpMyAdmin
- PhpPgAdmin

JavaScript runtime environment:
- **Node.js**

Package management:
- PHP
  - **Composer**
- JavaScript
  - **npm**
  - pnpm
  - **yarn**

Development:
- BrowserSync
- Drush
- Drupal console

Email testing:
- **MailDev**
- MailCatcher

## Requirements
1. [Vagrant](https://www.vagrantup.com/?target=_blank)
    - Windows note: If your account folder name (C:\Users\account-folder-name\) contains **non ASCII characters**, before Vagrant instalation set custom Vagrant home path e.g.:
        
          setx VAGRANT_HOME "X:\my\vagrant\home\path"

1. [VirtualBox](https://www.virtualbox.org/?target=_blank)
    - VirtualBox Extension Pack (optional)

1. [Git](https://git-scm.com/?target=_blank) (optional)

## Usage

1. Enable CPU virtualization technology in BIOS.

    - Disable Hyper-V technology in operatin system (Windows only).
      
1. Clone or download and extract [vagrant-symfony](https://github.com/vavyskov/vagrant-symfony/archive/master.zip?target=_blank) repository:
        
       git clone https://github.com/vavyskov/vagrant-symfony.git

1. Open the terminal, navigate to the directory containing the file `Vagrantfile` and run command:

       vagrant plugin install vagrant-winnfsd (Windows only)
       vagrant plugin install vagrant-bindfs
       vagrant up (reload, halt, destroy)
             
    Customization:
        
    - Distribution (only `symfony`, `lamp` or `node`):
       
          vagrant --dist=lamp up
          vagrant --dist=lamp halt
       
      Note: if you use `--dist` option at start up, you have to use `--dist` options on each vagrant command.
    
    - Other examples:
   
          vagrant --name=project up
          vagrant --dist=symfony --name=project --port=8080 --ip=192.168.33.10 up

   Note: the custom options need to be specified before `up` command.

1. Open the web browser:

    **Web**:
    - URL: `localhost` or `192.168.33.10`
    - **Edit the local (host) directory** `www` as you needed

    **Adminer**:
    - URL: `localhost/adminer` or `192.168.33.10/adminer`
	- System: `PostgreSQL`
    - Server: `localhost`
	- User: `postgresql`
	- Password: `postgresql`
	- Database: `postgresql`
	
	**MailDev** displays sent emails:
	- URL: `localhost:1080` or `192.168.33.10:1080`
    - Open the terminal, navigate to the directory containing the file Vagrantfile and send a test e-mail:
        
          vagrant ssh
          php /vagrant/test/send-mail.php 

1. Optional configure your system `hosts` file:

		192.168.33.10 devel.example.com

	Path:
    - Linux: `/etc/hosts`
	- macOX: `/private/etc/hosts`
	- Windows: `C:\Windows\System32\drivers\etc\hosts`

1. Open the terminal, navigate to the directory containing the file `Vagrantfile` and for new Symfony project run commands:

        vagrant ssh
        rm -r www/*
        composer create-project symfony/website-skeleton www
        cd www
        composer remove symfony/web-server-bundle
        composer require symfony/apache-pack
        
    Setup new **Git** repository:
    
        git init
        git add .
        git commit -m "Initial commit"
        
    or existing **Git** repository:
        
        git clone ...
        composer install
    
    Security (optional):
    
        composer require sensiolabs/security-checker --dev

1. The database is automatically restore and backup by using the triggers:

    Restore: `vagrant up` (resume, reload)
    
    Backup: `vagrant halt` (suspend, destroy)

1. Update box version

    Open the terminal, navigate to the directory containing the file `Vagrantfile` and run command:
    
    - check updates:

            vagrant box outdated
        
    - box update:
    
            vagrant destroy
            vagrant box update

## Project scripts

Create/delete user, virtual host and database:

    sudo project-create
    sudo project-delete
    
Project info file location: `/home/<project>/project-info.txt`

## Instalation scripts

The folder `vagrant/install` contains several installation scripts:

- **NTP** time servers

      sudo /vagrant/install/ntp.sh intranet
      sudo /vagrant/install/ntp.sh internet

- **Apache** is a web server

      sudo /vagrant/install/apache.sh

- **Node.js** is a JavaScript run-time environment that executes JavaScript code outside of a browser

      sudo /vagrant/install/nodejs.sh

- **PHP** allows you to change PHP version

      sudo /vagrant/install/php.sh 5.6
      sudo /vagrant/install/php.sh 7.0
      sudo /vagrant/install/php.sh 7.1
      sudo /vagrant/install/php.sh 7.2 (default)
      sudo /vagrant/install/php.sh 7.3

- **PHP Intl** upgrades ICU in php-intl (it takes some time)

      sudo /vagrant/install/php-intl.sh

- **XDebug** is a debugger and profiler tool for PHP

      sudo /vagrant/install/xdebug.sh

- **SQLite** stores the entire database as a single cross-platform file

      sudo /vagrant/install/sqlite.sh

- **MariaDB** is an enhanced replacement for MySQL

      sudo /vagrant/install/mariadb.sh 10.1
      sudo /vagrant/install/mariadb.sh 10.2
      sudo /vagrant/install/mariadb.sh 10.3 (default)

- **PostgreSQL** is a object-relation database system

      sudo /vagrant/install/postgresql.sh

- **MongoDB** is a document-oriented database

      sudo /vagrant/install/mongodb.sh

- **Adminer** is an universal database management in a single PHP file

      sudo /vagrant/install/adminer.sh

- **PhpMyAdmin** allows MySQL administration over the web

      sudo /vagrant/install/phpmyadmin.sh
   
- **PhpPgAdmin** is a administration tool for PostgreSQL

      sudo /vagrant/install/phpmyadmin.sh

- **Image Tools** contains imagemagick (optipng, gifsicle, libjpeg-progs)

      sudo /vagrant/install/image-tools.sh

- **Drupal Tools** contains Drush and Drupal console

      sudo /vagrant/install/drupal-tools.sh

- **BrowserSync** time-saving synchronised browser testing

      sudo /vagrant/install/browser-sync.sh
      
  BrowserSync UI: `localhost:3001`

- **Email testing UI**

      sudo /vagrant/install/maildev.sh (default)
      sudo /vagrant/install/mailcatcher.sh

## Package

How to create your own reusable box:

    vagrant plugin install vagrant-vbguest (optional)
    vagrant up
    vagrant halt (it correctly upgrades the linux-headers, Virtualbox guest additions etc.)
    vagrant up
    vagrant package

## FixMe
- Locales (file order in terminal)
- Current script directory path (macOS: php.sh)

## ToDo

- Alternative software detection if exec() is disabled (phpinfo() to array)
- Node distribution (terminal info, PHP proxy)
- HTTP-Server (terminal info URL 10.0.2.15 does not work)
- BrowserSync (Node distribution) - UI port 3001 is OK, port 3000 or 80 not work correctly
- Nginx server (php.sh, adminer.sh, mailcatcher.sh, browser-sync.sh)
- DB backup/restore (project DB only as extra file)
- MariaDB (latest only, check change version)
- VM name as "parent directory"
- Info page link (phpMyAdmin, Adminer and pgAdmin) or localhost/db page
- Better purge.sh script
- Vagrant plugins "auto installation"
- Enable create "new database"
- Plugin: vagrant-hostsupdater, vagrant-hostmanager
- Disable access to PostgreSQL system databases (postgres, template0, template1)
- Memcached
- MailDev UI - Czech date and time format
- Install script dependencies (PhpMyAdmin+PHP+MariaDB, XDebug+PHP, MailDev+Apache2)
- PhpMyAdmin cron auto update
- Vagrant config.yaml
- PhpPgAdmin (latest version)
- Active "localhost" link in terminal (after running `vagrant up` command)
- Warning: Connection aborted. Retrying... (vagrant up)
- Drush launcher
- Drupal Console launcher

## Note

- Skype (Windows): Go to Tools → Options → Advanced → Connections and uncheck the box use port 80 and 443 as alternative.
- MailCatcher "From" is not the same as "Source From" (**MailDev**, MailHog)
- https://github.com/benjaminkott/bootstrap_package_box/blob/master/Vagrantfile
- https://www.jhipster.tech/configuring-a-corporate-proxy/
