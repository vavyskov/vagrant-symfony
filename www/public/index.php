<?php

// External access
/*echo
  $_SERVER['SERVER_ADDR'] .' | '.
  gethostbyname($_SERVER['SERVER_NAME']) .' | '.
  $_SERVER['SERVER_NAME'] .' | '.
  gethostname() .' | '.
  gethostbyaddr($_SERVER['REMOTE_ADDR']);*/

// Not available (N/A)
$na = "<img src='asset/times.svg' alt='N/A' height='16' width='16' class='align-middle'>";

?>

<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Vagrant (public folder)</title>

    <link rel="stylesheet" href="asset/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css">
    <style>
        .container {
            max-width: 50em;
        }

        td:first-child {
            width: 40ch;
        }
    </style>
</head>

<body class="pb-5 mb-4">
<header class="bg-dark text-white mb-5 pt-4 pb-3 sticky-top">
    <div class="container">
        <div class="media">
            <i class="far fa-lightbulb fa-6x"></i>
            <div class="media-body pl-3">
                <h1>Vagrant (public folder) works!</h1>
                <p class="lead">The Virtual Machine is up and running! <i class="fas fa-smile-wink align-middle"></i>
                </p>
            </div>
        </div>
    </div>
</header>
<main class="container">
    <h2>Installed software</h2>
    <table class="table table-striped border-bottom mb-5">
        <tr>
            <td>Linux</td>
            <td>
                <?php
                echo(`lsb_release -d 2>&1` ? ltrim(strstr(`lsb_release -d`, ":"), ":") : $na);
                ?>
            </td>
        </tr>

        <tr>
            <td>Apache</td>
            <td>
                <?php
                $apache_version = explode('/', apache_get_version());
                //echo $apache_version[1];
                echo substr($apache_version[1], 0, strrpos($apache_version[1], " "));
                ?>
            </td>
        </tr>

        <tr>
            <td>PHP</td>
            <td>
                <?php
                $php_version = explode(".", phpversion());
                echo "$php_version[0].$php_version[1]";
                ?>
            </td>
        </tr>

        <tr>
            <td>SQLite</td>
            <td>
                <?php
                if (`sqlite3 --version 2>/dev/null`) {
                    $sqlite3_version = explode(" ", `sqlite3 --version`);
                    echo($sqlite3[0]);
                } else if (class_exists('SQLite3')) {
                    $sql_db = new PDO('sqlite::memory:');
                    print_r($sql_db->query('select sqlite_version()')->fetch()[0]);
                    $sql_db = null;
                } else {
                    //throw new Exception('SQLite not installed');
                    echo($na);
                }
                ?>
            </td>
        </tr>

        <tr>
            <td>MySQL</td>
            <td>
                <?php
                if (`mysql -V 2>/dev/null`) {
                    $mysql_version = explode(" ", `mysql -V`);
                    echo(substr($mysql_version[5], 0, -1));
                } else {
                    echo($na);
                }
                ?>
            </td>
        </tr>

        <tr>
            <td>PostgreSQL</td>
            <td>
                <?php
                if (`psql -V 2>&1`) {
                    $pg_version = explode(" ", `psql -V`);
                    echo($pg_version[2]);
                } else {
                    echo($na);
                }
                ?>
            </td>
        </tr>

        <tr>
            <td>MongoDB</td>
            <td>
                <?php
                if (`mongod --version 2>/dev/null`) {
                    $mongodb_version = explode(" ", `mongo --version`);
                    echo($mongodb_version[3]);
                } else {
                    echo($na);
                }
                ?>
            </td>
        </tr>

        <tr>
            <td>SSH</td>
            <td>
                <?php
                if (`ssh -V 2>&1`) {
                    $ssh_version = explode(" ", `ssh -V 2>&1`);
                    echo($ssh_version[0]);
                } else {
                    echo($na);
                }
                ?>
            </td>
        </tr>

        <tr>
            <td>Git</td>
            <td>
                <?php
                if (`git --version 2>&1`) {
                    $git_version = explode(" ", `git --version`);
                    echo($git_version[2]);
                } else {
                    echo($na);
                }
                ?>
            </td>
        </tr>

        <tr>
            <td>Composer</td>
            <td>
                <?php
                putenv("COMPOSER_HOME=/home/vagrant/.composer");
                if (`composer --version 2>&1`) {
                    $composer_version = explode(" ", `composer --version`);
                    echo($composer_version[2]);
                } else {
                    echo($na);
                }
                ?>
            </td>
        </tr>

        <tr>
            <td>Node.js</td>
            <td>
                <?php echo(`nodejs -v 2>&1` ? ltrim(`nodejs -v`, 'v') : $na); ?>
            </td>
        </tr>

        <tr>
            <td>Yarn</td>
            <td>
                <?php echo(`yarn -v 2>&1` ? `yarn -v` : $na); ?>
            </td>
        </tr>

        <tr>
            <td>Xdebug</td>
            <td>
                <?php echo(phpversion('xdebug') ? phpversion('xdebug') : $na); ?>
            </td>
        </tr>

        <tr>
            <td class="text-right">Image Magick ???</td>
            <td>
                <?php
                echo(`convert -version 2>/dev/null` ? `convert -version` : $na);
                ?>
            </td>
        </tr>

        <!--
        <tr>
            <td class="text-right">Memcached</td>
            <td>
                <?php
                /*$memcache = new Memcache;
                if ($memcache->getVersion() === false) {
                    //throw new Exception('Please, verify the Memcache configuration');
                    echo($na);
                } else {
                    echo($memcache->getVersion());
                }*/
                ?>
            </td>
        </tr>
        -->

    </table>

    <h2>PHP Extensions</h2>
    <table class='table table-striped border-bottom mb-5'>
        <?php
        $php_extension = array(
            //"SQLite (PDO)" => "sqlite3",
            //"MySQL (PDO)" => "mysqli",
            //"PostgreSQL (PDO)" => "pgsql",
            "GD" => "gd",
            "Multibyte String" => "mbstring",
            "OPcache" => "Zend OPcache",
            "XML" => "xml",
            "cURL" => "curl",
            "Zip" => "zip",
            "LDAP" => "ldap",
            //"Memcache" => "memcache",
        );
        foreach ($php_extension as $key => $value) {
            (extension_loaded($value) ? $state = 'check' : $state = 'times');
            echo "<tr><td>$key</td><td>";
            echo "<img src='asset/$state.svg' alt='N/A' height='16' width='16' class='align-middle'>";
            echo "</td></tr>";
        }
        ?>
    </table>

</main>
<footer class="bg-dark text-white-50 pt-3 pb-1 mt-5 fixed-bottom">
    <div class="container">
        <p class="text-center">Vagrant stack by VeV-VA Vyškov</p>
    </div>
</footer>

<script>
    /*const success = document.querySelectorAll(".fa-check");

    function color() {
      success.forEach(item => item.classList.add('text-success'));
    }

    window.onload = function () {
      color();
    };*/
</script>
</body>

</html>
