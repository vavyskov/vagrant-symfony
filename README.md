# vagrant-symfony

Debian Symfony (Node.js, Yarn, PostgreSQL, Adminer) stack

## Usage

### 1. Open the terminal and navigate to the directory containing the `Vagrant` file:

Run `vagrant up` to configure the `symfony.example.com` server environment.

### 2. Open the web browser:

Symfony:
- URL: `localhost` or `192.168.33.10`
- Edit the `workspace` directory as you needed

Adminer:
- URL: `localhost/adminer` or `192.168.33.10/adminer`
- System: `PostgreSQL`
- User: `Postgres`
- Password: `Postgres`
- Database: `Postgres`

### 3. Optionally configure your system `hosts` file:

    192.168.33.10 symfony.example.com

Path:
- Linux: `/etc/hosts`
- macOX: `/private/etc/hosts`
- Windows: `C:\Windows\System32\drivers\etc\hosts`
