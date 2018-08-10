# vagrant-symfony

Debian Symfony (Node.js, Yarn, PostgreSQL, Adminer) stack

## Requirements
1. [VirtualBox](https://www.virtualbox.org/) + Extension Pack
2. [Vagrant](https://www.vagrantup.com/)
3. [Git](https://git-scm.com/) (optional)

## Usage

1. Download and extract ZIP file or clone the repository:

		$ git clone https://github.com/vavyskov/vagrant-symfony.git

2. Open the terminal, navigate to the directory containing the file `Vagrantfile` and run command:

		$ vagrant up

3. Open the web browser:

	Symfony:
		- URL: `localhost` or `192.168.33.10`
		- Edit the `workspace/vagrant` directory as you needed

	Adminer:
		- URL: `localhost/adminer` or `192.168.33.10/adminer`
		- System: `PostgreSQL`
		- User: `postgres`
		- Password: `postgres`
		- Database: `postgres`

4. Optionally configure your system `hosts` file:

		192.168.33.10 vagrant.example.com

	Path:
		- Linux: `/etc/hosts`
		- macOX: `/private/etc/hosts`
		- Windows: `C:\Windows\System32\drivers\etc\hosts`

## How create new project for example `my-next-project`:

1. Open the terminal, navigate to the directory containing the file `Vagrantfile` and run commands:
	
		$ vagrant ssh
		$ sudo ./new-project.sh my-next-project
		$ exit
	
2. Create new folder `workspace/my-next-project/public`.
3. Open `Vagrantfile`, add new `config.vm.synced_folder` definition and run command
	
		$ vagrant reload
	
4. Configure your system `hosts` file:

		192.168.33.10 my-next-project.example.com

5. Optionally create new database `my-next-project` (for example with `Adminer` application).