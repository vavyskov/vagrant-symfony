# vagrant-symfony

Symfony stack (Debian, Apache, PHP, PostgreSQL, Node.js, Yarn, Adminer, MailDev)

## Requirements
1. [VirtualBox](https://www.virtualbox.org/) + Extension Pack
1. [Vagrant](https://www.vagrantup.com/)
    - `vagrant-winnfsd` plugin (Windows only)
    - `vagrant-bindfs` plugin
    - **Windows note**: If your account folder name (C:\Users\account-folder-name\) contains non ASCII characters, before Vagrant instalation set custom Vagrant home path e.g.:
        
          setx VAGRANT_HOME "X:\my\vagrant\home\path"
        
1. [Git](https://git-scm.com/) (optional)

## Usage

1. Enable CPU virtualization technology in BIOS.

    - Disable Hyper-V technology in operatin system (Windows only).
      
1. Download and extract ZIP file or clone the repository:

        git clone https://github.com/vavyskov/vagrant-symfony.git

1. Open the terminal, navigate to the directory containing the file `Vagrantfile` and run command:

        vagrant plugin install vagrant-winnfsd (Windows only)
        vagrant plugin install vagrant-bindfs
        vagrant up (reload, halt, destroy)
             
   Customization:
   
        vagrant --name=project up
        vagrant --name=project --port=8080 --ip=192.168.33.10 up

   Note: the parameters need to be specified before `up` command.

1. Open the web browser:

    **Web**:
    - URL: `localhost` or `192.168.33.10`
    - Edit the local directory `www` as you needed

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

## Instalation scripts

The folder "vagrant/install" contains several installation scripts:

- **PHP** version

      sudo /vagrant/install/php.sh 5.6
      sudo /vagrant/install/php.sh 7.0
      sudo /vagrant/install/php.sh 7.1
      sudo /vagrant/install/php.sh 7.2 (default)
      sudo /vagrant/install/php.sh 7.3

- **XDebug** is debugger and profiler tool for PHP

      sudo /vagrant/install/xdebug.sh

- **SQLite** stores the entire database as a single cross-platform file

      sudo /vagrant/install/sqlite.sh

- **MariaDB** is enhanced replacement for MySQL

      sudo /vagrant/install/mariadb.sh

- **PhpMyAdmin** allows MySQL administration over the web

      sudo /vagrant/install/phpmyadmin.sh

## FixMe

- Enable port 80 forwarding triggers (Linux)

## ToDo

- Check PHP versions 7.0 (and others) with other software (MariaDB, PosgreSQL etc.)
- VM name as "parent directory"
- MariaDB (latest only)
- Better purge.sh script
- Vagrant plugins "auto installation"
- Plugin: vagrant-vbguest, vagrant-hostsupdater, vagrant-hostmanager
- Disable access to PostgreSQL system databases (postgres, template0, template1)
- Memcached
- MailDev UI - Czech date and time format
- Install script dependencies (PhpMyAdmin+PHP+MariaDB, XDebug+PHP, MailDev+Apache2)
- PhpMyAdmin cron auto update
- Vagrant config.yaml
- Convert "Info page" index.php into MVC (check PHP availability)
- DB backup/restore (project DB as extra file)
- Nginx server (php.sh, adminer.sh)
- PhpPgAdmin (latest version)

## Note

- MailCatcher "From" is not the same as "Source From" (**MailDev**, MailHog)
- https://github.com/benjaminkott/bootstrap_package_box/blob/master/Vagrantfile
- https://www.jhipster.tech/configuring-a-corporate-proxy/
