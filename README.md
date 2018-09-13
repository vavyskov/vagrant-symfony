# vagrant-symfony

Symfony stack (Debian, Apache, PHP, PostgreSQL, Node.js, Yarn, Adminer)

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

    Web:
    - URL: `localhost` or `192.168.33.10`
    - Edit the directory `workspace` as you needed

    Adminer:
    - URL: `localhost/adminer` or `192.168.33.10/adminer`
	- System: `PostgreSQL`
    - Server: `localhost`
	- User: `postgresql`
	- Password: `postgresql`
	- Database: `postgresql`

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

## FixMe

- chmod u+x *.sh (!!! update box !!!)
- Fix the need to Halt and Up or Reload VM immediately after crated from base box
- Fix Apache error after created new project
- Enable port 80 (Linux only)
- Apple detection do not work - port forwarding (triggers)
- ImageMagick with PHP 7.2 (image-tools.sh)
- Restore MongoDB - check if the MongoDB is installed
- Fix (Drupal) file permission on macOS

## ToDo

- Description e-mail sending configuration (php send-mail.php)
- PHP version variable (env.sh)
- Detect installed software - PHP Extensions
- Better purge.sh script
- Plugin vagrant-vbguest
- Plugin vagrant-hostsupdater (vagrant-hostmanager)
- Disable access to PostgreSQL system databases (postgres, template0, template1)

## Note

- https://github.com/benjaminkott/bootstrap_package_box/blob/master/Vagrantfile
- https://www.jhipster.tech/configuring-a-corporate-proxy/
