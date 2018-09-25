# vagrant-symfony

Symfony stack (Debian, Apache, PHP, PostgreSQL, Node.js, Yarn, Adminer, MailDev)

## Requirements
1. [VirtualBox](https://www.virtualbox.org/) + Extension Pack
2. [Vagrant](https://www.vagrantup.com/)
    - `vagrant-winnfsd` plugin (Windows only)
    - `vagrant-bindfs` plugin
    - **Windows note**: If your account folder name (C:\Users\account-folder-name\) contains non ASCII characters, before Vagrant instalation set custom Vagrant home path e.g.:
        
          setx VAGRANT_HOME "X:\my\vagrant\home\path"
        
4. [Git](https://git-scm.com/) (optional)

## Usage

1. Enable CPU virtualization technology in BIOS.

    - Disable Hyper-V technology in operatin system (Windows only).
      
2. Download and extract ZIP file or clone the repository:

        git clone https://github.com/vavyskov/vagrant-symfony.git

3. Open the terminal, navigate to the directory containing the file `Vagrantfile` and run command:

        vagrant plugin install vagrant-winnfsd (Windows only)
        vagrant plugin install vagrant-bindfs
        vagrant up (reload, halt, destroy)

4. Open the web browser:

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

5. Optional configure your system `hosts` file:

		192.168.33.10 devel.example.com

	Path:
    - Linux: `/etc/hosts`
	- macOX: `/private/etc/hosts`
	- Windows: `C:\Windows\System32\drivers\etc\hosts`

6. Open the terminal, navigate to the directory containing the file `Vagrantfile` and run command:

        vagrant ssh
        rm -r www/*
        composer create-project symfony/website-skeleton www
        composer remove symfony/web-server-bundle

7. The database is automatically restore and backup by using the triggers:

    Restore: `vagrant up` (resume, reload)
    
    Backup: `vagrant halt` (suspend, destroy)

8. Update box version

    Open the terminal, navigate to the directory containing the file `Vagrantfile` and run command:
    
    - check updates:

            vagrant box outdated
        
    - box update:
    
            vagrant destroy
            vagrant box update

## Instalation scripts

The folder "vagrant/install" contains several installation scripts:

- **XDebug** debugger and profiler tool for PHP

      sudo /vagrant/install/xdebug.sh

- **SQLite** stores the entire database as a single cross-platform file

      sudo /vagrant/install/sqlite.sh

- **MariaDB** is enhanced replacement for MySQL

      sudo /vagrant/install/mariadb.sh

- **PhpMyAdmin** allows MySQL administration over the web

      sudo /vagrant/install/phpmyadmin.sh

## FixMe

- Enable port 80 forwarding triggers (Linux)
- Restore MongoDB - check if the MongoDB is installed

## ToDo

- Convert Debian settings, Apache, PHP and PostgreSQL into install scripts
- MariaDB (latest only)
- Better purge.sh script
- Vagrant plugins "auto installation"
- Plugin: vagrant-vbguest, vagrant-hostsupdater, vagrant-hostmanager
- Disable access to PostgreSQL system databases (postgres, template0, template1)
- Memcached
- MailDev UI - Czech date and time format
- Install script dependencies (PhpMyAdmin+PHP+MariaDB, XDebug+PHP, MailDev+Apache2)
- PhpMyAdmin cron auto update

## Note

- MailCatcher "From" is not the same as "Source From" (**MailDev**, MailHog)
- https://github.com/benjaminkott/bootstrap_package_box/blob/master/Vagrantfile
- https://www.jhipster.tech/configuring-a-corporate-proxy/
