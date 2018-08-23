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
        vagrant box outdated (check updates)
          vagrant destroy
          vagrant box update
        vagrant up (reload, halt, destroy)

4. Open the web browser:

  Web:
    - URL: `localhost` or `192.168.33.10`
    - Edit the directory `workspace` as you needed

  Adminer:
    - URL: `localhost/adminer` or `192.168.33.10/adminer`
	- System: `PostgreSQL`
    - Server: `localhost`
	- User: `postgres`
	- Password: `postgres`
	- Database: `postgres`

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

    Restore: `vagrant up` (reload, resume, restore)
    
    Backup: `vagrant halt` (destroy, suspend, package, save)

## FixMe

- Force `vagrant box update` command automatically
- Enable port 80 (Linux only)

## ToDo

- Restore database only if need it (detect host computer)
- Configure e-mail sending

## Note

- https://www.jhipster.tech/configuring-a-corporate-proxy/