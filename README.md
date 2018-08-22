# vagrant-symfony

Debian Symfony (Apache, PHP, Node.js, Yarn, PostgreSQL, Adminer) stack

## Requirements
1. [VirtualBox](https://www.virtualbox.org/) + Extension Pack
2. [Vagrant](https://www.vagrantup.com/) (for Windows with plugin `vagrant-winnfsd`)
  - Windows note: If your account folder name (C:\Users\account-folder-name\) contains non ASCII characters, before Vagrant instalation set custom Vagrant home path:
        
          setx VAGRANT_HOME "X:\my\vagrant\home\path"
        
4. [Git](https://git-scm.com/) (optionally)

## Usage

1. Enable CPU virtualization technology in BIOS.
2. Disable Hyper-V technology in operatin system (only for Windows).
3. Download and extract ZIP file or clone the repository:

		git clone https://github.com/vavyskov/vagrant-symfony.git

4. Open the terminal, navigate to the directory containing the file `Vagrantfile` and run command:

		vagrant plugin install vagrant-winnfsd (only for Windows)
        vagrant up
        vagrant ssh
        composer create-project symfony/website-skeleton www

5. Open the web browser:

	Symfony:
		- URL: `localhost` or `192.168.33.10`
		- Edit the `project/default` directory as you needed

	Adminer:
		- URL: `localhost/adminer` or `192.168.33.10/adminer`
		- System: `PostgreSQL`
        - Server: `localhost`
		- User: `postgres`
		- Password: `postgres`
		- Database: `postgres`

6. Optionally configure your system `hosts` file:

		192.168.33.10 vagrant.example.com

	Path:
		- Linux: `/etc/hosts`
		- macOX: `/private/etc/hosts`
		- Windows: `C:\Windows\System32\drivers\etc\hosts`

7. The database is automatically restore and backup by using the triggers:

    Restore: `vagrant up` (reload, resume, restore)
    
    Backup: `vagrant halt` (destroy, suspend, package, save)

## How create new project e.g. `my-next-project`:

1. Open the terminal, navigate to the directory containing the file `Vagrantfile` and run commands:
	
		vagrant ssh
		sudo ./new-project.sh my-next-project
		exit
	
2. Create new folder `project/my-next-project/public`.
3. Open `Vagrantfile`, add new `config.vm.synced_folder` definition and run command
	
		vagrant reload
	
4. Configure your system `hosts` file:

		192.168.33.10 my-next-project.example.com

5. Optionally create new database `my-next-project` (for example with `Adminer` application).

## Note
- https://www.jhipster.tech/configuring-a-corporate-proxy/